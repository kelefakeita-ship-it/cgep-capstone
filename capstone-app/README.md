
# Acme Health Patient Intake — CGE-P Capstone

A derivative of [`GRCEngClub/cgep-app-starter`](https://github.com/GRCEngClub/cgep-app-starter).
The starter's Patient Intake API (VPC + API Gateway + Lambda + DynamoDB + S3) is
present and runnable; this repo wraps it with a SOC 2 GRC control system.

**Primary framework: SOC 2 Trust Services Criteria.** Full reasoning in [`WRITEUP.md`](./WRITEUP.md).

## The four layers

| Layer | Location | What it does |
|-------|----------|--------------|
| 1 — Terraform GRC baseline | `terraform/` | Closes 6 of 8 gaps: CMK encryption, TLS enforcement, versioning, VPC isolation, least-privilege IAM |
| 2 — OPA policy suite | `../policies/capstone/` | 6 SOC 2 Rego policies, 18 unit tests, re-detect any reintroduced gap |
| 3 — GitHub Actions pipeline | `../.github/workflows/capstone-gate.yml` | Plan → Policy → Apply → Sign → Upload on every change |
| 4 — OSCAL | `../oscal/` | Self-authored SOC 2 catalog + component definition + profile, validated by trestle |

## Gap coverage

Closed in Terraform and enforced in policy: GAP-01 (CC6.1), GAP-02 (CC6.1),
GAP-03 (CC6.7), GAP-04 (A1.2), GAP-05 (CC6.6), GAP-07 (CC6.3).
Documented open: GAP-06, GAP-08 (both CC7.2) — see `WRITEUP.md`.

## Grader verification

**1. Confirm the starter still runs.** From `terraform/`:
terraform init

terraform apply -auto-approve

curl -sS -X POST "$(terraform output -raw api_url)" -H "content-type: application/json" -d '{"patient_id":"P-0001","fields":{"reason":"test"}}'
Expect: `{"submission_id": "...", "status": "received"}`

**2. Confirm the policy suite passes.** From repo root:
opa test policies/capstone/ -v
Expect: `PASS: 18/18`

**3. Confirm the pipeline gate works.** In PR history:
- Green PR #6 — compliant change, gate passed, merged.
- Red PR #7 — reintroduced GAP-04, gate blocked, closed unmerged.

**4. Verify a signed evidence bundle.** From repo root (requires AWS creds + cosign):
EVIDENCE_VAULT=cgep-lab-grc-evidence-vault-d267bb51 bash scripts/verify-evidence.sh 27848293937 --prefix capstone/runs
Expect: `CHAIN INTACT for run 27848293937`

**5. Validate the OSCAL.** From `oscal/`:
trestle validate -f component-definitions/capstone-system/component-definition.json
Expect: `VALID`

## OSCAL traversal (the audit-without-a-meeting demonstration)

Start at `oscal/component-definitions/capstone-system/component-definition.json`.
Each of the 5 implemented requirements maps a SOC 2 criterion to real Terraform
resources (`props`) and a signed evidence bundle (`links[rel=evidence]`).
The `source` points at the self-authored SOC 2 catalog in `oscal/catalogs/soc2-tsc/`.
Follow an evidence href into the vault, run the verify script (step 4), see `CHAIN INTACT`.