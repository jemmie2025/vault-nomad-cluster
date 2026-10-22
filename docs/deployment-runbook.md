# Vault Deployment and Operations Runbook

## Current Status

Preparation only. Local Nomad job validation passed.
Driver validation, Vault runtime testing, and deployment are pending.

## 1. Confirm Infrastructure

Before deployment, confirm:

- Three approved target hosts with Nomad client mode enabled.
- Operator access to Nomad, Consul, and the target hosts.
- Nomad datacenter and available host resources.
- Approved, version-pinned HashiCorp Vault image.
- Private network addresses and connectivity on ports 8200 and 8201.
- DNS names, TLS certificates, and trusted certificate authority.
- Designated unseal-key custodians and secure credential storage.

Apply `vault_eligible = "true"` only to the verified target hosts.

## 2. Prepare Persistent Storage and TLS

On each target host:

- Create separate persistent directories for Vault data and audit logs.
- Create the TLS directory and install the host's certificate,
  private key, and CA certificate.
- Verify permissions against the selected container image's user.
- Merge the host-volume declarations into the existing Nomad
  client configuration.
- Confirm host swap is disabled for the planned Raft configuration.
- Verify that Nomad recognizes the volumes.

Expected host-to-container mappings:

| Host directory | Container directory |
|---|---|
| /opt/vault/data | /vault/data |
| /opt/vault/audit | /vault/audit |
| /opt/vault/tls | /vault/tls |

Never share one Raft data directory between Vault nodes.

## 3. Finalize and Review the Job

- Supply the confirmed datacenter and approved image version.
- Replace all placeholder peer URLs.
- Finalize Consul-based join discovery for the actual environment.
- Confirm certificates cover advertised IPs and peer DNS names.
- Ensure the Consul health-check agent trusts the issuing CA.
- Review resource sizing, network exposure, and restart behavior.
- Run formatting, validation, and a Nomad deployment plan.

Local validation alone does not prove deployment readiness.

## 4. Deploy and Bootstrap

- Submit the reviewed job.
- Verify three allocations on three distinct hosts.
- Inspect startup logs, volume mounts, and service registration.
- Expect unhealthy readiness checks until initialization and unsealing.
- Initialize only the first Vault node with five key shares
  and a threshold of three.
- Securely distribute the shares and protect the initial root token.
- Unseal the first node.
- Confirm the remaining nodes join the same cluster and unseal them
  using shares from that initialization.
- Verify three voting peers, one leader, and two followers.

Never initialize the remaining nodes as independent clusters.
Never place initialization output in Git, screenshots, or task comments.

## 5. Configure Access and Auditing

- Enable persistent audit logging and configure log rotation.
- Enable KV v2 at the agreed mount path.
- Finalize administrator and service policies.
- Configure the approved administrator authentication method.
- Test both permitted and denied operations.
- Verify audit records are written.
- Confirm independent administrator access before revoking
  the initial root token.
- Document emergency root-generation procedures.

Mounting the audit directory does not enable audit logging.

## 6. Validate Operations

Use the validation checklist to record:

- HTTPS API and UI access.
- Secret write/read using non-sensitive test data.
- Persistence after restarting and unsealing one standby.
- Leader failover during a coordinated test window.
- Recovery of the previous leader and full cluster health.
- Alerts for sealed or unavailable nodes.
- Snapshot creation and restoration in an isolated environment.

Do not disrupt another node until the cluster is healthy again.

## 7. Routine Unsealing

After a restart with Shamir sealing:

- Confirm the node address and TLS identity.
- Have authorized custodians supply three distinct shares
  through the interactive unseal process.
- Verify the node is unsealed and participating in the cluster.

Do not pass unseal shares as command-line arguments or record them
in terminal transcripts.

## 8. Backup and Recovery

- Store Raft snapshots in an approved, access-controlled location
  separate from the Vault hosts.
- Preserve the required unseal shares separately.
- Define backup frequency, retention, ownership, and restore testing.
- Test restoration in isolation before relying on the procedure.
- Treat loss of the required unseal-key threshold as a critical
  recovery limitation: a snapshot alone cannot replace those keys.

## 9. Handover

Record:

- Deployed versions and configuration.
- Verified results and sanitized evidence.
- Key-custody and operational owners.
- Monitoring and backup responsibilities.
- Known limitations and outstanding follow-up work.
- Actual time spent on each task stage.