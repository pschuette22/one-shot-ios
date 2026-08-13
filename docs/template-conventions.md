# Template conventions

This document describes the design decisions baked into `template/` and why. It
exists so that anyone (LLM or human) editing the template can preserve intent.

## Toolchain pins

The template pins Xcode (`.xcode-version` = `26.3`) and Tuist (`.tuist-version` = `4.200.5`) via files at the project root. `scripts/setup.sh` reads those files and installs or selects matching versions via `xcodes` and `brew`. Bumping versions is a one-line change in the pin file; `make setup` handles the rest.

## Build system: Tuist + Makefile

Tuist owns project generation (no `.xcodeproj` in git). Makefile owns the interface a human or LLM uses to build and test. Rationale: `tuist ...` command flags shift between versions; the Makefile insulates callers from that churn and gives one place to add cross-cutting behavior (e.g., snapshot record mode toggles).

Standard Makefile targets — **do not rename**:

| Target              | Purpose                                                       |
| ------------------- | ------------------------------------------------------------- |
| `make setup`        | Install/verify Xcode + Tuist at pinned versions               |
| `make project`      | `tuist install` + `tuist generate`                            |
| `make build`        | Build a target (`TARGET=<name>`, defaults to app)             |
| `make unit-test`    | Run swift-testing suites (`FILTER=Target/Suite/case`)         |
| `make snapshot-test`| Run snapshot suites (`REPLACE=1` to re-record baselines)      |
| `make test`         | `unit-test` + `snapshot-test`                                 |

## Module shape

Every module under `template/Modules/<Name>/` has the same layout:

```
<Name>/
├── Project.swift          # framework + Tests + SnapshotTests targets
├── CLAUDE.md              # module-scoped overview
├── Sources/               # public code (marked `public`), namespaced under the module name
├── Playground/            # <Name>.playground for isolated experimentation
├── Tests/                 # swift-testing unit tests
└── SnapshotTests/         # swift-snapshot-testing UI regression + __Snapshots__/
```

The module name doubles as the Swift namespace enum (e.g. `public enum ExampleFeature {}`) to keep types organized when the API surface grows.

## Testing

Unit tests use `swift-testing` (Apple, iOS 18+): `import Testing`, `@Suite`, `@Test`, `#expect`. Never XCTest — it forces a heavier idiom and doesn't compose with async as cleanly.

Snapshot tests use `pointfreeco/swift-snapshot-testing` (1.18.9). Baselines live in `__Snapshots__/` alongside the test file. Recording is controlled by the `SNAPSHOT_TESTING_RECORD` env var, wired through the `Snapshots` and `Snapshots-Record` schemes defined in `Workspace.swift`.

- First run auto-records missing baselines (default `record = missing`)
- `make snapshot-test REPLACE=1` re-records every baseline for the selected scheme

## Multi-platform

Project.swift emits `destinations:` and `deploymentTargets:` based on the platforms selected at scaffold time. The template stores platform-varying bits behind the `__PLATFORMS__` token so it can be substituted into ProjectDescription's enum-array syntax (e.g. `.iOS, .macOS, .watchOS`).

Deployment targets for the initial cut: iOS 18.0, macOS 15.0, watchOS 11.0.

## LLM tooling

`.claude/skills/` ships with a seed skill so future Claude sessions in the generated project have context out of the gate. Users can add more skills via `.claude/skills/<name>/SKILL.md`.

`CLAUDE.md` at the root of the generated project documents the build/test workflow, so LLMs entering cold know to prefer `make` over raw `tuist`/`xcodebuild`.

## Placeholder discipline

Only three tokens are allowed in the template: `__APP_NAME__`, `__BUNDLE_ID__`, `__PLATFORMS__`. `make lint-template` enforces this. If you find yourself wanting a fourth token, first ask whether the value can be derived from the existing three.
