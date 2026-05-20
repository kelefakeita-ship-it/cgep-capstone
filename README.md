# CGE-P Capstone Repository — GRC Engineering Portfolio

## About

This repository documents my hands-on GRC Engineering practice (Governance, Risk & Compliance) 
through the CGE-P course. It demonstrates a modern approach to compliance: security controls 
expressed as code, verified automatically, and evidence stored as machine-readable JSON — 
auditable without human interpretation.

## What I practice

- Expressing security controls as code (NIST 800-53)
- Building compliant cloud infrastructure on AWS and GCP with Terraform
- Producing machine-readable compliance evidence (no screenshots)
- Automating compliance checks in CI/CD pipelines
- Writing OSCAL Component Definitions

## Labs completed

### Lab 2.3 — Compliant S3 Bucket (AWS)

**Controls enforced:** SC-28, AU-3, AU-6, CM-6, AC-3

**What I built:** A Terraform primitive that deploys an AWS S3 bucket with AES-256 encryption, 
versioning, access logging, and public access blocked. Evidence captured as machine-readable JSON.

- `terraform/primitives/compliant-s3/`
- `evidence/lab-2-3/`

### Lab 2.4 — Compliant GCS Bucket Module (GCP)

**Controls enforced:** SC-12, SC-13, SC-28, AU-11, CM-6

**What I built:** A reusable Terraform module on GCP that enforces CMEK encryption with 90-day 
key rotation, versioning, retention policies, and required compliance labels. Consumers cannot 
disable the security floor.

- `terraform/modules/compliant-gcs-bucket/`
- `terraform/consumers/dev/`
- `evidence/lab-2-4/`

## Transferability to Microsoft 365 Governance

The compliance-as-code methodology demonstrated here — NIST control mapping, machine-readable 
attestations, policy enforcement through infrastructure code — applies directly to Microsoft 365 
governance:

- **Entra ID:** Conditional Access Policies as code (Terraform `azuread` provider)
- **Purview:** DLP policy logic and compliance label frameworks
- **M365 Feature Governance:** Evaluation workflows for new features (Copilot, Clipchamp) against 
  regulatory requirements

*Actively expanding this portfolio to include Microsoft 365 / Azure governance examples.*

## Regulatory Scope

While current labs map to NIST 800-53, the underlying methodology — risk-based control selection, 
evidence-based accountability, and shift-left validation — is directly applicable to Swiss 
regulatory frameworks (DSG, KDSG, ICT Minimum Standard). Control mapping to DSG/KDSG requirements 
is in development.

## Tech stack

- Terraform &gt;= 1.6
- AWS (S3, IAM)
- GCP (Cloud Storage, Cloud KMS, IAM)
- Git / GitHub

## Why this matters for GRC

Traditional GRC relies on spreadsheets and screenshots. This portfolio demonstrates a modern 
approach: compliance controls expressed as code, verified automatically, and evidence stored as 
JSON — auditable without human interpretation.

## Status

✅ Core labs completed (2.3, 2.4). Expanding to Microsoft 365 governance and DSG/KDSG control 
mapping.

---

_Built as part of the CGE-P (GRC Engineering Professional) course._
