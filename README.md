# L00205530 — Irish Digital Sovereignty and IaC Supply-Chain Security

## Overview

This postgraduate project demonstrates a Policy-as-Code framework using Terraform and HashiCorp Sentinel. Its purpose is to evaluate infrastructure changes against Irish digital sovereignty, cloud security and infrastructure-as-code (IaC) supply-chain controls **before deployment**.

The project contains a small AWS Terraform demonstration configuration, six Sentinel policies, compliant and non-compliant mock fixtures, and recorded local test evidence. **The policies have been tested locally with Sentinel mocks; this repository does not demonstrate live HCP Terraform policy enforcement or deployed AWS resources.**

## Objectives

- Restrict infrastructure configuration to the approved AWS Ireland region (`eu-west-1`).
- Detect prohibited data replication or backup configurations that would undermine regional residency controls.
- Apply baseline EC2 and network security checks.
- Restrict Terraform providers and reusable modules to approved sources and constraints.
- Show both compliant and deliberately non-compliant policy outcomes, with evidence and traceable Git changes.

## Repository layout

| Path | Purpose |
| --- | --- |
| `terraform/` | AWS Terraform demonstration resources, variables, provider configuration, lock file and generated plan |
| `sentinel/` | Six Sentinel policies and `sentinel.hcl` configuration |
| `testdata/compliant/` | Mock data and test configurations intended to pass |
| `testdata/non-compliant/` | Mock data and test configurations intended to fail |
| `evidence/` | Saved plan, dependency and Sentinel test output |
| `docs/` | Detailed data-residency and module supply-chain design notes |
| `report/` | Location for the one-page technical report |

## Terraform demonstration architecture

The configuration in `terraform/main.tf` declares:

- An `aws_security_group.application` with SSH ingress on TCP port 22 restricted to `var.ssh_ingress_cidr` and HTTPS egress on TCP port 443.
- An `aws_instance.application` associated with that security group, with `associate_public_ip_address = false`.
- EC2 metadata settings with `http_tokens = var.imds_http_tokens`, defaulting to `required` (IMDSv2 token enforcement).
- An encrypted root EBS volume by default, controlled by `var.ebs_encrypted`.
- Resource tags including `Organisation`, `Environment`, and, on the instance, `ManagedBy`.

Defaults in `terraform/variables.tf` include `aws_region = "eu-west-1"`, `instance_type = "t3.small"`, and `environment = "assignment"`. The default AMI (`ami-0123456789abcdef0`) is a **placeholder**, not a verified deployable image. The SSH source `203.0.113.10/32` is an **illustrative documentation address**, not a real administrator endpoint. Replace these values and independently check the environment before any real deployment.

The Terraform example itself does not create S3 buckets, RDS databases, AWS Backup plans or external module calls. Those cases are tested with Sentinel mock fixtures rather than live resources.

## Sentinel policies

All six policies are registered in `sentinel/sentinel.hcl` with `enforcement_level = "hard-mandatory"`:

| Policy | Intended control |
| --- | --- |
| `digital-sovereignty.sentinel` | Restrict the selected AWS region to the approved Ireland region |
| `provider-supply-chain.sentinel` | Check Terraform provider source and version constraints |
| `ec2-security.sentinel` | Check selected EC2 security settings and required metadata/tags |
| `network-security.sentinel` | Check security-group exposure and approved network access |
| `data-residency.sentinel` | Detect disallowed S3 replication, RDS replication and backup-copy scenarios |
| `module-supply-chain.sentinel` | Permit explicitly allowlisted module sources and exact approved versions |

The module policy's documented allowlist includes `terraform-aws-modules/vpc/aws` at version `5.1.0`; unapproved Git module sources, missing versions, floating versions and unapproved publishers are rejected in the local mock tests. See `docs/module-supply-chain.md` for its scope and limitations, and `docs/data-residency.md` for the residency policy's design.

**Scope note:** These are the policy intentions demonstrated by the repository's tests. Local mock outcomes do not prove that every possible real-world Terraform configuration is covered.

## Prerequisites

- Git
- Terraform CLI (the project was developed with Terraform v1.16.6)
- HashiCorp Sentinel CLI (the project was tested with Sentinel v0.41.0)
- Access to the repository files

AWS credentials are not required to rerun the local Sentinel mock tests. Terraform commands that contact providers or create real infrastructure may have additional requirements and must not be assumed safe merely because mock tests pass.

## Reproduce the local validation

From the repository root in PowerShell:

```powershell
cd .\terraform
terraform init
terraform validate
cd ..\sentinel
sentinel apply
```

The default `sentinel.hcl` imports compliant mock data from `testdata/compliant/`. The recorded integration run reports **PASS for all six policies**; see `evidence/sentinel-integration-six-policies.txt`.

To test the module supply-chain policy with an approved module:

```powershell
sentinel apply -config="../testdata/compliant/approved-module-config.hcl" module-supply-chain.sentinel
```

To test rejection of an untrusted module:

```powershell
sentinel apply -config="../testdata/non-compliant/untrusted-module-config.hcl" module-supply-chain.sentinel
```

