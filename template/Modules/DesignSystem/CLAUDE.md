# DesignSystem — CLAUDE.md

## Overview

`DesignSystem` is the shared visual language: color, typography, spacing, and
the components built on them. It depends on nothing but SwiftUI, so any feature
module can consume it.

`DesignSystemCatalog` is a companion **app** target that renders every token
and component. It ships with the module rather than the app so the design
system stays runnable — and reviewable — on its own.

The seed set is deliberately minimal: enough to demonstrate the pattern,
nothing more. Extend it as real product needs land.

## Structure

```
DesignSystem/
├── Project.swift          # framework + Catalog app + Tests + SnapshotTests
├── Sources/
│   ├── Tokens/            # Color.*, DesignSystem.Spacing, DesignSystem.Radius
│   ├── Styles/            # TextStyle and its modifier
│   └── Components/        # Card
├── Resources/             # DesignSystemAssets.xcassets — the color source of truth
├── Catalog/Sources/       # the DesignSystemCatalog app
├── Playground/            # DesignSystem.playground
├── Tests/                 # swift-testing unit tests
└── SnapshotTests/         # UI regression + __Snapshots__/
```

## Build & run

```sh
make project                          # regenerate after Project.swift changes
make build TARGET=DesignSystem
make build TARGET=DesignSystemCatalog
make unit-test FILTER=DesignSystemTests
make snapshot-test FILTER=DesignSystemSnapshotTests
```

Run the catalog by selecting the `DesignSystemCatalog` scheme in Xcode. It is
the fastest way to see a token change across every surface at once.

## Tokens

Colors live in `Resources/DesignSystemAssets.xcassets` — **the catalog is the
source of truth**, not Swift literals. Tuist synthesizes `DesignSystemAsset`
from it at `make project` time; the `Color.*` extensions only give those
generated symbols a semantic name.

| Namespace | Seed contents |
| --------- | ------------- |
| `Color.Surface` | `primary` (window background), `secondary` (grouped/card background) |
| `Color.Text` | `primary` (headlines and body copy), `secondary` (supporting copy) |
| `Color.Brand` | `primary` (the accent) |
| `DesignSystem.Spacing` | 4-point scale, `xxs` (2) through `xxl` (32) |
| `DesignSystem.Radius` | `sm` (6), `md` (12), `lg` (20) |

**Every colorset declares both a light and a dark value.** `TokenTests` asserts
each token resolves differently under the two appearances, which is what makes
a missing or single-appearance colorset fail loudly — SwiftUI otherwise falls
back silently.

To add a color: add the colorset (both appearances), run `make project`, expose
it on the matching `Color` extension, and add it to `TokenTests.allTokens` and
the catalog's color page.

## Typography

`TextStyle` is a value type bundling size, Dynamic Type anchor, weight, design,
and enabled/disabled colors. Apply it with `.textStyle(_:color:)` rather than
setting `.font` and `.foregroundStyle` separately — the modifier is what wires
up `@ScaledMetric` and the disabled color.

There are **no custom font files** — the system faces already carry the full
Dynamic Type range. The seed scale ships four presets (`titleLarge`,
`titleSmall`, `body`, `caption`); add more as the product needs them.

## Conventions

- **Public API only.** Anything consumed from another module must be `public`,
  and every public symbol carries DocC.
- **No app-level dependencies.** The framework must stay consumable by any
  module without importing app wiring.
- **Every component gets a snapshot test and a catalog entry.** Re-record with
  `make snapshot-test REPLACE=1` and review the images before committing.
