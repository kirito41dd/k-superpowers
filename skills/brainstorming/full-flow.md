# Full Brainstorming Flow

Use when requirements span domains, need multiple blocking clarifications,
contain material architecture alternatives, or involve irreversible/security/
protocol/public compatibility risk.

1. Explore existing project context and identify whether the work needs
   decomposition into independently deliverable specs.
2. Ask one requirement question per message; prefer concise choices where useful.
3. Present 2-3 viable approaches with trade-offs and a recommendation.
4. Present the design in coherent sections proportional to complexity. Cover
   architecture, boundaries, data/control flow, failures, and verification;
   obtain approval after each section.
5. Write `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` and self-review
   placeholders, consistency, scope, and ambiguity.
6. Ask the user to approve with or without a documentation-only commit, or
   request changes. Only explicit commit selection authorizes that commit.
7. Invoke `k-superpowers:writing-plans`; design approval never authorizes
   implementation.

Follow existing project patterns and improve only boundaries touched by the
request. Keep units focused and interfaces explicit; avoid unrelated refactors.
