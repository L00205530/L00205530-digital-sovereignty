# Technical Report — Irish Digital Sovereignty and IaC Supply-Chain Security

**Student ID:** L00205530  
**Project:** Terraform and HashiCorp Sentinel Policy-as-Code Framework

## Purpose and approach

This project explores how Policy-as-Code can help an Irish organisation review cloud infrastructure changes before deployment. Terraform defines a small AWS demonstration environment, while six HashiCorp Sentinel policies evaluate selected regional, security and software supply-chain requirements. The implementation is intended as a reproducible proof of concept, **not** a deployed or independently certified sovereignty solution.

## Design and security decisions

The Terraform example selects `eu-west-1` (Ireland) by default and defines an EC2 instance with no public IP address, encrypted root EBS storage by default, and IMDSv2 token enforcement. Its security group restricts SSH ingress to a configurable `/32` address and permits HTTPS egress. The default AMI and SSH address are illustrative placeholders and require replacement before deployment.

Six Sentinel policies are configured as `hard-mandatory`: **digital sovereignty** (approved region), **provider supply chain** (provider source and version constraints), **EC2 security** (selected instance protections and metadata), **network security** (security-group exposure), **data residency** (selected S3, RDS and backup replication scenarios), and **module supply chain** (approved module sources and exact versions). The module allowlist permits `terraform-aws-modules/vpc/aws` at version `5.1.0` in the tested configuration. Allowlisting is deliberately restrictive to reduce unreviewed dependencies.

## Validation and evidence

Local `sentinel apply` integration testing returned **PASS for all six policies** with compliant mocks. Separate negative fixtures demonstrated rejection of selected unsafe configurations, including unrestricted or unapproved SSH access, prohibited cross-region data movement, untrusted module sources, and missing or floating module versions. The module supply-chain suite included a compliant baseline, an approved versioned module and four rejection cases. Test outputs are retained under `evidence/`, including `sentinel-integration-six-policies.txt`; source fixtures are in `testdata/`. Terraform configuration validation and provider dependency lock evidence are also included. Feature branches, incremental commits and eight merged pull requests document the development workflow.

## Limitations and improvements

**Local mock tests do not establish live enforcement.** No HCP Terraform Sentinel enforcement or AWS deployment is demonstrated. The Terraform example contains no real S3, RDS or backup resources; those controls are exercised using mocks. Restricting the AWS region does not, by itself, guarantee that all data, logs, metadata or managed-service dependencies remain in Ireland. Policy coverage is limited to the resource types and conditions explicitly checked, and source/version allowlists do not detect vulnerabilities or verify module code integrity. The Terraform provider lock file does not lock modules.

Future work should validate policies against real Terraform configuration and plan data, test supported HCP Terraform enforcement, expand service and edge-case coverage, add approved Git commit-SHA rules, and introduce automated dependency scanning and policy regression checks in CI/CD.

## Reflection

The main learning outcome was separating **configuration intent**, **policy decisions**, and **evidence of enforcement**. Positive tests show approved examples are accepted; negative tests demonstrate that selected violations are rejected. Both are needed, but neither replaces testing against real deployment workflows. AI assistance supported troubleshooting and documentation; local commands and results were checked during development, and AI usage should be disclosed separately in the format required by the assignment.
