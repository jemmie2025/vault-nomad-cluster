# Local Nomad Job Validation

## Environment

- WSL Ubuntu
- Nomad CLI: 2.0.4

## Checks Completed

- Formatted `nomad/vault-server.nomad` using `nomad fmt`.
- Validated the job using temporary image and datacenter values.
- Added a 10-second shutdown delay to resolve the service warning.
- Re-ran validation successfully.

## Result

Local job validation passed.

## Limitations

- Driver configuration was not validated because no local
  Nomad agent was available.
- The image and datacenter values were validation placeholders.
- Embedded Vault configuration and TLS have not been runtime-tested.
- Infrastructure access, deployment, and HA testing remain pending.
- No Vault cluster has been deployed.