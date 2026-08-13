# one-shot-ios — CLAUDE.md

## Overview

`one-shot-ios` is a scaffolder that produces new Tuist-based iOS project skeletons
tuned for LLM-assisted development. Given an app name, bundle id, and set of
platform targets, it emits a working project with:

- Tuist build system with pinned toolchain (`.tuist-version`, `.xcode-version`)
- Makefile as the single source of truth for build/test/lint
- Modular architecture (`Modules/<Name>/`) with per-module Playgrounds, unit tests, snapshot tests, and `CLAUDE.md`
- `swift-testing` for unit tests, `pointfreeco/swift-snapshot-testing` for UI regression
- `.claude/skills/` seed for LLM tooling

## Layout

```
one-shot-ios/
├── bin/scaffold.sh     # the scaffolder itself
├── template/           # the project skeleton (with __APP_NAME__ / __BUNDLE_ID__ / __PLATFORMS__ tokens)
├── Makefile            # `make new`, `make lint-template`, `make test-scaffold`
└── docs/               # design notes for the template
```

## Running the scaffolder

```sh
make new
```

Prompts interactively for App name, Bundle ID, Platforms, and Target directory.

Non-interactive form (use this when driving from an LLM session):

```sh
./bin/scaffold.sh \
  --app-name DemoApp \
  --bundle-id com.example.demo \
  --platforms iOS,macOS \
  --target-dir ../DemoApp
```

After scaffolding, the emitted project is ready to boot with:

```sh
cd <target-dir>
make setup     # verify Xcode + Tuist versions
make project   # tuist install + tuist generate
make test      # unit + snapshot tests
```

## Placeholder tokens

Files under `template/` contain these substitution tokens. Any new template file
must use them consistently — `make lint-template` fails the build if a stray
token slips through (or if a file references the app by its literal template name).

| Token             | Substituted with                                     |
| ----------------- | ---------------------------------------------------- |
| `__APP_NAME__`    | App name, e.g. `DemoApp` (used in dir names too)     |
| `__BUNDLE_ID__`   | Reverse-DNS bundle identifier                        |
| `__PLATFORMS__`   | Comma-joined ProjectDescription `.iOS,.macOS` list   |

Directory names that literally contain `__APP_NAME__` (e.g. `template/__APP_NAME__/`)
are renamed after the copy step.

## Conventions when extending the template

- Every new module folder gets: `Sources/`, `Tests/`, `SnapshotTests/`, `Playground/<Name>.playground/`, `Project.swift`, `CLAUDE.md`
- Test files use `swift-testing` (`import Testing`, `@Suite`, `@Test`, `#expect`) — never XCTest
- Snapshot tests keep baselines in `__Snapshots__/` next to the test file; recording is controlled by the `SNAPSHOT_TESTING_RECORD` env var (`missing` by default, `all` when `REPLACE=1` is passed to `make snapshot-test`)
- Root-level `Makefile` in the emitted project keeps its target set (`setup`, `project`, `build`, `unit-test`, `snapshot-test`, `test`) stable; anything the user runs frequently belongs there
- Every module directory with more than a couple files gets its own `CLAUDE.md`

## Ongoing maintenance

Prefer editing `template/` and letting `make test-scaffold` verify the emitted
result over adding logic to `bin/scaffold.sh`. The scaffolder should stay dumb
(copy + substitute + rename); the template is where design decisions live.
