# Defense-in-Depth Validation

## Overview

Use this reference when evidence shows that protection at the owning boundary
leaves a distinct failure path, another trust boundary, or state that can change
after earlier validation. `type-driven-verification` owns the choice of types,
APIs, and runtime boundaries; this reference helps assess additional protection.

**Core principle:** Each additional guard must address a concrete remaining risk.
Do not duplicate checks merely because data crosses another layer.

## Why Multiple Layers

An existing type/API guarantee may be sufficient. Before adding a guard, name
the path or changed state that makes that guarantee insufficient. A mock that
violates the real boundary usually calls for fixing the test double, not another
production guard solely to accommodate it.

Different responsibilities can justify different protections:
- Entry validation rejects untrusted input.
- Business operations enforce domain invariants and current-state conditions.
- Environment guards restrict operations with separate resource or safety risks.
- Debug logging supplies evidence; it does not prevent invalid state.

## Possible Protection Points

The examples below are alternatives to select from, not four required layers.
Keep an extra check only when the actual call paths or state changes justify it.

### Layer 1: Entry Point Validation
**Purpose:** Reject obviously invalid input at API boundary

```typescript
function createProject(name: string, workingDirectory: string) {
  if (!workingDirectory || workingDirectory.trim() === '') {
    throw new Error('workingDirectory cannot be empty');
  }
  if (!existsSync(workingDirectory)) {
    throw new Error(`workingDirectory does not exist: ${workingDirectory}`);
  }
  if (!statSync(workingDirectory).isDirectory()) {
    throw new Error(`workingDirectory is not a directory: ${workingDirectory}`);
  }
  // ... proceed
}
```

### Layer 2: Business Logic Validation
**Purpose:** Enforce the business boundary when callers can reach it without
earlier validation. Omit a repeated shape check when all callers already provide
a validated value whose guarantee still holds.

```typescript
function initializeWorkspace(projectDir: string, sessionId: string) {
  if (!projectDir) {
    throw new Error('projectDir required for workspace initialization');
  }
  // ... proceed
}
```

### Layer 3: Environment Guards
**Purpose:** Prevent dangerous operations in specific contexts

```typescript
async function gitInit(directory: string) {
  // In tests, refuse git init outside temp directories
  if (process.env.NODE_ENV === 'test') {
    const normalized = normalize(resolve(directory));
    const tmpDir = normalize(resolve(tmpdir()));

    if (!normalized.startsWith(tmpDir)) {
      throw new Error(
        `Refusing git init outside temp dir during tests: ${directory}`
      );
    }
  }
  // ... proceed
}
```

### Layer 4: Debug Instrumentation
**Purpose:** Capture context for forensics. Instrumentation is diagnostic evidence,
not another validation layer; keep it bounded and remove temporary probes after
verification.

```typescript
async function gitInit(directory: string) {
  const stack = new Error().stack;
  logger.debug('About to git init', {
    directory,
    cwd: process.cwd(),
    stack,
  });
  // ... proceed
}
```

## Applying the Pattern

When you find a bug:

1. **Trace the data flow** - Where does bad value originate? Where used?
2. **Identify the owner** - Which type, API, or runtime boundary owns the invariant?
3. **Assess remaining paths** - Can real callers bypass that boundary, or can the
   relevant state change after validation? Add only the justified protection.
4. **Verify the distinct risk** - Check the symptom or reliable proxy and any
   newly protected failure path, following `type-driven-verification`'s focused
   evidence guidance.

## Example from Session

Bug: Empty `projectDir` caused `git init` in source code

**Data flow:**
1. Test setup → empty string
2. `Project.create(name, '')`
3. `WorkspaceManager.createWorkspace('')`
4. `git init` runs in `process.cwd()`

**Historical checks and instrumentation:**
- Layer 1: `Project.create()` validates not empty/exists/writable
- Layer 2: `WorkspaceManager` validates projectDir not empty
- Layer 3: `WorktreeManager` refuses git init outside tmpdir in tests
- Layer 4: Stack trace logging before git init

**Reported result:** 1847 tests passed and the pollution was not observed in that
run. This is evidence for the exercised behavior, not proof that all recurrence
paths are impossible.

## Key Insight

The historical implementation is not a checklist. Preserve the owning boundary,
justify each additional guard by its independent risk, and distinguish prevention
from diagnostic evidence. Guard count and layer count do not establish correctness.
