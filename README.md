# CGE-P Capstone Repository — GRC Engineering Portfolio

## About
This repository documents my hands-on learning journey in GRC Engineering (Governance, Risk & Compliance) 
through the CGE-P course. I am at the beginning of my career as a GRC Engineer, actively building 
practical skills in Infrastructure-as-Code, compliance automation, and cloud security.

## What I am learning
- Expressing security controls as code (NIST 800-53)
- Building compliant cloud infrastructure on AWS and GCP with Terraform
- Producing machine-readable compliance evidence (no screenshots)
- Automating compliance checks in CI/CD pipelines (upcoming)
- Writing OSCAL Component Definitions (upcoming)

## Labs completed

### Lab 2.3 — Compliant S3 Bucket (AWS)
**Controls enforced:** SC-28, AU-3, AU-6, CM-6, AC-3  
**What I built:** A Terraform primitive that deploys an AWS S3 bucket with AES-256 encryption, 
versioning, access logging, and public access blocked. Evidence captured as machine-readable JSON.

📁 `terraform/primitives/compliant-s3/`  
📁 `evidence/lab-2-3/`

### Lab 2.4 — Compliant GCS Bucket Module (GCP)
**Controls enforced:** SC-12, SC-13, SC-28, AU-11, CM-6  
**What I built:** A reusable Terraform module on GCP that enforces CMEK encryption with 90-day 
key rotation, versioning, retention policies, and required compliance labels. Consumers cannot 
disable the security floor.

📁 `terraform/modules/compliant-gcs-bucket/`  
📁 `terraform/consumers/dev/`  
📁 `evidence/lab-2-4/`

## Tech stack
- Terraform >= 1.6
- AWS (S3, IAM)
- GCP (Cloud Storage, Cloud KMS, IAM)
- Git / GitHub

## Why this matters for GRC
Traditional GRC relies on spreadsheets and screenshots. This portfolio demonstrates a modern approach: 
compliance controls expressed as code, verified automatically, and evidence stored as JSON — 
auditable without human interpretation.

## Status
🟡 In progress — actively adding labs as I complete them.

---
*Built as part of the CGE-P (GRC Engineering Professional) course.*-
