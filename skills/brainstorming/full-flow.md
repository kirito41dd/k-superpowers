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
5. Record `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` when the durable
   artifact will support cross-session implementation, review, or future
   decisions. Apply the single self-review described in `SKILL.md`.
6. Ask separately before committing the document. Design approval can authorize
   implementation edits when the user explicitly asks to proceed, but it never
   authorizes a commit or external action.
7. When implementation is authorized, assess execution topology once before
   editing. Use `k-superpowers:writing-plans` when staged execution, continuity,
   or delegation makes a persistent plan useful; otherwise use Inline in the
   current workspace with no commit.

Follow existing project patterns and avoid unrelated improvement work.
