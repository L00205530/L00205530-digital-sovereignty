\# Research and AI Usage — L00205530



\## AI assistance disclosure



AI assistance (ChatGPT, OpenAI, Codex) was used during the development of this assignment to explain technical concepts, suggest Terraform and Sentinel configurations, troubleshoot errors, propose test scenarios and assist with documentation.



I executed commands, inspected results, tested policy behaviour and maintained the Git repository.



\## AI usage records



\### 1. Terraform configuration



\- \*\*Tool:\*\* ChatGPT

\- \*\*Purpose:\*\* Guidance on Terraform configuration and security settings.

\- \*\*Advice received:\*\* Suggestions concerning AWS region restrictions, EC2 security, provider configuration and Terraform validation.

\- \*\*Independent verification:\*\* Terraform initialization, validation and plan generation were performed locally.

\- \*\*Implementation:\*\* Terraform configuration files and the provider lock file.



\### 2. Sentinel policy development



\- \*\*Tool:\*\* ChatGPT

\- \*\*Purpose:\*\* Assistance developing Policy-as-Code controls.

\- \*\*Advice received:\*\* Suggestions for region restrictions, EC2 and network security, data residency and dependency supply-chain policies.

\- \*\*Independent verification:\*\* Local Sentinel tests using compliant and non-compliant fixtures.

\- \*\*Implementation:\*\* Six Sentinel policies and supporting mock configurations.



\### 3. Troubleshooting and regression testing



\- \*\*Tool:\*\* ChatGPT

\- \*\*Purpose:\*\* Troubleshoot Sentinel mock syntax and configuration errors.

\- \*\*Advice received:\*\* Corrections to mock structures, including the `tfconfig/v2` module-call schema.

\- \*\*Independent verification:\*\* Reran Sentinel tests and confirmed expected PASS and FAIL outcomes.

\- \*\*Implementation:\*\* Corrected fixtures and refreshed evidence files.



\### 4. Documentation



\- \*\*Tool:\*\* ChatGPT

\- \*\*Purpose:\*\* Help structure and draft assignment documentation.

\- \*\*Advice received:\*\* Suggested README structure, security explanations, limitations and technical-report content.

\- \*\*Independent verification:\*\* Documentation should be reviewed against the final repository and assignment requirements before submission.

\- \*\*Implementation:\*\* `README.md`, `report/technical-report.md` and supporting documentation.



\## Limitations



AI-generated suggestions were not treated as authoritative evidence of security or correctness. Local testing demonstrates policy behaviour against selected fixtures, but does not establish comprehensive cloud security or live HCP Terraform enforcement.



\## Exact prompts and dates



Example 1 — Terraform configuration review
Prompt example:

"Can you review my Terraform configuration and confirm whether the EC2 instance has a public IP disabled, EBS encryption enabled and IMDSv2 enforced? Are there any security settings I should check?"

Example 2 — Sentinel execution error
Prompt example:

"I'm getting this error when running sentinel apply: missing ',' before newline in map literal. Can you explain what is wrong with my mock configuration and how to fix it?"

Example 3 — Confirming a negative test result
Prompt example:

"My module supply-chain policy returns FAIL when I test an untrusted Git module. The execution trace shows module\_sources\_are\_approved = false. Is this the expected behaviour?"

Example 4 — Module version validation

Prompt example:

"I tested an approved Terraform module without a version and another using \~> 5.0. Both returned module\_versions\_are\_pinned = false. Can you confirm whether these results are correct?"


Example 5 — Reviewing test evidence
Prompt example:

"I have generated PASS and FAIL evidence files for my Sentinel policies. Can you review the results and help me check whether the expected positive and negative tests are represented?"


Example 6 — Git workflow verification

Prompt example:

"Here is my git log --oneline and git status --short output. Can you confirm that my changes were committed correctly and that my feature branch is ready for a pull request?"

## Summary of AI Assistance:


ChatGPT was used primarily to support technical troubleshooting, explain error messages, review existing configurations, interpret test results and assist with documentation.



Terraform and Sentinel commands were executed locally by myself. Test results were inspected before being recorded as evidence, and Git changes were committed through my development environment.





