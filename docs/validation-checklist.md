# Deployment and Validation Checklist

Status: Preparation only. Infrastructure access is pending.

Mark an item complete only after verification.
Record the date, result, and sanitized evidence for each check.

## 1. Infrastructure Readiness

- [ ] Confirm three target hosts and operator access.
- [ ] Verify Nomad client mode on each target host.
- [ ] Verify Docker availability on each target host.
- [ ] Confirm Nomad and Consul versions and access permissions.
- [ ] Confirm the approved Vault image version.
- [ ] Confirm DNS names, TLS certificates, and trusted CA.
- [ ] Verify required connectivity on ports 8200 and 8201.
- [ ] Confirm available CPU, memory, and persistent disk space.
- [ ] Identify key custodians and secure credential storage.

## 2. Configuration

- [ ] Pin the official HashiCorp Vault image version.
- [ ] Configure exactly three instances on distinct eligible hosts.
- [ ] Configure persistent host volumes and permissions.
- [ ] Configure unique, stable Raft node identities.
- [ ] Configure retry_join and TLS verification.
- [ ] Configure reachable API and cluster addresses.
- [ ] Enable the Vault UI.
- [ ] Configure Consul service registration.
- [ ] Configure health checks that recognize healthy standbys.
- [ ] Ensure sealed health checks do not cause restart loops.
- [ ] Validate job syntax and review the Nomad deployment plan.

## 3. Deployment and Initialization

- [ ] Confirm all three allocations are running on separate hosts.
- [ ] Review startup logs and verify volume mounts.
- [ ] Verify TLS and inter-node connectivity.
- [ ] Initialize the first node only, using five shares and threshold three.
- [ ] Securely distribute unseal shares and protect the initial root token.
- [ ] Unseal the first node.
- [ ] Join and unseal the second and third nodes.
- [ ] Confirm three voting Raft peers: one leader and two followers.
- [ ] Confirm all nodes are unsealed and HA is enabled.
- [ ] Verify Vault UI access over HTTPS.

## 4. Access and Auditing

- [ ] Enable a persistent audit device and plan log rotation.
- [ ] Enable the KV v2 secrets engine.
- [ ] Create and test an administrator policy and authentication method.
- [ ] Verify permitted operations succeed.
- [ ] Verify unauthorized operations are denied.
- [ ] Verify audit records are written.
- [ ] Confirm independent administrator access before revoking root.
- [ ] Revoke the initial root token after bootstrap.
- [ ] Document emergency root generation procedures.

## 5. Operational Validation

- [ ] Write and read a non-sensitive test secret.
- [ ] Restart one standby, unseal it, and verify data persistence.
- [ ] Confirm all three nodes are healthy before failover testing.
- [ ] Seal the leader during a coordinated test window.
- [ ] Verify a new leader is elected and the test secret remains readable.
- [ ] Unseal the previous leader and confirm it rejoins.
- [ ] Verify health monitoring detects sealed or unavailable nodes.
- [ ] Create and securely store a Raft snapshot.
- [ ] Test snapshot restoration in an isolated environment.
- [ ] Restore full cluster health and remove test secrets.

## 6. Handover

- [ ] Complete the deployment and operations runbook.
- [ ] Document unseal, failover, backup, and recovery procedures.
- [ ] Record actual time spent on each task stage.
- [ ] Add sanitized validation evidence.
- [ ] Update the README with verified results and remaining limitations.
- [ ] Obtain the infrastructure owner's handover review.