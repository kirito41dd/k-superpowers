# Reviewing a Rust change

Start at the boundary the user asked to review. For a diff, follow changed
behavior into its constructors, callers and consumers as needed. An exported
library API may have callers outside the workspace. For an internal binary,
look at what its callers actually rely on. Check the crate's edition, MSRV,
features and framework conventions when they affect a finding or proposed fix.

## Find a reachable counterexample

Follow the risks in the diff. The [implementation guide](SKILL.md) explains
the underlying contracts. Useful review questions include:

- **Can another path construct an invalid value?** If `add_item` rejects
  negative stock, try the same value through the import or deserialization
  path. Check whether a later mutation can also invalidate it. If two
  same-typed arguments are easy to swap, show a call that compiles with
  the wrong business meaning and what the caller would observe.
- **What can safe callers reach?** Trace malformed input to indexing,
  narrowing conversions or a panic. At an unsafe or FFI boundary, identify
  who establishes each required precondition. Missing safety documentation
  merits a documentation finding. A soundness finding needs a safe usage or
  reachable execution path that violates an actual safety requirement.
- **Which consumer sees the contract break?** For custom equality, hashing
  or ordering, follow a key through an actual lookup or set operation.
  For a changed public signature or error, identify the call, match arm or
  recovery path affected. Check whether the spec authorizes the change.
- **Who needs this resource next?** A lock across `.await` warrants tracing
  the waiter and the lock owner. For example, if the error branch awaits a
  retry that acquires the same non-reentrant mutex while the outer guard is
  live, the retry cannot progress. Also consider state left behind by
  cancellation and errors a caller needs to observe during cleanup.

## Evidence and findings

Reuse relevant project checks for the reviewed version and feature set. If a
question remains, pick the smallest check that distinguishes the outcomes,
such as inserting a key and looking it up by its borrowed form. Say what
remains unverified if the necessary toolchain or inputs are unavailable.

Lead with the highest-impact finding. Give its location, triggering condition,
observable consequence and smallest useful correction. Group instances with
the same cause. Cite the relevant trait, API or project contract when the
judgment depends on it. Use the [reviewer's severity and closure rules](../requesting-code-review/code-reviewer.md).
For a review-only request, return the findings or a clean verdict.
