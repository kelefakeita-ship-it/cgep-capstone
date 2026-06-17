\# AWS Security Services Baseline (Lab 5.2)



This baseline deploys the AWS-native compliance backbone — always-on services that

produce evidence continuously, independent of PR-triggered pipeline runs.



\## Services and controls



| Service | NIST 800-53 Controls | Purpose |

|---------|----------------------|---------|

| CloudTrail | AU-2, AU-12, AU-10 | Multi-region audit logging with log-file validation |

| Security Hub | RA-5, SI-4 | Continuous compliance checks against NIST 800-53 Rev 5 + FSBP |

| AWS Config | CM-2, CM-6, CM-8 | Resource configuration recording (required by Security Hub checks) |



\## Key design points



\- \*\*CloudTrail\*\* is multi-region with `enable\_log\_file\_validation = true` (AU-10).

&#x20; Every hour it emits a digest file signed by an AWS-managed key, detecting tampering.

\- \*\*Security Hub\*\* subscribes to NIST 800-53 Rev 5 and AWS Foundational Security Best

&#x20; Practices. Both map to the same control IDs auditors ask about.

\- \*\*AWS Config\*\* records how each resource is configured. Many Security Hub controls

&#x20; require Config to evaluate.



\## Evidence



`evidence/lab-5-2/security-hub-findings.json` — the first wave of Security Hub findings,

captured as machine-readable JSON for the audit trail.

