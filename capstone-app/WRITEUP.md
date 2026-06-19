

\# Capstone Write-Up — Acme Health Patient Intake API



\## Primary Framework: SOC 2 Trust Services Criteria



This system is governed against the \*\*SOC 2 Trust Services Criteria\*\* (2017, 2022 revision). SOC 2 was chosen over HIPAA Security Rule and CMMC Level 2 for three reasons. First, market fit: as a Swiss-based engineer, SOC 2 is the framework my target market actually asks for — it is the de-facto trust standard for SaaS vendors selling into enterprise, and Swiss audit practices (KPMG, PwC) run active SOC 2 attestation engagements. HIPAA is a US-healthcare-specific statute and CMMC is US-defense-specific; neither travels well outside its jurisdiction. Second, the workload fit is honest rather than perfect: the starter handles PHI, which superficially suggests HIPAA — but the controls a telehealth SaaS needs to \*sell\* (encryption custody, least privilege, network isolation, recoverability) are exactly the CC6/A1 criteria, and SOC 2 lets me demonstrate them without claiming a HIPAA compliance posture I haven't fully built. Third, portfolio leverage: SOC 2's control structure maps cleanly onto the NIST 800-53 work already in this repo, letting the capstone extend a coherent story rather than start a new one.



\## What I built



The starter (`cgep-app-starter`) is a deliberately non-compliant Patient Intake API: VPC, API Gateway (HTTP), Lambda handler, DynamoDB table, S3 uploads bucket. It works but is not audit-defensible — it ships with eight named gaps in `GAPS.md`. I wrapped it in four layers:



\- \*\*Layer 1 (Terraform GRC baseline)\*\* closes six gaps and adds a customer-managed KMS key, VPC endpoints, and a remote state backend.

\- \*\*Layer 2 (OPA policy suite)\*\* is six Rego policies, each mapped to a SOC 2 criterion, with 18 passing unit tests, that re-detect those gaps if anyone reintroduces them.

\- \*\*Layer 3 (GitHub Actions pipeline)\*\* runs Plan → Policy → Apply → Sign → Upload on every change, producing a signed, immutable evidence bundle per run.

\- \*\*Layer 4 (OSCAL)\*\* is a self-authored SOC 2 catalog, a component definition mapping each criterion to real Terraform resources and evidence URIs, and a profile — all validated by `trestle`.



\## Gap remediation



| Gap | SOC 2 | Closed in | How |

|-----|-------|-----------|-----|

| GAP-01 | CC6.1 | Layer 1 + Policy | S3 uploads bucket encrypted with customer-managed KMS key (SSE-KMS), not AWS-managed SSE-S3 |

| GAP-02 | CC6.1 | Layer 1 + Policy | DynamoDB table given explicit `server\_side\_encryption` block referencing the same CMK |

| GAP-03 | CC6.7 | Layer 1 + Policy | Bucket policy denies requests where `aws:SecureTransport = false` |

| GAP-04 | A1.2 | Layer 1 + Policy | S3 versioning enabled; recoverable PHI overwrites |

| GAP-05 | CC6.6 | Layer 1 + Policy | Lambda moved into private subnets, egress-only SG, reaching AWS via VPC endpoints |

| GAP-07 | CC6.3 | Layer 1 + Policy | IAM role scoped from `dynamodb:\*`/`s3:\*` to the exact actions the handler performs |

| GAP-06 | CC7.2 | \*\*Not closed\*\* | Lambda reserved concurrency / DLQ / X-Ray — documented open |

| GAP-08 | CC7.2 | \*\*Not closed\*\* | API Gateway access logging / throttling / WAF — documented open |



Six of eight gaps are closed in Terraform \*and\* enforced in policy — defense in depth: Layer 1 fixes the gap, Layer 2 prevents its return. The red demonstration PR proved this by reintroducing GAP-04 (suspending S3 versioning) and watching the gate block the merge.



\## Design trade-offs



