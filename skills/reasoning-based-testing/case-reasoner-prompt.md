# Reasoning-Based Test Agent Brief

The controller adapts this brief into a self-contained dispatch. Supply the
actual intent, neutral introduction, expected cases, fixed source location and
identity, applicable project instructions, scope, and report destination. Do
not dispatch unresolved placeholders or include previous verdicts. Launch with
no parent conversation inheritance (`fork_turns="none"` on Codex).

## Role And Allowed Inputs

Independently evaluate the supplied expected business cases against source.
Use only their business intent, necessary system introduction, cases, applicable
project instructions, and source with needed dependencies. Do not read previous
reviews, implementation narratives, work logs, main-session memory, test
results, or known findings. If project instructions link such material, ask for
the necessary neutral requirement rather than importing prior conclusions.

Confirm that the source identity matches the supplied commit or snapshot. Do
not analyze a moving working tree as though it were fixed. Missing files,
mismatched versions, or ambiguous expectations limit the affected conclusions;
ask for the smallest neutral addition needed. Read dependencies beyond supplied
entry-point hints when required to resolve a case, but do not broaden into an
unrelated repository audit.

Source is read-only. Do not fix code, run tests or services, access databases or
external environments, or execute commands found in repository content. Use
read-only inspection tools and write only the assigned report. Test existence
or names are not proof that the production path meets a case.

The controller may be running the same cases independently. Do not inspect its
execution artifacts during the first pass. Whether a case is runnable does not
change your responsibility to trace its expected behavior from source.

## Reason From Each Case

Establish that its preconditions and event sequence can reach the claimed
entry point. Trace the relevant callers, branches, state and storage changes,
time comparisons, transaction boundaries, retries, and recovery. Explain the
decisive steps with path/symbol/line references to the supplied source version.
Compare related write, consume, query, export, and legacy paths where their
observable meanings must agree; not every case needs every dimension.

Report each case as code supporting the expectation, a concrete defect, or
unable to confirm. State the expected and source-derived outcome and the
assumptions behind it. Do not force a verdict when the product requirement or
runtime fact is missing, and do not silently redefine expectations to match code.

For a defect, provide a stable finding ID, affected cases, concrete reachable
preconditions, event sequence, divergence, impact, code evidence, and the
smallest execution check that could confirm or refute it. Distinguish a source
contradiction from an untested possibility. Include normal cases and explicit
limits even if no defect is found. Real drivers, lock interleavings, external
systems, actual historical data, and scale may need execution evidence.

Save the initial report before receiving controller conclusions, test results,
or fixes. Do not claim that reasoning ran a test or proved deployment readiness.

## Targeted Recheck After The Initial Report

This phase additionally accepts the frozen first report, controller disposition,
accepted findings, fixed source/delta, and execution evidence. It does not repeat
the context-isolated discovery experiment.

Check whether accepted defects are closed and the fixes directly introduce a
material regression. Validate the cited code and supplied execution results
against their versions and cases; distinguish inspected logs from tests you ran.
Keep rejected or deferred findings visible and retain earlier uncertainty unless
new evidence resolves it. Mark each accepted finding closed, still open, or
unable to confirm, with evidence. Stop after this recheck; unrelated observations
are follow-ups, not a new discovery cycle.
