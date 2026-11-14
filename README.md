\# L00205530 – Digital Sovereignty and IaC Supply Chain Security



\## 1. Project Overview



This project demonstrates the use of Infrastructure as Code (IaC) and Policy as Code (PaC) to enforce security and digital sovereignty requirements for cloud infrastructure.



The implementation uses Terraform to define AWS infrastructure and HashiCorp Sentinel to evaluate security policies against Terraform configuration and plan data.



The project focuses on three areas:



1\. Irish digital sovereignty and regional restrictions.

2\. Terraform provider supply-chain security.

3\. AWS EC2 infrastructure security.



The infrastructure is designed for local planning and policy validation. No AWS resources were deployed as part of this implementation.



\## 2. Project Objectives



The objectives are to:



\- Restrict the configured AWS region to Ireland (`eu-west-1`).

\- Restrict Terraform provider declarations to approved sources and version constraints.

\- Enforce baseline security requirements for EC2 instances.

\- Demonstrate compliant and non-compliant policy evaluations.

\- Maintain evidence of policy execution and regression testing.

\- Use feature branches, meaningful Git commits and pull requests to manage development.



\## 3. Technologies



| Technology | Purpose |

|---|---|

| Terraform | Infrastructure as Code |

| HashiCorp Sentinel | Policy as Code |

| AWS provider | Defines AWS infrastructure resources |

| Git | Version control |

| GitHub | Repository hosting and pull requests |

| PowerShell | Local development and testing |



\## 4. Terraform Infrastructure



The Terraform configuration is located in the `terraform/` directory.



\### 4.1 Infrastructure resources



The configuration defines two AWS resources.



\*\*EC2 instance\*\*



The `aws\_instance.application` resource uses the following default security settings:



\- Instance type: `t3.small`

\- Public IP assignment: disabled

\- Root EBS encryption: enabled

\- IMDSv2 tokens: required

\- Organisation tag: `L00205530`

\- Environment tag: `assignment`

\- ManagedBy tag: `Terraform`



\*\*Security group\*\*



The `aws\_security\_group.application` resource defines:



\- Inbound SSH access on TCP port 22, restricted to the configured source CIDR.

\- Outbound HTTPS access on TCP port 443.



The default SSH CIDR, `203.0.113.10/32`, is an example documentation address rather than a production administration endpoint.



\### 4.2 Terraform configuration files



| File | Purpose |

|---|---|

| `main.tf` | EC2 instance and security group |

| `providers.tf` | AWS provider configuration |

| `variables.tf` | Input variables and defaults |

| `versions.tf` | Terraform and provider version requirements |

| `outputs.tf` | Infrastructure configuration outputs |

| `.terraform.lock.hcl` | Provider dependency lock information |

| `tfplan` | Generated Terraform plan artifact |



The Terraform configuration requires Terraform version `>= 1.6.0, < 2.0.0` and AWS provider version `\~> 5.0`.



The project retains `tfplan` in the repository because it is an explicit assignment deliverable. Generated plans should normally be handled carefully because they may contain sensitive information.



\## 5. Sentinel Policy Framework



Three Sentinel policies are implemented in the `sentinel/` directory.



All three are registered in `sentinel.hcl` with the `hard-mandatory` enforcement level.



\### 5.1 Digital Sovereignty Policy



\*\*File:\*\* `sentinel/digital-sovereignty.sentinel`



This policy imports `tfplan/v2` and evaluates the Terraform `aws\_region` variable.



The approved region is:



`eu-west-1` – AWS Europe (Ireland)



A compliant configuration passes the policy. A configuration specifying an unapproved region fails.



This is an initial regional control. It does not independently prove that every cloud resource or data transfer remains within Ireland.



\### 5.2 Provider Supply-Chain Security Policy



\*\*File:\*\* `sentinel/provider-supply-chain.sentinel`



This policy imports `tfconfig/v2` and evaluates the Terraform provider declarations.



The approved provider is:



`registry.terraform.io/hashicorp/aws`



The required version constraint is:



`\~> 5.0`



Provider declarations that do not match these requirements are rejected.



The Terraform dependency lock file separately records the selected provider version and integrity hashes. The policy does not independently validate downloaded provider binaries or the lock file's integrity.



\### 5.3 EC2 Infrastructure Security Policy



\*\*File:\*\* `sentinel/ec2-security.sentinel`



This policy imports `tfplan/v2` and evaluates EC2 resources undergoing creation or update.



The policy enforces the following requirements:



| Security control | Requirement |

|---|---|

| Approved instance types | `t3.micro`, `t3.small`, `t3.medium` |

| Public IP assignment | Disabled |

| Root EBS encryption | Enabled |

| IMDSv2 | `http\_tokens = "required"` |

| Organisation tag | Present and non-empty |

| Environment tag | Present and non-empty |



The policy also evaluates replacement operations containing a create action.



Deletion-only plans and plans without EC2 creation or update operations are permitted.



\## 6. Local Setup and Validation



The project was developed and tested using Windows PowerShell.



\### 6.1 Terraform initialization



From the project root:



```powershell

terraform -chdir=terraform init -lockfile=readonly

```



\### 6.2 Validate Terraform configuration



```powershell

terraform -chdir=terraform validate

```



\### 6.3 Inspect the Terraform plan



