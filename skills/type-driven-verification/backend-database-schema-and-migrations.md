# Backend Database Schema and Migrations

This guidance targets internet-facing backend OLTP services whose data may later
be sharded or split across independently owned stores. Project-specific database
rules remain authoritative. Do not impose these defaults on analytics systems,
embedded databases, or deliberately single-database applications with different
integrity requirements.

## Online Schema Evolution

Give every table and schema object one migration owner. Run DDL through an
explicit migration step with dedicated least-privilege credentials; application
startup should not mutate schema, and runtime credentials should not have DDL
permission. Where deployment permits, give runtime DML, schema migration, and
data migration separate identities with only the permissions each needs; do not
let a backfill inherit DDL authority for convenience.

Keep published migrations immutable and forward-only. An additive migration is
safe for an online rollout only when every supported old service version can
continue its normal reads and writes against the new schema. If that cannot be
proved, use a staged sequence across releases:

```text
Expand -> compatible writes -> Backfill -> Cutover -> Contract
```

Separate physical schema migration from business data migration. A backfill
should be idempotent, resumable, bounded in batches, observable, and verified
before a later Contract step depends on it. Do not hide full-table business DML
inside DDL.

Compatibility is not the only production risk. Assess the actual database
version, DDL algorithm and lock behavior, duration, disk growth, replication
lag, interruption semantics, stop conditions, and recovery plan. Database
backup or PITR and a forward-fix path are operational safeguards, not reasons to
pretend a destructive change is backward compatible.

## Persistence Access

Prefer the project's ORM or typed query builder for routine access. The security
contract is parameter binding, not the library name: raw SQL remains acceptable
when it is materially clearer or needed for verified performance, but keep it in
the owning persistence module and bind every external value. Map structural
inputs such as column names, sort direction, and SQL fragments through enums or
explicit allowlists.

ORMs reduce repetitive SQL and some database coupling; they do not erase
database-specific transaction, locking, collation, index, upsert, or DDL
semantics. Use database-native behavior deliberately when correctness depends on
it, without leaking ad hoc SQL across module boundaries.

## Identity And Sharding

Treat an auto-increment key as a table- or shard-local row identifier. Do not
expose it as the identity used by APIs, messages, cross-service contracts, or
cross-shard references. Use an application-generated, globally unique,
immutable business ID for those boundaries. Choose its exact representation
from project scale, ordering, privacy, and storage needs rather than mandating a
single UUID or Snowflake variant.

Make the scope of uniqueness explicit. Carry the tenant or shard key through
relevant queries, joins, and shard-local unique indexes. Do not assume a local
sequence, unique constraint, or transaction provides a global guarantee across
shards.

## Integrity Without Foreign Keys

For shardable or independently owned backend stores, avoid database foreign
keys across business entities by default. They bind lifecycle and deployment to
one physical database and do not extend across shards.

No foreign keys does not mean no integrity. Preserve references with the
combination appropriate to the invariant:

- current-read validation inside the owning business transaction;
- `NOT NULL`, `UNIQUE`, `CHECK`, and useful reference indexes;
- conditional updates, affected-row checks, versions, or explicit locks for
  concurrent changes;
- dependency checks and explicit cleanup during deletion workflows;
- reconciliation, orphan detection, and repair paths for failures that cannot be
  prevented atomically.

A project intentionally relying on foreign keys in a single owned database may
keep them; do not remove established constraints merely to appear shard-ready.

## Data Semantics And Indexes

Persist absolute instants in UTC. For MySQL business data, `DATETIME(3)` is a
useful default; use `DATE` for civil dates, preserve an IANA time-zone ID for
user-local schedules, and store durations as numeric units. Use exact numeric
representations such as integer minor units or `DECIMAL` for money, never
floating point.

Derive indexes from real filtering, joining, ordering, and pagination paths.
Include tenant/shard scope where the access path requires it, and validate
material choices with `EXPLAIN` and representative data. Avoid speculative wide
indexes and do not use timestamps alone as uniqueness, total ordering, or
concurrency control.

For common MySQL B-tree access paths, place tenant/owner and other
equality-constrained columns before the first range column in a composite index.
After interval construction reaches a range predicate, later columns generally
do not narrow that scan interval further, though they may still help through
index condition pushdown, covering, or ordering. Do not put time first merely
because queries include a time window; prefer it first only when time-range-only
access is an important path, and confirm exceptions from the real query plan.

## Proportional Evidence

Match evidence to the claim. An online-compatible migration needs the relevant
old-service/new-schema path and operational DDL risks checked; a large-table or
performance claim needs the target database and representative scale. A small
additive DDL change does not need persistent tests that freeze SQL formatting,
but it still needs migration inspection and the project's focused schema checks.

Review the applicable questions:

- Does one owner control the schema, migration, and persistence boundary?
- Can supported old services keep reading and writing after the migration?
- Is a data backfill separate, resumable, and complete before Contract?
- Are SQL values bound and structural inputs allowlisted?
- Are local row IDs, business IDs, tenant/shard keys, and uniqueness scopes
  unambiguous?
- Without foreign keys, what prevents or detects invalid references and races?
- Are data types and indexes justified by business semantics and real access
  paths?
- Are lock, disk, replication, interruption, and recovery risks understood?
