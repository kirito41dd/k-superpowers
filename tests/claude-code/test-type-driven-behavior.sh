#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

extra="--plugin-dir \"$PLUGIN_DIR\""

rust=$(run_claude "Use k-superpowers:type-driven-verification. Design a Rust import job currently represented by three conflicting booleans, a raw String account id, unvalidated JSON, an error that may be ignored, and a resource that must not outlive its session. State the type/API design, only the tests still needed, and which core structures/functions need explanatory comments versus which comments would be noise." 60 "" "$extra")
assert_contains "$rust" "enum\|newtype\|private\|constructor" "Rust excludes invalid states"
assert_contains "$rust" "Result\|error" "Rust propagates errors"
assert_contains "$rust" "ownership\|borrow\|lifetime\|Drop\|resource\|所有权\|生命周期" "Rust models resource lifetime"
assert_contains "$rust" "comment\|doc comment\|docstring\|注释\|文档注释" "Core explanations are considered"
assert_contains "$rust" "invariant\|lifetime\|caller\|usage\|protocol\|state transition\|不变量\|生命周期\|调用方\|状态转换" "Core explanations cover non-obvious contracts"

no_test=$(run_claude "Use k-superpowers:type-driven-verification. A Rust function changes from fn lookup(id: String) to fn lookup(id: ValidatedId), with no runtime behavior change. Decide whether a new test is mandatory and name verification." 60 "" "$extra")
assert_contains "$no_test" "not mandatory\|not required\|optional\|不需要\|非必须" "Type-only change does not force tests"
assert_contains "$no_test" "cargo check\|cargo test\|compile\|编译" "Type-only change still verifies"

ts=$(run_claude "Use k-superpowers:type-driven-verification. Design a TypeScript API boundary receiving unknown JSON with two valid variants. Explain static and runtime guarantees without copying Rust-specific wrappers." 60 "" "$extra")
assert_contains "$ts" "runtime\|schema\|parse\|validate\|运行时\|校验" "TypeScript validates untrusted input"
assert_contains "$ts" "discriminated union\|union\|联合" "TypeScript uses native type capabilities"
assert_not_contains "$ts" "Rust.*newtype\|typestate\|PhantomData" "TypeScript avoids Rust-specific wrappers"

echo "type-driven behavior scenarios passed"
