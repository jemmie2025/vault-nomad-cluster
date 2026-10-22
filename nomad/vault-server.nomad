# DRAFT — infrastructure review and validation required.
# Runtime Vault configuration is embedded below.
# config/vault.hcl.example is a reference example.

variable "vault_image" {
  type        = string
  description = "Approved hashicorp/vault image with a specific version tag or digest."
}

variable "datacenter" {
  type        = string
  description = "Confirmed Nomad datacenter."
}

variable "raft_peer_urls" {
  type = list(string)

  default = [
    "https://vault-1.example.invalid:8200",
    "https://vault-2.example.invalid:8200",
    "https://vault-3.example.invalid:8200",
  ]

  description = "Replace with the three confirmed Vault API URLs."
}

job "vault-server" {
  datacenters = [var.datacenter]
  type        = "service"

  constraint {
    attribute = "${meta.vault_eligible}"
    value     = "true"
  }

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "vault" {
    count          = 3
    shutdown_delay = "10s"

    constraint {
      operator = "distinct_hosts"
      value    = "true"
    }

    update {
      max_parallel      = 1
      min_healthy_time  = "30s"
      healthy_deadline  = "30m"
      progress_deadline = "45m"
      auto_revert       = false
    }

    network {
      mode = "host"

      port "api" {
        static = 8200
      }

      port "cluster" {
        static = 8201
      }
    }

    volume "vault-data" {
      type      = "host"
      source    = "vault-data"
      read_only = false
    }

    volume "vault-audit" {
      type      = "host"
      source    = "vault-audit"
      read_only = false
    }

    volume "vault-tls" {
      type      = "host"
      source    = "vault-tls"
      read_only = true
    }

    service {
      name         = "vault"
      provider     = "consul"
      port         = "api"
      address_mode = "host"

      check {
        name            = "vault-ready"
        type            = "http"
        protocol        = "https"
        path            = "/v1/sys/health?standbyok=true"
        interval        = "10s"
        timeout         = "5s"
        tls_skip_verify = false
      }
    }

    task "vault" {
      driver = "docker"

      config {
        image        = var.vault_image
        network_mode = "host"

        args = [
          "server",
          "-config=/local/vault.hcl",
        ]
      }

      env {
        # Host swap must also be disabled when using this setup.
        SKIP_SETCAP = "true"
      }

      volume_mount {
        volume      = "vault-data"
        destination = "/vault/data"
        read_only   = false
      }

      volume_mount {
        volume      = "vault-audit"
        destination = "/vault/audit"
        read_only   = false
      }

      volume_mount {
        volume      = "vault-tls"
        destination = "/vault/tls"
        read_only   = true
      }

      template {
        destination = "local/vault.hcl"
        perms       = "0644"
        change_mode = "restart"

        data = <<-EOF
          ui            = true
          disable_mlock = true
          log_level     = "info"

          api_addr     = "https://{{ env "NOMAD_IP_api" }}:8200"
          cluster_addr = "https://{{ env "NOMAD_IP_cluster" }}:8201"

          listener "tcp" {
            address         = "0.0.0.0:8200"
            cluster_address = "0.0.0.0:8201"

            tls_disable     = false
            tls_min_version = "tls12"
            tls_cert_file   = "/vault/tls/vault-cert.pem"
            tls_key_file    = "/vault/tls/vault-key.pem"
          }

          storage "raft" {
            path    = "/vault/data"
            node_id = "{{ env "node.unique.id" }}"

          %{for peer in var.raft_peer_urls}
            retry_join {
              leader_api_addr     = "${peer}"
              leader_ca_cert_file = "/vault/tls/ca.pem"
            }
          %{endfor}
          }
        EOF
      }

      resources {
        cpu    = 1000
        memory = 1024
      }

      kill_signal  = "SIGTERM"
      kill_timeout = "30s"
    }
  }
}