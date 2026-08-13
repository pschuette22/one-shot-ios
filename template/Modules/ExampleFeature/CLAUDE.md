# ExampleFeature — CLAUDE.md

## Overview

`ExampleFeature` is the seed module — a minimal framework demonstrating the
per-module layout every module in this project should follow. Delete or repurpose
it once you have real features.

## Structure

```
ExampleFeature/
├── Project.swift          # framework + Tests + SnapshotTests targets
├── Sources/               # public API namespaced under `enum ExampleFeature`
├── Playground/            # ExampleFeature.playground for isolated experimentation
├── Tests/                 # swift-testing unit tests
└── SnapshotTests/         # UI regression + __Snapshots__/
```

## Build

```sh
make project                        # regenerate workspace after Project.swift changes
make build TARGET=ExampleFeature    # build just this framework
make unit-test FILTER=ExampleFeatureTests
```

## Conventions

- Public API only — every type intended for consumption from other modules must
  be marked `public`. The `ExampleFeature` enum acts as the root namespace.
- No app-level dependencies. Frameworks must remain consumable by any module or
  test target without importing the app.
- Add a snapshot test for every new SwiftUI view; the first `make snapshot-test`
  run auto-records the missing baseline.