A `Fail` result in the second command is **expected**: it demonstrates that the non-compliant mock is rejected. Other test configurations under `testdata/compliant/` and `testdata/non-compliant/` exercise additional controls. Inspect each `.hcl` fixture before running it, and compare output with the corresponding file in `evidence/`.

The checked-in `terraform/tfplan` is a generated demonstration artifact. It is not evidence that resources were deployed. Do not apply it without reviewing the plan, correcting placeholder settings and understanding any potential costs or risks.

## Testing and evidence

Testing was performed locally using Windows PowerShell, Terraform CLI and HashiCorp Sentinel CLI.

### Testing and Validation

- All six Sentinel policies passed the compliant baseline evaluation.
- Positive and negative tests verified acceptance of compliant configurations and rejection of selected policy violations.
- Terraform initialisation, configuration validation and plan generation were completed.
- A total of 24 screenshots document Terraform testing, Sentinel evaluations and Git workflow activity.

The screenshots are organised by category in the [Screenshot Evidence Index](screenshots/README.md).

The repository records positive and negative test outcomes across multiple controls. Key evidence includes:

- `evidence/sovereignty-pass.txt` and `evidence/sovereignty-fail.txt`
- `evidence/provider-policy-pass.txt`, `evidence/provider-policy-fail.txt`, and `evidence/provider-lock-verification.txt`
- `evidence/ec2-security-pass.txt`, `evidence/ec2-security-fail.txt`, and `evidence/ec2-regression-report.md`
- `evidence/network-https-pass.txt`, `evidence/network-open-ssh-fail.txt`, and `evidence/network-ipv6-ssh-fail.txt`
- `evidence/s3-replication-fail.txt`, `evidence/rds-replica-fail.txt`, and `evidence/backup-cross-region-fail.txt`
- `evidence/module-approved-pass.txt`, `evidence/module-untrusted-fail.txt`, `evidence/module-missing-version-fail.txt`, `evidence/module-floating-version-fail.txt`, and `evidence/module-unapproved-publisher-fail.txt`
- `evidence/sentinel-integration-six-policies.txt`

These are **recorded local test outputs**. Evidence files should be checked against current source and rerun if the policies or fixtures change.

## Security design decisions and trade-offs

**Ireland region restriction.** Limiting the configured AWS region supports a data-sovereignty objective, but a region setting alone does not prove that all data, metadata, logs, backups or service dependencies remain in Ireland.

**EC2 hardening.** The example disables a public IP, defaults to encrypted root storage and requires IMDSv2 tokens. These measures reduce selected risks but do not replace operating-system patching, IAM least privilege or vulnerability management.

**Network controls.** SSH ingress is restricted to a single illustrative CIDR, rather than an unrestricted internet source; outbound traffic is limited to HTTPS in the example. Actual access requirements and other network paths would need review for production.

**Supply-chain allowlisting.** Provider and module source restrictions reduce unreviewed dependencies. Exact module version approval improves reproducibility, but neither version constraints nor allowlists independently verify that a dependency is vulnerability-free or cryptographically trustworthy. The Terraform provider lock file does not lock module dependencies.

**Fail-closed policy design.** Selected residency scenarios are rejected when they do not satisfy the required policy conditions. Additional AWS services, Terraform constructs and edge cases may still require coverage.

## Git workflow

Development used feature branches, focused commits, local validation, and pull requests merged into `main`. The module supply-chain feature was merged in pull request **#8**, following corrective commits to align mocks with the `tfconfig/v2` schema and refresh regression evidence. Git history and the pull request records provide traceability of the development process.

## Limitations and future improvements

- Sentinel was validated using local mocks; live HCP Terraform enforcement has **not** been verified.
- The sample AWS resources were **not deployed** as part of the demonstrated test evidence.
- Mock fixtures test selected conditions and cannot establish complete coverage of all Terraform plans or AWS services.
- The region policy is not a comprehensive legal or technical guarantee of data sovereignty.
- The module policy currently rejects Git-based modules rather than supporting an approved repository-and-commit-SHA model.
- Supply-chain controls could be strengthened with dependency scanning, code review, publisher verification and automated CI checks.
- A real deployment would require a valid AMI, a legitimate administrator CIDR, appropriate AWS credentials and a security/cost review.

## Research and AI assistance

AI assistance was used to help explain Terraform/Sentinel concepts, propose test cases, troubleshoot fixture syntax and draft documentation. Commands and policy results were executed and checked locally by the student. The final submission should include a truthful account of prompts, generated suggestions, independent verification and any modifications made, in the format required by the module. **Do not treat this paragraph alone as a substitute for an explicit prompt-level disclosure if the assessment requires one.**

### Project Documentation

| Document | Purpose |
|---|---|
| [Screenshot Evidence Index](screenshots/README.md) | Direct access to 24 testing screenshots |
| [Technical Report](report/technical-report.md) | One-page technical report |
| [Research and AI Usage](docs/research-and-ai-usage.md) | Research references and AI disclosure |
| [Test Evidence](evidence/) | Saved Sentinel test results |
| [Test Configurations](testdata/) | Compliant and non-compliant test fixtures |

