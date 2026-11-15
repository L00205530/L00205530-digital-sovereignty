

\# Test Evidence and Screenshots



\*\*Project:\*\* L00205530 Digital Sovereignty and IaC Supply Chain Security



\## Overview



This directory contains screenshot evidence collected during local validation of the Terraform configuration, HashiCorp Sentinel policies, and Git workflow.



The screenshots are organised into three categories:



| Directory | Description | Screenshots |

|---|---|---:|

| `01-terraform/` | Terraform initialisation, validation and plan inspection | 6 |

| `02-sentinel/` | Sentinel policy execution and positive/negative testing | 16 |

| `03-git/` | Git commit history and pull request workflow | 2 |

| \*\*Total\*\* | | \*\*24\*\* |



All evidence was collected using local development tools. Sentinel policies were evaluated using mock Terraform data. The screenshots do not demonstrate live HCP Terraform enforcement or deployment of AWS infrastructure.



\---



\## 1. Terraform Validation



These screenshots document the Terraform CLI environment, configuration validation and infrastructure plan inspection.



| Evidence | Description | Screenshot |

|---|---|---|

| Terraform version | Displays the installed Terraform CLI version | \[View](01-terraform/terraform-version.png) |

| Terraform initialisation | Records Terraform initialisation | \[View](01-terraform/terraform-init.png) |

| Terraform validation | Records Terraform configuration validation | \[View](01-terraform/terraform-validate.png) |

| Terraform plan 1 | First section of the Terraform plan output | \[View](01-terraform/terraform-plan-1.png) |

| Terraform plan 2 | Second section of the Terraform plan output | \[View](01-terraform/terraform-plan-2.png) |

| Terraform plan 3 | Third section of the Terraform plan output | \[View](01-terraform/terraform-plan-3.png) |



\### Terraform Commands



Run the following commands from the repository root:



```powershell

terraform version

cd terraform

terraform init -lockfile=readonly

terraform validate

terraform show -no-color .\\tfplan

```



The Terraform plan is used for local infrastructure inspection and policy evaluation. It does not demonstrate a successful AWS deployment.



\---



\## 2. Sentinel Policy Testing



Six Sentinel policies were implemented and tested using compliant and non-compliant Terraform mock configurations.



The policies cover:



1\. Digital sovereignty and approved AWS regions.

2\. Provider supply-chain security.

3\. EC2 security requirements.

4\. Network security restrictions.

5\. Data residency requirements.

6\. Terraform module supply-chain security.



\### Testing Methodology



Two categories of tests were used:



\- \*\*Positive tests (PASS):\*\* Verify that configurations meeting the policy requirements are accepted.

\- \*\*Negative tests (FAIL):\*\* Verify that configurations violating the policy requirements are rejected.



An expected `Fail` result is considered a successful negative test because it demonstrates policy enforcement.



Execution errors or invalid test configurations are not considered successful negative tests.



\### 2.1 Test Environment and Integration



| Evidence | Description | Screenshot |

|---|---|---|

| Sentinel version | Installed HashiCorp Sentinel CLI version | \[View](02-sentinel/sentinel-version.png) |

| Test configurations | Available compliant and non-compliant test configuration files | \[View](02-sentinel/sentinel-test-configuration-filenames.png) |

| S00 | Baseline execution of all six Sentinel policies | \[View](02-sentinel/S00-all-six-policies-pass.png) |

| Test summary | Summary of positive and negative test results | \[View](02-sentinel/summary-test-results.png) |



\#### Baseline Integration Test



Run from the `sentinel/` directory:



```powershell

sentinel apply

```



Expected result:



```text

Pass - data-residency.sentinel

Pass - digital-sovereignty.sentinel

Pass - ec2-security.sentinel

Pass - module-supply-chain.sentinel

Pass - network-security.sentinel

Pass - provider-supply-chain.sentinel

```



This confirms that all six policies pass when evaluated against their configured baseline mock data.



\### 2.2 Individual Policy Tests



The following table maps each test to its policy, scenario, expected result and screenshot evidence.



| Test ID | Policy | Test Scenario | Expected Result | Screenshot |

|---|---|---|---|---|

| S01 | Digital sovereignty | Approved AWS region | PASS | \[View](02-sentinel/S01-sovereignty-pass.png) |

| S02 | Digital sovereignty | Non-compliant AWS region | FAIL | \[View](02-sentinel/S02-sovereignty-fail.png) |

| S03 | Provider supply-chain | Approved provider configuration | PASS | \[View](02-sentinel/S03-provider-pass.png) |

| S04 | Provider supply-chain | Non-compliant provider configuration | FAIL | \[View](02-sentinel/S04-provider-fail.png) |

| S05 | EC2 security | Compliant EC2 configuration | PASS | \[View](02-sentinel/S05-ec2-pass.png) |

| S06 | EC2 security | Non-compliant EC2 configuration | FAIL | \[View](02-sentinel/S06-ec2-fail.png) |

| S07 | Network security | Approved HTTPS configuration | PASS | \[View](02-sentinel/S07-network-pass.png) |

