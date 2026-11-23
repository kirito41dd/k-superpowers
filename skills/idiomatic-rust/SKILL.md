---
name: idiomatic-rust
description: Use when writing or reviewing substantive Rust code or diagnosing Rust-specific ownership, trait, async or safety issues. Skip mechanical edits and prose-only changes.
---

# Idiomatic Rust

Start with the crate's callers, public API, edition, minimum supported Rust
version (MSRV), enabled features and established conventions where relevant.
In a shared library, downstream compatibility matters. In application code,
a concrete type and a local decision will often suffice.
When reviewing Rust, use the [review guide](review.md) to trace the change
through the callers that could observe a failure.

## Model the domain at the call site

- Give each value invariant one construction path. If stock must be
  nonnegative, keep the raw field of `Quantity` private and validate it in
  `Quantity::try_new` or `TryFrom`. Both `add_item` and the file loader
  obtain a `Quantity` through that boundary. Check deserialization and update
  methods too: either can bypass a constructor. Rules that depend on more
  than the value, such as available stock for an order, belong with the
  operation that knows that state.
- Read the call without its declaration. `report(Verbosity::Full)` explains
  a choice that `report(true)` hides. Distinct newtypes for product IDs,
  quantities and prices catch argument swaps. When the data depends on the
  state, variants such as `Paid { receipt }` and `Failed { reason }` keep
  the relevant payload with that state. Use these types where they prevent
  a plausible mistake.

## Ownership and interfaces

- For a function that reads text during the call, consider `&str`. When it
  will keep a caller's existing `String`, taking it by value can avoid a copy.
  At a suspicious `clone()`, identify who needs the second owner and for how
  long. A small intentional copy can be simpler than sharing mutable state.
- Use `From` for infallible, value-preserving conversions. Use `TryFrom`
  when input can be rejected. Changes to public fields, variants, trait
  bounds or error types can break downstream callers.
- If library callers need to recover differently from invalid input and a
  transient I/O failure, keep those outcomes distinguishable. An application
  can add context such as the path or operation while preserving the cause.
  Check panic paths against what the caller can supply.

## Contracts the compiler cannot check

- Keep hashing and ordering consistent with equality. For borrowed lookups
  in a `HashMap`, the key and its borrowed form must agree on equality and
  hashing. A case-insensitive key can expose its spelling via `AsRef<str>`.
  Implementing `Borrow<str>` would promise the case-sensitive semantics of `str`.
- Check which resource is owned across each relevant `.await`. For a cache,
  copying a small result and releasing a lock before network I/O may suffice.
  If a protocol requires exclusivity across a wait, examine contention,
  cancellation and whether the protected state stays usable.
- When callers need to observe a failure while flushing or closing a resource,
  expose a fallible operation such as `finish(self) -> Result<…>`. `Drop`
  handles remaining cleanup when the caller leaves early.
- For `unsafe` and FFI, identify the lifetime, aliasing, layout or allocator
  invariant that makes the operation valid. Explain caller obligations at the
  boundary and why the implementation satisfies them at the operation. Keep
  ownership of foreign allocations and the matching release operation explicit.

Use the project's supported Cargo commands and feature combinations. Choose
verification for the risk with `k-superpowers:type-driven-verification`.
