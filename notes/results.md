# Experiment results

Current code is a random move-and-search scaffold, not an HMM solution.

| Date | Commit / branch | Method | n | Seed | Mean turns | SD | Seconds | Notes |
|---|---|---|---|---|---|---|---|---|
| 2026-09-30 | Initial scaffold (before commit) | Random move + search | 10 | 21 | 79.700 | 48.598 | 0.027 | macOS; smoke test only, not a performance pass |

Reference from WheresCroc 1.2.2: par mean 5.444, SD about 3.853 (500 games, seed 21).
Record machine/R version with timing measurements. Use additional seeds after
development; the assessment uses a different seed. Never label a smoke test as
evidence that the assignment performance target has been met.
