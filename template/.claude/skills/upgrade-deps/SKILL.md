---
name: upgrade-deps
description: Upgrade pinned Swift package dependencies to their latest versions and repair any build/test breakage from new APIs. Use when the user asks to bump, refresh, or upgrade dependencies.
---

Upgrade every pinned Swift package dependency in this project to the latest
version compatible with the current major, resolve the graph, re-pin exactly,
and repair any resulting build/test breakage.

## Where dependencies live

- `Tuist/Package.swift` — the source of truth for SPM dependency declarations.
- `Tuist/Package.resolved` — generated; captures resolved versions after `tuist install`.
- Do **not** touch `.tuist-version` or `.xcode-version`. Those are toolchain
  pins, not application dependencies, and are outside this skill's scope.

## Steps

### 1. Unpin every dependency

Rewrite each `.package(...)` entry in `Tuist/Package.swift` so its version
requirement becomes "at least this version, up to the next major" — SPM's
closest form of `>=`. Use whatever version was pinned as the floor.

Transformations:

- `.package(url: URL, exact: "X.Y.Z")` → `.package(url: URL, from: "X.Y.Z")`
- `.package(url: URL, .upToNextMinor(from: "X.Y.Z"))` → `.package(url: URL, from: "X.Y.Z")`
- `.package(url: URL, .exact("X.Y.Z"))` → `.package(url: URL, from: "X.Y.Z")`
- Leave `.package(url:, branch:)`, `.package(url:, revision:)`, and
  `.package(path:)` entries alone — they aren't version-pinned.

If a dependency was pinned for a documented reason (a comment on the line, or
a note elsewhere), stop and surface that to the user before loosening it.

### 2. Resolve

Run:

```sh
make install-deps
```

This invokes `tuist install`, which resolves SPM against the loosened
requirements and rewrites `Tuist/Package.resolved` with the newly selected
versions.

If resolution fails, report the conflict and stop — do not force an override
without user direction.

### 3. Re-pin to the resolved versions

Read every `pins[].state.version` out of `Tuist/Package.resolved` and rewrite
each corresponding entry in `Tuist/Package.swift` back to `exact:` at the
resolved version:

```swift
.package(url: URL, exact: "<resolved>")
```

Match `Package.resolved` pins to `Package.swift` entries by repository
identity — the pin's `identity` field maps to the last URL path component
(lowercased) of the `.package(url:)` entry.

### 4. Rebuild and repair

Run:

```sh
make project
make build
make test
```

For each failure, read the error, identify the API change in the upgraded
dependency, and update project code accordingly. Common upgrade breakage:

- **Renamed or removed symbols** — check the dependency's CHANGELOG / release
  notes on GitHub for the version range you jumped.
- **Signature changes** — arguments added, reordered, or made async.
- **Deprecation warnings promoted to errors** in strict-concurrency mode.
- **Snapshot test drift** — if UI snapshots fail purely because a dependency
  changed rendering, re-record with `make snapshot-test REPLACE=1` and diff
  the PNGs by eye before accepting.

Do not silence warnings or wrap failures in `try?` to make errors disappear.
Fix them at the call site.

### 5. Report

Summarize for the user:

- Which packages moved, from → to.
- Which files you edited to accommodate API changes.
- Which snapshot baselines (if any) were re-recorded and why.
- Anything that didn't upgrade (and why).
