# Contract-Month Migration Example

Sanitized from a user-provided handoff dated 2026-09-20. This illustrates case
construction and the limits of the reported evidence; it is not a reusable test
fixture, a required case count, or evidence that another implementation works.
Do not include the known findings below in a first-pass reasoner's inputs.

## Intent And Neutral Introduction

An entitlement service owns contracts, seats, assignments, and migration plans.
A quota service owns allowance buckets, charges, and refunds. New purchases use
contract months. Existing seats move from calendar months at the earliest
contract boundary for which preparation has completed. Migration preserves seat
identity, assignment, and contract validity; it does not wait for a multiyear
contract to end. Dates use Asia/Shanghai, and period intervals are half-open.

## A Normal Expected Case

A seat starts on August 20 with a 36-month contract and 100 credits per period.
Upgrade preparation finishes at noon on September 20, after that day's boundary.
The next eligible boundary is October 20. The seat stays assigned and usable;
normal authorization and service freshness prerequisites hold.

| Event / observation | Expected result |
|---|---|
| Before October 20 | The old calendar-month bucket remains the applicable source |
| October 20 boundary | Exactly one current period: contract period 3, `[October 20, November 20)`, with 100 credits |
| Use 30 after the switch | 70 credits remain in that contract bucket |
| November 1, then use 10 | Still the same bucket: 70 before use, 60 afterward; no calendar-month reset |
| November 20 boundary | The next contract period receives 100 credits |
| Finish or refund an old request after the switch | Settle against its original debit/bucket; an old refund does not increase the new allowance |
| Replay installation or restart after persisted preparation | Preserve the plan and balances; do not issue the allowance twice |

The 30/10 amounts are chosen business expectations, not measured request usage.
Other cases should target distinct risks: month-end/leap-year arithmetic, expiry,
late preparation, future activation, released or frozen seats, cleanup, time-zone
conversion, retries, and coexistence of old and new versions. Select those that
belong to the actual contract rather than mechanically copying this list.

## What The Reported Exercise Found

The original exercise used 14 cases and found two defects subsequently confirmed
by the controller:

- **Previously assigned, now unassigned:** releasing a seat before migration
  installation left its historical calendar bucket without the cutover marker.
  After the switch, current-period queries could find both the old bucket and
  the contract bucket. The controller reproduced this through the real sync
  entry point with SQLite and MySQL, then fixed the historical-bucket update
  within the existing transaction and verified boundary and replay behavior.
- **Legacy read path disagreed with consumption:** consumption used the contract
  bucket, but an open calendar-month usage endpoint still reported the old
  balance as available. A focused check and HTTP reproduction confirmed it. The
  fix honored the cutover in that read path while preserving its calendar-month
  API meaning, rather than substituting a contract bucket into an old response.

The initial report was frozen before repair and execution logs went back to
the same reasoner. Its targeted recheck closed both findings. These are reported
results from one task, not a statistical success rate or proof of all 14 cases
under every runtime condition.

## Evidence Boundaries

The original evidence chain retained cases, source identity, initial report,
controller disposition, before/after execution logs, fix delta, and a recheck
report. A separate local exercise advanced a shared business clock in disposable
service copies to inspect the switch, lack of a calendar-month reset, next-period
refresh, settlement/refunds, and restart recovery. It used local databases and
did not add a clock backdoor to production code.

Driver/time-zone configurations, fault timing, lock competition, mixed old/new
binaries, real historical data, and scale still need evidence for the specific
claim. One local exercise or static trace cannot stand in for all of them.
Keep task artifacts with their source project under its retention policy;
reusable examples must not embed local credentials or private evidence bundles.
