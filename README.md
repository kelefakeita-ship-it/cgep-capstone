# CGE-P Capstone Repository — GRC Engineering Portfolio

## About
This repository documents my hands-on GRC Engineering practice (Governance, Risk & Compliance). It demonstrates a modern approach to compliance: security controls 
expressed as code, verified automatically, and evidence stored as machine-readable JSON — 
auditable without human interpretation.

## What I practice
- Expressing security controls as code (NIST 800-53)
- Building compliant cloud infrastructure on AWS and GCP with Terraform
- Producing machine-readable compliance evidence (no screenshots)
- Automating compliance checks in CI/CD pipelines
- Writing OSCAL Component Definitions

## Compliance Framework Mapping

The controls implemented across these labs map to multiple frameworks simultaneously:

| Lab | NIST 800-53 | ISO/IEC 27001:2022 | ISO/IEC 27017 | ISO/IEC 27018 | Swiss DSG |
|-----|-------------|---------------------|----------------|----------------|-----------|
| 2.3 | SC-28, AC-3, AU-3, AU-6, CM-6 | A.8.24, A.8.3, A.8.15, A.8.9 | CLD.9.5.1, CLD.8.1.4 | A.11, A.12 | Art. 8 |
| 2.4 | SC-12, SC-13, SC-28, AU-11, CM-6 | A.8.24, A.8.15, A.8.9 | CLD.9.5.1 | A.11 | Art. 8 |
| 2.5 | SC-28, AU-9 | A.8.15, A.5.33 | CLD.8.1.4 | A.12, A.20 | Art. 8 |
| 3.3 | SC-28, AC-3, CM-6 | A.8.9, A.8.3 | — | — | Art. 8 |
| 3.4 | SC-28, AC-3, CM-6 | A.8.9, A.8.8 | — | — | Art. 8 |
| 4.3 | CM-3, CM-6, CA-2, CA-7, RA-5, AU-9 | A.8.8, A.8.9, A.8.15 | CLD.6.3.1 | A.12 | Art. 8 |

**ISO/IEC 27017 cloud-specific controls covered:**
- CLD.6.3.1 — Shared roles and responsibilities (OIDC, IAM)
- CLD.8.1.4 — Removal of cloud assets (Object Lock, immutable evidence)
- CLD.9.5.1 — Segregation in virtual environments (public access blocking)

**ISO/IEC 27018 PII protection controls covered:**
- A.11 — Encryption of PII at rest (AES-256, CMEK)
- A.12 — Audit logging of access to PII (AU-3, AU-6)
- A.20 — Retention and deletion policies (Object Lock, retention_days)

## Labs completed

### Lab 2.3 — Compliant S3 Bucket (AWS)
**Controls enforced:** SC-28, AU-3, AU-6, CM-6, AC-3
**What I built:** A Terraform primitive that deploys an AWS S3 bucket with AES-256 encryption,
versioning, access logging, and public access blocked. Evidence captured as machine-readable JSON.
- `primitives/compliant-s3/`
- `evidence/lab-2-3/`

### Lab 2.4 — Terraform Modules for Compliance (GCP)
**Controls enforced:** SC-12, SC-13, SC-28, AU-11, CM-6
**What I built:** A reusable Terraform module on GCP that enforces CMEK encryption with 90-day
key rotation, versioning, retention policies, and required compliance labels. Consumers cannot
disable the security floor.
- `modules/compliant-gcs-bucket/`
- `consumers/dev/`
- `evidence/lab-2-4/`

### Lab 2.5 — IaC as Compliance Evidence (AWS)
**Controls enforced:** SC-28, AU-9
**What I built:** An S3 Object Lock vault that refuses deletion by design. Evidence bundles from
Lab 2.3 are hashed, bundled, and uploaded with a recorded VersionId — immutable by design.
- `primitives/evidence-vault/`
- `scripts/capture-evidence.sh`
- `evidence/lab-2-5/`

### Lab 3.3 — Writing Compliance Policies in Rego (GCP)
**Controls enforced:** SC-28, AC-3, CM-6
**What I built:** Three Rego policies against GCP fixtures, each mapped to a NIST 800-53 control,
with `_test.rego` fixtures and a real `terraform plan -json` run. 8/8 unit tests passing.
- `policies/`
- `evidence/lab-3-3/`

### Lab 3.4 — Integrating PaC with Terraform via Conftest (AWS)
**Controls enforced:** SC-28, AC-3, CM-6
**What I built:** Conftest wired into the Terraform plan workflow as a fail-closed gate. Added
AWS variants of SC-28 and AC-3 policies. Proved a blocked merge against a deliberately broken plan.
- `policies/` (AWS variants added)
- `scripts/policy-gate.sh`
- `evidence/lab-3-4/`

### Lab 4.3 — GRC Evidence Pipeline (AWS + GitHub Actions)
**Controls enforced:** CM-3, CM-6, CA-2, CA-7, RA-5, AU-9
**What I built:** A GitHub Actions workflow that runs on every PR: AWS OIDC authentication,
Terraform plan, Conftest policy gate, tfsec scan, and evidence artifact upload. Red PR and
green PR both in repo history.
- `.github/workflows/grc-gate.yml`
- `oidc/`
- `evidence/lab-4-3/`

## Transferability to Microsoft 365 Governance
The compliance-as-code methodology demonstrated here applies directly to Microsoft 365 governance:
- **Entra ID:** Conditional Access Policies as code (Terraform `azuread` provider)
- **Purview:** DLP policy logic and compliance label frameworks
- **M365 Feature Governance:** Evaluation workflows for new features against regulatory requirements

*Actively expanding this portfolio to include Microsoft 365 / Azure governance examples.*

## Regulatory Scope
While current labs map to NIST 800-53, the methodology is directly applicable to Swiss regulatory
frameworks (DSG, KDSG, ICT Minimum Standard). Control mapping to DSG/KDSG requirements is in
development.

## Tech stack
- Terraform >= 1.6
- AWS (S3, IAM, Object Lock)
- GCP (Cloud Storage, Cloud KMS, IAM)
- OPA / Rego
- Conftest
- tfsec
- GitHub Actions
- Git / GitHub

## Why this matters for GRC
Traditional GRC relies on spreadsheets and screenshots. This portfolio demonstrates a modern
approach: compliance controls expressed as code, verified automatically, and evidence stored as
JSON — auditable without human interpretation.

## Status
✅ Labs 2.3, 2.4, 2.5, 3.3, 3.4, 4.3 completed.

---
*Built as part of the CGE-P (GRC Engineering Professional) course.*
