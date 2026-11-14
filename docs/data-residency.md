# Data Residency Security Controls

## Overview

The L00205530 Digital Sovereignty Framework uses HashiCorp
Sentinel to enforce preventative controls against unverified
data replication and backup destinations.

The approved AWS region is eu-west-1 (Ireland).

## Implemented Controls

### S3 Replication

New or updated aws_s3_bucket_replication_configuration
resources are rejected.

This prevents unverified replication destinations but also
blocks legitimate same-region replication.

### RDS Replication

New or updated aws_db_instance resources are rejected when
replicate_source_db is configured.

New or updated aws_rds_cluster resources are rejected when
replication_source_identifier or global_cluster_identifier
is configured.

Ordinary database creation without these attributes is allowed.

### AWS Backup

New or updated aws_backup_plan resources containing
copy_action configurations are rejected.

Backup plans without copy actions are permitted.

## Testing

Compliant and non-compliant Sentinel mock plans demonstrate
the expected policy outcomes.

Evidence is stored in the evidence/ directory.

All five registered Sentinel policies passed integration testing.

## Limitations

These controls do not independently verify the physical
location of AWS data.

The current implementation intentionally rejects all new
or modified S3 replication configurations, configured RDS
replication sources, and AWS Backup copy actions.

Legitimate same-region replication may therefore be blocked.

The policies evaluate Terraform plan changes rather than
continuously inspecting deployed AWS infrastructure.

Resources managed outside Terraform, existing unchanged
resources, and unsupported replication mechanisms are not
comprehensively covered.

The framework does not currently verify AWS account
jurisdiction, administrator location, or access from
foreign jurisdictions.

## Recommendations

Future improvements should include:

- Authoritative destination-region verification.
- Approved same-region replication configurations.
- AWS Organizations service control policies.
- AWS Config continuous compliance monitoring.
- AWS CloudTrail auditing.
- Additional controls for standalone replication resources.
- HCP Terraform policy enforcement during remote runs.

These improvements would complement Sentinel plan-time
enforcement and strengthen the overall sovereignty framework.
