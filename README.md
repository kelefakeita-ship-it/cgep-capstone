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
| 4.4 | AU-9, AU-10, SI-7 | A.5.33, A.8.15 | CLD.8.1.4 | A.12, A.20 | Art. 8 |
| 5.2 | AU-2, AU-10, AU-12, RA-5, SI-4, CM-2, CM-6, CM-8 | A.8.15, A.8.16, A.5.36 | — | — | Art. 8 |
| 5.4 | CM-6, AC-2, AC-3, AU-2, AU-12 | A.8.9, A.8.3, A.8.15 | CLD.6.3.1, CLD.9.5.1 | A.11 | Art. 8 |

**ISO/IEC 27017 cloud-specific controls covered:**
- CLD.6.3.1 — Shared roles and responsibilities (AWS OIDC, GCP Workload Identity Federation)
- CLD.8.1.4 — Removal of cloud assets (Object Lock, immutable evidence)
- CLD.9.5.1 — Segregation in virtual environments (public access blocking, Org Policy)

**ISO/IEC 27018 PII protection controls covered:**
- A.11 — Encryption of PII at rest (AES-256, CMEK)
- A.12 — Audit logging of access to PII (AU-3, AU-6, GCP Data Access logs)
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

### Lab 4.4 — Evidence Management & Chain of Custody (AWS)
**Controls enforced:** AU-9, AU-10, SI-7  
**What I built:** Extended the Lab 4.3 pipeline with keyless Cosign signing via GitHub OIDC.
Evidence bundles are signed, timestamped via Sigstore Rekor, and uploaded to the immutable
Lab 2.5 vault. Chain of custody verified end-to-end with a single script. Tamper test
proves integrity is mathematical, not aspirational.
- `.github/workflows/grc-gate.yml` (Cosign steps added)
- `scripts/verify-evidence.sh`
- `evidence/lab-4-4/`

### Lab 5.2 — AWS Security Services Baseline
**Controls enforced:** AU-2, AU-12, AU-10, RA-5, SI-4, CM-2, CM-6, CM-8  
**What I built:** Always-on AWS-native compliance backbone — multi-region CloudTrail with
log-file validation, Security Hub subscribed to NIST 800-53 Rev 5 and AWS Foundational Security
Best Practices, and AWS Config for resource configuration recording. Unlike the PR-triggered
pipeline (Lab 4.3/4.4), this produces evidence continuously, independent of code changes.
- `baselines/aws/`
- `evidence/lab-5-2/`

### Lab 5.4 — GCP Security Services Baseline
**Controls enforced:** CM-6, AC-2, AC-3, AU-2, AU-12  
**What I built:** GCP-native identity-first compliance baseline — Workload Identity Federation
replacing long-lived service account JSON keys with short-lived OIDC tokens, and Data Access
audit logs enabled across Storage, KMS, and IAM (off by default in GCP, the most-cited audit
finding). Verified end-to-end: a live storage read produced an immediate audit log entry.
Org Policy (preventive controls) fully coded but gated behind a feature flag, since this
standalone project sits outside any GCP Organization — a documented environment constraint,
not a skipped requirement.
- `baselines/gcp/`
- `evidence/lab-5-4/`

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
- AWS (S3, IAM, Object Lock, CloudTrail, Security Hub, Config)
- GCP (Cloud Storage, Cloud KMS, IAM, Workload Identity Federation, Org Policy, Audit Logs)
- OPA / Rego
- Conftest
- tfsec
- Cosign / Sigstore
- GitHub Actions
- Git / GitHub

## Why this matters for GRC
Traditional GRC relies on spreadsheets and screenshots. This portfolio demonstrates a modern
approach: compliance controls expressed as code, verified automatically, and evidence stored as
JSON — auditable without human interpretation.

## Status
✅ Labs 2.3, 2.4, 2.5, 3.3, 3.4, 4.3, 4.4, 5.2, 5.4 completed.

---
*Built as part of the CGE-P (GRC Engineering Professional) course.*