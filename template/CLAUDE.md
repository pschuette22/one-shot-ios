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
| `make setup`         | Verify/install Xcode and Tuist at the pinned versions; sync `.env.local` |
| `make project`       | Run `tuist install` + `tuist generate` to produce the project |
| `make build`         | Build the app target (override with `TARGET=...`)             |
| `make unit-test`     | Run swift-testing unit suites                                 |
| `make snapshot-test` | Run snapshot suites (`REPLACE=1` to re-record baselines)      |
| `make test`          | Run all tests (unit + snapshot)                               |

Run `make setup` on a fresh checkout, then `make project` before opening the
workspace. Re-run `make setup` after a pull that adds an `.env.template` key.

## Local environment

`make setup` maintains `.env.local` (git-ignored) from the tracked
`.env.template`: it creates the file when absent, and on later runs appends any
template key the local file is missing, printing each as `+ KEY`. **Existing
values are never read or rewritten**, so a filled-in secret survives every run
— which makes `make setup` how you pick up a new key after a pull, not just a
first-checkout step.

The `Makefile` sources `.env.local` before every `tuist` invocation, so any
variable prefixed `TUIST_` reaches the `Project.swift` manifest via
`Environment.<camelCase>`. The starter file just declares `TUIST_DEV_TEAM_ID`,
which flows into automatic code signing (see `Settings.appSettings`); add more
`TUIST_*` variables as the project needs them — adding one to `.env.template`
is enough for every developer's next `make setup` to pick it up.

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

New modules should follow the same layout — copy `Modules/DesignSystem/` as a starting point (skipping its `Catalog/` app target unless the new module also warrants one) and update `Project.swift`, `Workspace.swift`, and this file's dependency graph.

### DesignSystem

`Modules/DesignSystem/` ships a seed design system: color, typography, spacing,
and radius tokens plus a starter component. Its companion `DesignSystemCatalog`
app target renders every token and component so the visual language stays
runnable — and reviewable — on its own. Extend it as the product needs land;
see `Modules/DesignSystem/CLAUDE.md` for the conventions.

## Testing framework

Tests use `swift-testing` (`import Testing`, `@Suite`, `@Test`, `#expect`) — not XCTest.

## Ongoing maintenance

CLAUDE.md files should evolve with the project. Directories with more than a
handful of files or subdirectories deserve their own CLAUDE.md that summarizes
what lives there and any non-obvious conventions.
