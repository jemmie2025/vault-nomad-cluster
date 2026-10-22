# HashiCorp Vault HA Cluster on Nomad

Deployment project for a three-node HashiCorp Vault cluster using
Integrated Raft Storage on Glynac AI infrastructure.

## Status

Preparation in progress. Infrastructure access is pending.
The cluster has not been deployed or validated.

## Objective

Centralize secrets management with persistent storage,
access policies, audit logging, and high availability.

## Planned Architecture

- Three Vault instances placed on three separate eligible hosts.
- Nomad schedules the containers; Consul registers the services.
- Integrated Raft Storage uses persistent host volumes.
- TLS protects API traffic on port 8200.
- Port 8201 supports internal cluster communication.
- Shamir unsealing requires three of five key shares.

## Project Structure

- `nomad/`: Vault deployment job.
- `config/`: Nomad client configuration examples.
- `policies/`: Vault access policies.
- `docs/`: Deployment runbook and validation checklist.
- `evidence/`: Sanitized evidence of completed checks.

## Deployment Dependencies

- Access to Nomad, Consul, and the three target hosts.
- Confirmation that target hosts run Nomad clients.
- Approved Vault image version.
- DNS names, TLS certificates, and trusted CA.
- Persistent storage and required network connectivity.
- Designated key custodians and approved credential storage.

## Planned Validation

- Verify three running allocations on separate hosts.
- Confirm one Raft leader and two followers.
- Verify all nodes are initialized and unsealed.
- Test secret persistence after a controlled restart.
- Test leader failover and restore full cluster health.
- Verify policies, audit logging, and health monitoring.
- Create a Raft snapshot and test recovery in isolation.

## Security

Never commit tokens, unseal keys, private keys, initialization
output, Raft data, or snapshots. Review screenshots and logs
before adding them as evidence.