| S08 | Network security | Unrestricted SSH access | FAIL | \[View](02-sentinel/S08-network-fail.png) |

| S09 | Data residency | Compliant backup configuration | PASS | \[View](02-sentinel/S09-data-residency-pass.png) |

| S10 | Data residency | Cross-region backup configuration | FAIL | \[View](02-sentinel/S10-data-residency-fail.png) |

| S11 | Module supply-chain | Approved Terraform module | PASS | \[View](02-sentinel/S11-module-pass.png) |

| S12 | Module supply-chain | Untrusted Terraform module | FAIL | \[View](02-sentinel/S12-module-fail.png) |



\### 2.3 Reproducing the Sentinel Tests



Run these commands from the `sentinel/` directory.



\#### Digital Sovereignty



```powershell

\# S01 - Expected PASS

sentinel apply digital-sovereignty.sentinel



\# S02 - Expected FAIL

sentinel apply -config="../testdata/non-compliant/sentinel-config.hcl" digital-sovereignty.sentinel

```



\#### Provider Supply-Chain Security



```powershell

\# S03 - Expected PASS

sentinel apply provider-supply-chain.sentinel



\# S04 - Expected FAIL

sentinel apply -config="../testdata/non-compliant/provider-config.hcl" provider-supply-chain.sentinel

```



\#### EC2 Security



```powershell

\# S05 - Expected PASS

sentinel apply -config="../testdata/compliant/ec2-config.hcl" ec2-security.sentinel



\# S06 - Expected FAIL

sentinel apply -config="../testdata/non-compliant/ec2-config.hcl" ec2-security.sentinel

```



\#### Network Security



```powershell

\# S07 - Expected PASS

sentinel apply -config="../testdata/compliant/network-https-config.hcl" network-security.sentinel



\# S08 - Expected FAIL

sentinel apply -config="../testdata/non-compliant/network-open-ssh-config.hcl" network-security.sentinel

```



\#### Data Residency



```powershell

\# S09 - Expected PASS

sentinel apply -config="../testdata/compliant/backup-standard-config.hcl" data-residency.sentinel



\# S10 - Expected FAIL

sentinel apply -config="../testdata/non-compliant/backup-cross-region-config.hcl" data-residency.sentinel

```



\#### Module Supply-Chain Security



```powershell

\# S11 - Expected PASS

sentinel apply -config="../testdata/compliant/approved-module-config.hcl" module-supply-chain.sentinel



\# S12 - Expected FAIL

sentinel apply -config="../testdata/non-compliant/untrusted-module-config.hcl" module-supply-chain.sentinel

```



Additional test configurations are available under the `testdata/` directory to evaluate other non-compliant scenarios, including insecure EC2 configurations, unrestricted network access, cross-region replication and unapproved Terraform modules.



\---



\## 3. Git Workflow Evidence



Git was used throughout development to manage changes, maintain version history and demonstrate a structured development workflow.



Feature branches and pull requests were used to separate implementation, testing and documentation changes.



| Evidence | Description | Screenshot |

|---|---|---|

| Git history | Commit history and development activity | \[View](03-git/git-history.png) |

| Pull requests | GitHub pull request workflow | \[View](03-git/pull-requests.png) |



The screenshots provide supporting evidence of version-control activity.



The repository's live commit history and pull request records provide the authoritative record of changes.



\### Git Verification Commands



```powershell

git status -sb

git log --oneline --graph --decorate -25

git branch -a

```



The complete Git workflow can also be inspected through the repository's GitHub pull request history.



\---



\## 4. Evidence Summary



| Category | Evidence Provided |

|---|---|

| Terraform | CLI version, initialisation, validation and plan inspection |

| Sentinel integration | Baseline execution of all six policies |

| Sentinel positive tests | Six compliant configuration scenarios |

| Sentinel negative tests | Six non-compliant configuration scenarios |

| Sentinel test environment | CLI version and configuration file listing |

| Sentinel results | Test summary screenshot |

| Git | Commit history and pull request evidence |



\*\*Total screenshot evidence: 24 files.\*\*



The screenshots support the documented local testing process and provide visual evidence of the commands and results recorded during development.



\---



\## 5. Evidence Scope and Limitations



The evidence demonstrates local Terraform validation, Sentinel mock-based policy evaluation and Git workflow activity.



The following are outside the scope of the screenshots:



\- Live policy enforcement through HCP Terraform.

\- Deployment of production infrastructure to AWS.

\- Verification of running AWS infrastructure.

\- Continuous policy enforcement within a production CI/CD pipeline.



The Sentinel tests demonstrate policy behaviour against the supplied mock configurations rather than against live cloud infrastructure.



These limitations are documented to distinguish the tested functionality from capabilities that were not implemented or verified.



\---



\## 6. Related Project Documentation



\- \[Main Project README](../README.md)

\- \[Technical Report](../report/technical-report.md)

\- \[Research and AI Usage](../docs/research-and-ai-usage.md)



The main README provides the project overview, while the technical report explains the implementation and testing approach.



This screenshot index provides direct access to the supporting visual evidence.



\---



\*\*Student ID:\*\* L00205530



