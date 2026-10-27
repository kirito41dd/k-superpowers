#!/usr/bin/env bash
# Run candidate test files separately to locate unwanted file/state creation.
# Usage: ./find-polluter.sh <file_or_dir_to_check> <test_pattern>
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "usage: $0 <file_or_dir_to_check> <test_pattern>" >&2
  exit 2
fi

POLLUTION_CHECK=$1
TEST_PATTERN=$2
case "$TEST_PATTERN" in
  ./*|/*) ;;
  *) TEST_PATTERN="./$TEST_PATTERN" ;;
esac

if [ -e "$POLLUTION_CHECK" ] || [ -L "$POLLUTION_CHECK" ]; then
  echo "cannot isolate pollution: target already exists: $POLLUTION_CHECK" >&2
  exit 2
fi

TEST_FILES=()
while IFS= read -r -d '' file; do
  TEST_FILES+=("$file")
done < <(find . -type f -path "$TEST_PATTERN" -print0)
TOTAL=${#TEST_FILES[@]}
if [ "$TOTAL" -eq 0 ]; then
  echo "no test files matched: $TEST_PATTERN" >&2
  exit 2
fi

COUNT=0
for TEST_FILE in "${TEST_FILES[@]}"; do
  COUNT=$((COUNT + 1))
  echo "[$COUNT/$TOTAL] Testing: $TEST_FILE"
  if npm test -- "$TEST_FILE"; then
    test_status=0
  else
    test_status=$?
  fi

  # Pollution is useful evidence even if the test also failed.
  if [ -e "$POLLUTION_CHECK" ] || [ -L "$POLLUTION_CHECK" ]; then
    echo "pollution appeared after: $TEST_FILE"
    echo "created: $POLLUTION_CHECK"
    exit 1
  fi
  if [ "$test_status" -ne 0 ]; then
    echo "cannot complete isolation: test runner exited $test_status for $TEST_FILE" >&2
    exit 2
  fi
done

echo "no pollution observed after $TOTAL test files completed"
