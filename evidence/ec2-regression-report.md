# EC2 Security Policy Regression Testing

## Project
L00205530 - Digital Sovereignty and IaC Supply Chain Security

## Objective
Verify that the EC2 security policy enforces infrastructure
security requirements while permitting deletion-only and
empty Terraform plans.

## Test Results

| Scenario | Expected | Actual | Result |
|---|---|---|---|
| Secure EC2 | PASS | PASS | Success |
| Insecure EC2 | FAIL | FAIL | Success |
| Missing IMDSv2 | FAIL | FAIL | Success |
| Missing EBS encryption | FAIL | FAIL | Success |
| Missing Organisation tag | FAIL | FAIL | Success |
| Missing Environment tag | FAIL | FAIL | Success |
| Insecure EC2 replacement | FAIL | FAIL | Success |
| Deletion-only plan | PASS | PASS | Success |
| Empty Terraform plan | PASS | PASS | Success |

## Integration Testing

All three registered policies passed:

- digital-sovereignty.sentinel
- ec2-security.sentinel
- provider-supply-chain.sentinel

## Defect and Resolution

The initial EC2 policy rejected deletion-only Terraform plans
because it required at least one EC2 resource to be evaluated.

The defect was reproduced and committed as b498bfe.

The policy was subsequently updated to allow empty collections
of EC2 creation/update operations.

The correction was committed as 33023dd.

## Conclusion

All nine EC2 test scenarios produced their expected results.
The integrated policy suite also passed.

Testing was performed locally using Sentinel CLI and mock data.
These results do not establish successful enforcement against
a live HCP Terraform workspace.