```powershell

terraform -chdir=terraform show tfplan

```



The default AMI identifier is illustrative. This configuration is intended for planning and policy testing rather than production deployment.



\### 6.4 Run all Sentinel policies



```powershell

Push-Location .\\sentinel

sentinel apply

Pop-Location

```



The compliant mock configuration is expected to produce:



```text

Pass - digital-sovereignty.sentinel

Pass - ec2-security.sentinel

Pass - provider-supply-chain.sentinel

```



\### 6.5 Run an EC2 negative test



```powershell

Push-Location .\\sentinel



sentinel apply `

&#x20;   -config="../testdata/non-compliant/ec2-config.hcl" `

&#x20;   ec2-security.sentinel



Pop-Location

```



The expected result is:



`Fail - ec2-security.sentinel`



This is a successful negative test because the policy correctly rejects the insecure configuration.



\## 7. Testing and Validation



The project uses Sentinel mock data to evaluate compliant and non-compliant configurations.



Test fixtures are stored under:



\- `testdata/compliant/`

\- `testdata/non-compliant/`



\### 7.1 EC2 regression testing



| Test scenario | Expected | Observed |

|---|---|---|

| Secure EC2 configuration | PASS | PASS |

| Insecure EC2 configuration | FAIL | FAIL |

| Missing IMDSv2 requirement | FAIL | FAIL |

| Missing root EBS encryption | FAIL | FAIL |

| Missing Organisation tag | FAIL | FAIL |

| Missing Environment tag | FAIL | FAIL |

| Insecure EC2 replacement | FAIL | FAIL |

| Deletion-only operation | PASS | PASS |

| Empty EC2 plan | PASS | PASS |



All nine scenarios produced their expected outcomes during local testing.



\### 7.2 Integration testing



The three registered Sentinel policies passed together using the compliant mock configuration.



\### 7.3 Regression defect



During testing, the EC2 policy initially rejected deletion-only plans because it required at least one EC2 creation or update operation.



The issue was reproduced, documented and corrected.



Relevant commits:



\- `b498bfe` – Reproduced the deletion-only rejection.

\- `33023dd` – Corrected deletion-only and empty-plan handling.

\- `f5d0387` – Recorded regression test results.



This demonstrates an incremental test-and-fix development workflow.



\## 8. Test Evidence



Test outputs are stored in the `evidence/` directory.



Key files include:



| Evidence file | Description |

|---|---|

| `sovereignty-pass.txt` | Approved region test |

| `sovereignty-fail.txt` | Unapproved region test |

| `provider-policy-pass.txt` | Approved provider test |

| `provider-policy-fail.txt` | Rejected provider test |

| `provider-lock-verification.txt` | Provider lock verification evidence |

| `ec2-security-pass.txt` | Secure EC2 test |

| `ec2-security-fail.txt` | Insecure EC2 test |

| `ec2-deletion-before-fix.txt` | Original deletion-only failure |

| `ec2-deletion-after-fix.txt` | Passing deletion-only test |

| `ec2-regression-report.md` | EC2 regression testing summary |

| `sentinel-integration-pass.txt` | Combined Sentinel policy results |



\## 9. Git Development Workflow



Development was managed using feature branches, incremental commits and pull requests.



Five pull requests were merged into `main`:



| PR | Development area |

|---|---|

| #1 | Terraform infrastructure |

| #2 | Provider dependency locking |

| #3 | Digital sovereignty policy |

| #4 | Provider supply-chain security policy |

| #5 | EC2 infrastructure security policy |



Each feature was developed separately and integrated through GitHub.



The Git history preserves the implementation, testing, defect correction and documentation changes.



\## 10. Security Considerations and Limitations



The implementation provides a foundation for automated infrastructure governance, but several limitations remain.



\*\*Local mock testing:\*\* Sentinel policies were validated locally against mock data. Successful tests do not demonstrate live enforcement within an HCP Terraform workspace.



\*\*Region restriction:\*\* The sovereignty policy validates the configured AWS region variable. It does not inspect every resource's effective region or guarantee full data residency.



\*\*Provider security:\*\* The supply-chain policy validates provider source and version constraint declarations. Further controls would be needed to verify the complete software supply chain.



\*\*EC2 scope:\*\* The EC2 policy focuses on instance configuration. It does not comprehensively validate all networking, IAM, encryption-key management or operating-system security requirements.



\*\*Deployment:\*\* The AWS provider configuration is intended for local planning. No AWS infrastructure was deployed or operationally validated.



\## 11. Future Improvements



Potential improvements include:



\- Testing policy enforcement in a supported HCP Terraform environment.

\- Expanding digital sovereignty checks to additional AWS resources and services.

\- Introducing policy tests for IAM roles and security group configurations.

\- Adding automated validation to GitHub pull requests.

\- Extending provider verification and dependency security controls.

\- Testing the policies against representative real Terraform plan data.



\## 12. Conclusion



This project demonstrates how Terraform and HashiCorp Sentinel can be combined to implement Policy as Code for Irish digital sovereignty, provider governance and EC2 infrastructure security.



Local testing confirmed that the implemented policies distinguish compliant from non-compliant mock configurations. The project also demonstrates version control, pull-request-based development, regression testing and evidence collection.



The resulting framework provides a foundation for further policy development and integration into automated infrastructure delivery workflows.

