# __APP_NAME__

Bundle ID: `__BUNDLE_ID__`

## Quickstart

```sh
make setup      # verify/install pinned Xcode and Tuist
make project    # tuist install + tuist generate → opens workspace
make test       # unit + snapshot tests
```

## Layout

```
__APP_NAME__/
├── __APP_NAME__/     # app target (SwiftUI @main, views, resources, entitlements)
├── Modules/          # feature frameworks (each with Sources/, Tests/, SnapshotTests/, Playground/)
├── Tuist/            # Tuist package manifest + ProjectDescription helpers
├── scripts/          # setup automation
└── Makefile          # build/test entry points
```

See `CLAUDE.md` for the full workflow. Every commit should keep `make test` green.
