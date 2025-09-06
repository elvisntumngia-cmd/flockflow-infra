# Flockflow Infrastructure

## Overview
This Terraform project deploys the initial cloud infrastructure for Flockflow.

## Resources Deployed

### Networking
- **VPC:** flockflow_vpc
- **Public Subnets:** 2 (subnet-0b00c9f7eeeeb8faa, subnet-0e6cdc7ad8192ce89)
- **Private Subnets:** 2 (subnet-077eb069cd918bc9c, subnet-006bf70db45ba3f8b)
- **Internet Gateway:** igw-0df93543d8669c684
- **Route Tables:** public, private associations configured

### Storage
- **S3 Bucket:** flockflow-frontend
- **Public Access Block:** Configured
- **Website Hosting:** Enabled (index.html, error.html)

### Cost Controls
- AWS Budget set: Max $10/month
- CloudWatch S3 storage alarm configured (1GB threshold)
- Optional service quotas applied (EC2, S3, Lambda, RDS)

## Terraform
- State file tracks all deployed resources
- Main files:
  - `main.tf` – core infrastructure
  - `cost_controls.tf` – cost limits and alarms

## Notes
- Ensure budget alerts are monitored.
- Avoid creating extra resources beyond cost limits.
- S3 website is live at: [insert bucket website endpoint here]
