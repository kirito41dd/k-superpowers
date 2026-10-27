# Testing Anti-Patterns

Use this reference for a concrete assertion, isolation, fixture, or testability
question. [Test Selection](SKILL.md#test-selection) owns whether a persistent
test is warranted; this reference does not require tests for every change.

## Assertions That Only Prove The Double Works

Checking that a mock element exists or returns its configured value does not
prove the production behavior. Assert the observable contract at a narrow,
stable boundary. Interaction assertions are useful when the interaction itself
is the contract, such as whether an external side effect occurs once.

## Production APIs Added Only For Tests

Do not expose production methods or reshape abstractions solely for test
inspection or cleanup. Keep test setup and cleanup in appropriate fixtures or
test utilities without bypassing real resource ownership and lifecycle rules.

## Mocking Away The Behavior Under Test

Understand which side effects and dependencies establish the invariant before
replacing them. Mock a slow or external dependency rather than the operation
whose behavior the test must exercise. For example, testing duplicate
registration needs the real registration state changes, even if external
startup is replaced. Do not substitute a fake for the guarantee being checked.

## Invalid Or Brittle Fixtures

Fixtures must satisfy the real boundary's schema and relevant behavior. Reuse
existing typed builders, contract fixtures, or parsed samples when useful;
do not copy unrelated fields or build new fixture infrastructure merely for
completeness. Override only what distinguishes the case.

## Missing Evidence Confused With Missing Tests

The defect is claiming completion without relevant evidence, not the absence
of newly written tests. Use types, compiler checks, existing verification, or a
bounded reproducer where they establish the claim. Add persistent tests only
when the Test Selection criteria justify lasting protection of a core contract
or high-value regression risk. A concrete failure needs verification after the
fix; the reproducer need not become a maintained test.

## Disproportionate Test Infrastructure

Treat mocks, fixtures, and harnesses as maintained code. If setup or incidental
coupling outweighs the confidence gained, simplify the boundary, reuse an
existing check, or omit the low-value test. A real-component or integration
check can be simpler than elaborate mocks when it proves the relevant risk;
this does not require a new integration suite or duplicate coverage at every
layer. Use actual database or external-system evidence when the claim depends
on behavior a mock cannot establish, within the task's authorized environment.