\*\*VPC endpoints instead of a NAT gateway.\*\* Closing GAP-05 means the Lambda loses its default internet path to AWS service APIs. The textbook fix is a NAT gateway (\~$32/month + data charges). Instead I used gateway endpoints for S3 and DynamoDB (free) and an interface endpoint for KMS (cents/hour). For a PHI workload this is also \*more\* secure than NAT — traffic to AWS services never traverses the public internet at all. The trade-off: interface endpoints carry a small hourly charge and the design is slightly more complex. Worth it.



\*\*Closing the KMS gap broke the IAM gap — and that's the point.\*\* Adding the CMK (GAP-01/02) immediately broke the workload: the now-scoped IAM role (GAP-07) couldn't write through the new key. The fix was to grant `kms:GenerateDataKey`/`kms:Decrypt` on exactly that key. This is the core GRC-engineering lesson — controls interact, and "least privilege" means re-deriving the minimum after every change, not bolting on `\*` to make the error go away. The smoke test passing after all six gaps closed is the proof security and function coexist.



\*\*S3 remote state backend.\*\* The pipeline needs to share Terraform state with my laptop. Rather than a workaround, I stood up a versioned, encrypted S3 backend with DynamoDB locking. State is itself sensitive (it describes the whole PHI infrastructure), so the backend is a control in its own right: encryption at rest, version history, no concurrent-apply corruption, nothing sensitive left on an endpoint.



\*\*Service-scoped CI apply role, not AdministratorAccess.\*\* Auto-apply needs write permissions. The lazy path is `AdministratorAccess`; that would contradict the very CC6.3 least-privilege control my own GAP-07 policy enforces. I wrote a dedicated `capstone-apply` policy scoped to the seven services the stack provisions, with IAM permissions further restricted to `acme-health-intake-\*` resources so the CI role cannot touch arbitrary roles in the account. Honest trade-off: it's still service-level `\*` (e.g. `s3:\*`), not action-level minimal — a fully minimal apply policy for this diverse a stack would be hundreds of lines and brittle. This is the documented, defensible middle ground.



\*\*GOVERNANCE-mode Object Lock on the evidence vault.\*\* The reused Lab 2.5 vault runs Object Lock in GOVERNANCE mode with short retention, not COMPLIANCE mode. For a lab this is deliberate — COMPLIANCE mode is unbreakable even by the account root, which is correct for production but means a misconfigured retention locks objects for years with no recovery. GOVERNANCE mode demonstrates the identical control surface while remaining recoverable. Production would flip to COMPLIANCE with a 365-day (or regulatory) retention.



\## What I'd do with another sprint



\- Close GAP-08 properly: API Gateway access logging to CloudWatch, throttling, and an AWS WAF web ACL — this is the highest-value remaining gap because the API is the public attack surface.

\- Close GAP-06: Lambda reserved concurrency, a dead-letter queue, and X-Ray tracing for availability and observability (CC7.2).

\- Add a `terraform fmt`/`validate` and `opa test` step to the pipeline so policy unit tests gate alongside the Conftest plan check.

\- Wire the OSCAL evidence URIs to refresh automatically per run rather than pointing at a pinned run ID.



\## What I didn't get to



\- GAP-06 and GAP-08 remain open by design — they map to CC7.2 (system operations/monitoring), a different control family than the access-and-availability criteria this build prioritized. They are documented in the OSCAL component as not-implemented rather than silently omitted.

\- The OSCAL component references a single pinned evidence run. A production setup would template this.

\- No System Security Plan (SSP) — the capstone scope is component-definition level; an SSP would be the next OSCAL artifact up.



\## How to verify this repo



See `README.md` for grader instructions. In short: the OSCAL component in `oscal/component-definitions/capstone-system/` is the entry point; follow any `rel=evidence` href into the vault and run `scripts/verify-evidence.sh 27848293937 --prefix capstone/runs` to see `CHAIN INTACT`.



\---



