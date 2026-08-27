# Use-Case-Driven Transactional Application Services

This pattern targets backend business services. It may also be called
“用例驱动的轻量 DDD” (use-case-driven lightweight DDD) or
“用例驱动的分层架构” (use-case-driven layered architecture). Its fullest name
here is “用例驱动的事务型应用服务” (use-case-driven transactional application
services).

The core combines layered architecture, DDD-style Application Services and
domain semantics, local transaction boundaries, lightweight CQRS, and explicit
state machines. Cross-boundary side effects run after commit; use transactional
Outbox only when reliable delivery is required. This is not the official name
of a single framework or a requirement to implement full DDD.

Apply project-specific architecture rules first. Treat the layers below as
responsibilities, not mandatory directories, traits, or abstractions. Do not
expand an approved change into a legacy rewrite.

## Scope And Shape

Use this guidance for backend HTTP/RPC business APIs, background business
commands, transactional writes, and permission-sensitive or complex business
queries. Do not impose it on frontend code, generic libraries, stateless
protocol adapters, migrations, pure analytics pipelines, or trivial data
plumbing without business invariants.

```text
Command: Handler -> Application Service -> Domain / Owned Persistence -> Database
Query:   Handler -> Query Service / Read Model -> Database
```

## Responsibility Boundaries

### Handler

Translate the protocol, validate request shape, establish authenticated context,
invoke one business use case, and map its result to a response. Keep business
SQL and cross-entity transaction orchestration out of handlers. Authorization
that depends on current business state belongs with the use case or its domain
policy, unless project rules deliberately centralize it elsewhere.

### Application Service

Name operations after business actions such as `completeInvitation` or
`removeMember`, not table CRUD. The Application Service owns use-case
orchestration, business authorization, idempotency where needed, and the local
database transaction boundary. One business action either commits its database
changes together or rolls them back together.

Keep durable business rules in domain concepts or explicit policies rather than
burying them in protocol glue. A single-database transaction is not a substitute
for a saga or process manager when a workflow spans independent systems.

### Domain And Owned Persistence

Expose transaction-scoped capabilities with domain meaning, such as activating
a pending member or releasing a seat. Low-level insert, update, and delete
operations may exist behind the owning module, but should not let other modules
bypass its invariants.

Keep SQL with the module that owns the data. When persistence access, schema, or
sharding is part of the semantic delta, apply
[Backend Database Schema and Migrations](backend-database-schema-and-migrations.md).
Do not add repository traits or wrapper types solely to imitate an architectural
diagram.

### State And Concurrency

Express legal state transitions explicitly instead of allowing arbitrary status
writes. Protect concurrent transitions with the mechanism appropriate to the
invariant: conditional updates, affected-row checks, locks, versioning, unique
constraints, or other database guarantees. Types clarify legal states; the
database still has to enforce races and persisted invariants that types cannot
see.

### Side Effects

Do not perform remote calls, notifications, cache publication, or message sends
inside a database transaction when they can outlive a rollback or hold locks
open. Run best-effort side effects after commit. When delivery must be reliable,
write an Outbox record in the same transaction and deliver it asynchronously.

### Queries

Read paths may bypass domain mutation APIs and use a focused Query Service or
read model. They must still enforce tenant scope, authorization, data ownership,
and read-only behavior. Lightweight CQRS is permission to optimize reads, not
permission for handlers to accumulate arbitrary business SQL.

## Proportional Verification

Use types, visibility, transaction APIs, and database constraints first. Add
focused tests only for stable, consequential behavior that remaining evidence
cannot prove, such as important state transitions, rollback semantics,
idempotency, concurrency conflicts, authorization boundaries, or reliable
Outbox creation. Do not require a test merely because a use case crosses layers.

## Review Questions

- Is the entry point named and shaped around a business use case rather than a
  table operation?
- Are protocol concerns in the handler and the local transaction boundary in
  the Application Service?
- Do cross-module writes use semantic capabilities owned by the affected data
  module instead of foreign SQL or exposed CRUD?
- Are state transitions and concurrency guarantees explicit and enforced at the
  appropriate runtime or database boundary?
- Can an external side effect occur before commit, survive rollback, or require
  an Outbox for reliable delivery?
- Do optimized queries still enforce tenant and authorization boundaries?
- Is verification proportional to the actual invariant and regression risk?
