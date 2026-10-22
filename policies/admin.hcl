# DRAFT — routine operations administrator policy.
# Assumes KV v2 is mounted at "kv/".
# Requires review and live permission testing before use.
# Does not grant policy/auth management or disaster recovery.

# Inspect cluster health and leadership.
path "sys/health" {
  capabilities = ["read"]
}

path "sys/leader" {
  capabilities = ["read"]
}

path "sys/seal-status" {
  capabilities = ["read"]
}

path "sys/storage/raft/configuration" {
  capabilities = ["read"]
}

# Download a Raft snapshot; does not permit restoration.
path "sys/storage/raft/snapshot" {
  capabilities = ["read"]
}

# Create, read, update, patch, and soft-delete secrets.
path "kv/data/*" {
  capabilities = ["create", "read", "update", "patch", "delete"]
}

# Browse secret names and inspect version metadata.
path "kv/metadata" {
  capabilities = ["list"]
}

path "kv/metadata/*" {
  capabilities = ["read", "list"]
}

# Soft-delete or restore selected secret versions.
path "kv/delete/*" {
  capabilities = ["update"]
}

path "kv/undelete/*" {
  capabilities = ["update"]
}

# Inspect and manage the user's own token.
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}