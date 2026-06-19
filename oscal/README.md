\# OSCAL Layer (Lab 6.1)



Machine-readable compliance documentation. An assessor traverses from a NIST

control catalog to a profile to a component definition to a real evidence URI

— without ever talking to me.



\## Structure



| File | Model | Purpose |

|------|-------|---------|

| `component-definitions/compliant-s3-v1/component-definition.json` | Component Definition | Describes `primitives/compliant-s3` (Lab 2.3) and how it implements SC-28, AC-3, AU-3, CM-6 |

| `profiles/cge-p-minimum/profile.json` | Profile | Selects the four controls this portfolio currently implements, from the NIST 800-53 Rev 5 catalog |

| `catalogs/cge-p-minimum-resolved/catalog.json` | Resolved Catalog | Output of `trestle author profile-resolve` — full control text (statement, guidance, assessment objectives) for the four selected controls |



\## The traversal an assessor follows



1\. Open `component-definitions/compliant-s3-v1/component-definition.json`.

2\. Pick a control, e.g. `sc-28`.

3\. Follow `implemented-requirements\[].links\[rel=evidence].href` —

&#x20;  an `s3://` URI pointing into the Lab 2.5 evidence vault.

4\. Run `EVIDENCE\_VAULT=<vault> bash scripts/verify-evidence.sh <run\_id>`.

5\. See `CHAIN INTACT`.



No meeting required. The component definition, the NIST catalog reference,

the implementation statement, the evidence URI, and the signed bundle in the

vault are linked end to end.



\## Validation



Both models pass `trestle validate`. Output captured in

`evidence/lab-6-1/trestle-validate.txt`.



\## Component-to-Terraform mapping



| Control | Terraform Resource | Lab |

|---------|---------------------|-----|

| SC-28 | `aws\_s3\_bucket\_server\_side\_encryption\_configuration.primary` | 2.3 |

| AC-3 | `aws\_s3\_bucket\_public\_access\_block.primary` | 2.3 |

| AU-3 | `aws\_s3\_bucket\_logging.primary` | 2.3 |

| CM-6 | `aws\_s3\_bucket\_versioning.primary` | 2.3 |



\## Note on evidence freshness



The Lab 2.5 evidence vault uses GOVERNANCE-mode Object Lock with a 1-day

retention (lab setting; production would use COMPLIANCE mode with 365-day

retention — see Lab 5.2 baseline pattern). Evidence URIs in the component

definition must point at a recent pipeline run for `verify-evidence.sh` to

pass the retention check. Current URIs reference run `27812236270`.

