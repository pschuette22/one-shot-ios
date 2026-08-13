# __APP_NAME__ — CLAUDE.md

## Overview

`__APP_NAME__` is a Tuist-managed SwiftUI app. Modules under `Modules/` contain
reusable features; the app target under `__APP_NAME__/` wires them together.

## Build & Test

**Always build and test through `make`.** Never invoke `tuist`, `xcodebuild`, or
`swift` directly — the Makefile is the single source of truth for reproducible
actions and pins tool versions via `.tuist-version` / `.xcode-version`.

| Command              | Purpose                                                       |
| -------------------- | ------------------------------------------------------------- |
| `make setup`         | Verify/install Xcode and Tuist at the pinned versions         |
| `make project`       | Run `tuist install` + `tuist generate` to produce the project |
| `make build`         | Build the app target (override with `TARGET=...`)             |
| `make unit-test`     | Run swift-testing unit suites                                 |
| `make snapshot-test` | Run snapshot suites (`REPLACE=1` to re-record baselines)      |
| `make test`          | Run all tests (unit + snapshot)                               |

Run `make setup` once on a fresh checkout, then `make project` before opening
the workspace.

## Snapshot tests

Snapshot tests use [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing).
Baselines live in `__Snapshots__/` next to each test file and are the source of
truth for visual regressions.

**Whenever you modify a view or any code exercised by a snapshot test, run:**

```sh
make snapshot-test REPLACE=1
```

This re-records the affected `.png` files. Then run `make snapshot-test` (no
`REPLACE`) to confirm stability, and review every changed image before
committing — `REPLACE=1` will silently overwrite intentional designs.

Use `FILTER=SuiteName/testName` to scope a re-record.

## Modules

Each module in `Modules/<Name>/` follows this shape:

```
<Name>/
├── Project.swift          # framework + Tests + SnapshotTests targets
├── CLAUDE.md              # module-scoped notes
├── Sources/               # public API (namespaced under `enum <Name> {}`)
├── Playground/            # <Name>.playground for isolated experimentation
├── Tests/                 # swift-testing unit tests
└── SnapshotTests/         # UI regression + __Snapshots__/
```

New modules should follow the same layout — copy `Modules/ExampleFeature/` as a starting point and update `Project.swift`, `Workspace.swift`, and this file's dependency graph.

## Testing framework

Tests use `swift-testing` (`import Testing`, `@Suite`, `@Test`, `#expect`) — not XCTest.

## Ongoing maintenance

CLAUDE.md files should evolve with the project. Directories with more than a
handful of files or subdirectories deserve their own CLAUDE.md that summarizes
what lives there and any non-obvious conventions.
