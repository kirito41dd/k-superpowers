# Full Brainstorming Flow

Use Full when the work contains several coupled decisions or material
irreversibility, security, permission, protocol, migration, or compatibility
risk.

1. Inspect existing constraints and separate independently deliverable scopes
   when that reduces risk or waiting time.
2. Ask only blocking questions. Batch related questions when the user can answer
   them together; use choices when they clarify a real trade-off.
3. Present viable alternatives only where more than one approach is genuinely
   reasonable. Recommend one and explain the consequential trade-offs.
4. Present one coherent design covering architecture, boundaries, data/control
   flow, failure behavior, authorization, and verification. Obtain approval for
   the material decisions; do not require approval after every section.
5. Record `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` when the durable
   artifact will support cross-session implementation, review, or future
   decisions. Self-review it once for consistency and missing decisions.
6. Ask separately before committing the document. Design approval can authorize
   implementation edits when the user explicitly asks to proceed, but it never
   authorizes a commit or external action.

Follow existing project patterns and avoid unrelated improvement work.
