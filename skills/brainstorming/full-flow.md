# Full Brainstorming Flow

Use Full when the work contains several coupled decisions or material
irreversibility, security, permission, protocol, migration, or compatibility
risk.

1. Inspect existing constraints and separate independently deliverable scopes
   when that reduces risk or waiting time.
2. Ask only blocking questions. Batch related questions when the user can answer
   them together; use choices when they clarify a real trade-off.
3. Present viable alternatives only for unresolved decisions where more than
   one approach is genuinely reasonable. Recommend one and explain the
   consequential trade-offs.
4. Present one coherent design using the Design Content guidance in `SKILL.md`.
   Make consequential architecture, data/control flow, failure, and authorization
   boundaries clear within that short design, not a section for every dimension.
   Obtain approval only for unsettled material decisions.
5. Record the design for reviewers and future maintainers as described in
   `SKILL.md`. Apply its single self-review. Keep the spec with the change
   for delivery when the user authorizes the implementation commit.
6. When implementation is authorized, assess execution topology once before
   editing. Use `k-superpowers:writing-plans` when staged execution, continuity,
   or delegation makes a persistent plan useful; otherwise use Inline in the
   current workspace with no commit.

Follow existing project patterns and avoid unrelated improvement work.
