# one-shot-ios

An iOS project starter template built for LLM-assisted development.

Generates a Tuist-based iOS project with:

- Modular architecture (`Modules/`) with per-module Playgrounds, unit tests, and snapshot tests
- Makefile as the single source of truth for build/test/lint
- Pinned Xcode + Tuist toolchain, verified by `scripts/setup.sh`
- `swift-testing` + `pointfreeco/swift-snapshot-testing` wired in from day one
- `.claude/skills/` seed so future LLM sessions land with useful context
- Multi-platform support (iOS / macOS / watchOS)

## Quickstart

```sh
git clone <this-repo> one-shot-ios
cd one-shot-ios
make new
```

You'll be prompted for **App name**, **Bundle ID**, **Platforms**, and **Target directory**. The scaffolder copies `template/` to the target directory, substitutes tokens, renames directories, and initializes a git repo.

Then, in the emitted project:

```sh
cd ../<AppName>
make setup      # verify Xcode + Tuist at pinned versions
make project    # tuist install + tuist generate → opens Xcode
make test       # unit + snapshot tests
```

## Non-interactive scaffold

```sh
./bin/scaffold.sh \
  --app-name DemoApp \
  --bundle-id com.example.demo \
  --platforms iOS,macOS \
  --target-dir ../DemoApp
```

## Repo layout

```
one-shot-ios/
├── bin/scaffold.sh     # bash scaffolder (copy + substitute + rename)
├── template/           # project skeleton with __APP_NAME__ / __BUNDLE_ID__ / __PLATFORMS__ tokens
├── docs/               # template conventions + design notes
├── Makefile            # `make new`, `make lint-template`, `make test-scaffold`
├── CLAUDE.md           # LLM-facing overview
└── README.md
```

## Contributing to the template

Edit files under `template/`. Then verify the change end-to-end:

```sh
make lint-template     # grep for stray placeholder tokens
make test-scaffold     # runs the scaffolder into /tmp and checks the result
```
