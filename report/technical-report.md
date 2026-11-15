# Technical Report — Irish Digital Sovereignty and IaC Supply-Chain Security

**Student ID:** L00205530  
**Project:** Terraform and HashiCorp Sentinel Policy-as-Code Framework

### Purpose and implementation

This project evaluates how Policy-as-Code can support digital sovereignty and infrastructure-as-code (IaC) supply-chain security for an Irish organisation. Terraform defines a small AWS demonstration configuration, while six HashiCorp Sentinel policies evaluate selected security and compliance requirements before infrastructure deployment.

The Terraform configuration targets AWS Ireland (`eu-west-1`) and demonstrates EC2 security controls, including encrypted root storage, mandatory IMDSv2, restricted SSH access and no public IP address.

Six Sentinel policies cover geographical restrictions, provider supply-chain security, EC2 configuration, network security, data residency and trusted Terraform modules. Provider and module restrictions aim to reduce exposure to unapproved dependencies.

### Testing and results

Testing was performed locally using Windows PowerShell, Terraform CLI, Sentinel CLI and compliant/non-compliant mock configurations.

All six Sentinel policies passed the compliant baseline evaluation. Additional negative tests demonstrated rejection of selected violations, including unrestricted SSH access, prohibited cross-region replication, untrusted module sources and missing or floating module versions.

Terraform validation, the generated `tfplan`, Sentinel evaluation outputs and dependency verification are documented in the GitHub repository. Screenshot evidence is organised under `screenshots/`, with an accompanying index.

### Limitations

**The implementation demonstrates local Sentinel policy evaluation, not live enforcement in HCP Terraform.** No HCP Terraform policy set was integrated, and no AWS infrastructure was deployed. Therefore, the results demonstrate policy decisions against test fixtures rather than verified prevention of production deployments.

Region restrictions alone cannot guarantee complete Irish data sovereignty because logs, metadata, administrative access and service dependencies may cross jurisdictional boundaries.

Sentinel checks are limited to explicitly implemented conditions. Provider allowlists and version constraints do not independently guarantee dependency integrity or eliminate software vulnerabilities.

### Recommendations and conclusion

Future improvements should integrate Sentinel with HCP Terraform, validate policies against representative live Terraform plans, expand resource coverage and introduce automated regression testing, dependency scanning and provenance verification.

The project demonstrates the value of Policy-as-Code for identifying selected infrastructure risks before deployment. However, effective digital sovereignty requires additional operational, organisational and jurisdictional controls beyond Terraform and Sentinel.

## Reflection

The main learning outcome was separating **configuration intent**, **policy decisions**, and **evidence of enforcement**. Positive tests show approved examples are accepted; negative tests demonstrate that selected violations are rejected. Both are needed, but neither replaces testing against real deployment workflows. AI assistance supported troubleshooting and documentation; local commands and results were checked during development.

**Repository:** https://github.com/L00205530/L00205530-digital-sovereignty