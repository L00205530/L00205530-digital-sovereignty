# Terraform Module Supply Chain Security

## Objective

The L00205530 Digital Sovereignty Framework restricts
Terraform module dependencies to explicitly approved sources
and versions.

## Implemented Controls

The module-supply-chain.sentinel policy evaluates Terraform
module declarations using the tfconfig/v2 import.

Only modules included in the approved_modules allowlist are
permitted.

The currently approved module is:

- Source: terraform-aws-modules/vpc/aws
- Version: 5.1.0

All other module sources are rejected.

The policy requires the exact approved version constraint.
Floating version constraints and missing versions are rejected.

Git-based modules are currently blocked, including repositories
that use immutable commit references.

## Testing

The following scenarios were validated using Sentinel mocks:

1. No external modules - PASS
2. Approved module with exact version - PASS
3. Untrusted Git module - FAIL
4. Approved module without version - FAIL
5. Approved module with floating version - FAIL
6. Unapproved registry publisher - FAIL

All six registered Sentinel policies passed integration testing.

Test evidence is stored in the evidence/ directory.

## Limitations

The tests use local Sentinel mock data. Real HCP Terraform
policy enforcement has not yet been verified.

Source approval and exact version constraints do not
independently guarantee module integrity or security.

The current implementation does not inspect module source
code, verify module publisher identity cryptographically,
or provide continuous dependency monitoring.

Terraform module dependencies are not covered by the
provider dependency lock file.

## Future Improvements

- Validate policy behavior against real HCP Terraform runs.
- Implement approved Git repository and commit-SHA rules.
- Add dependency vulnerability scanning.
- Review and approve module version updates.
- Integrate automated supply-chain checks into CI/CD.
