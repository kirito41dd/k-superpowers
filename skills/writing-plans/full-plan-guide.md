# Full Plan Guide

A Full plan should let another skilled agent continue without rediscovering
material decisions. Organize it around independently deliverable behavior, not
horizontal layers or fixed step counts.

For each meaningful slice, include the files/boundary, approved behavior,
interfaces or dependencies, consequential design constraints, and the smallest
verification that supports completion. Add signatures or data shapes where
prose would leave a material choice. Tests are required only for named runtime
or recurrence risks that static guarantees cannot prove.

Checkpoint commits appear only when the execution route explicitly authorizes
them. Routine code, mechanical steps, and low-value boilerplate do not need to
be spelled out. Avoid placeholders and undefined APIs, but trust the executor to
make local choices from project patterns.

Self-review the plan once for requirement coverage, conflicting decisions,
cross-slice dependencies, user-change ownership, verification scope, and any
material choice that still needs approval.
