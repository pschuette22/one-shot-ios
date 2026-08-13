# .claude/skills

Drop-in directory for Claude Code skills that should be available to any LLM
session working in this project.

`skills-lock.json` at the project root is the source of truth for what's
recommended and where each skill comes from. Skills are opt-in: install only
what your project actually needs.

## Vendored (ship with the template)

| Skill               | Purpose                                                       |
| ------------------- | ------------------------------------------------------------- |
| `upgrade-deps`      | Loosen SPM pins, resolve, re-pin, repair build/test breakage. |
| `commenting`        | Concise, minimal comments — only *why* / non-obvious things.  |
| `docc`              | High-quality DocC (`///`) on every new or modified public symbol. |

## Recommended external skills

| Skill               | Source                                               | Purpose                                            |
| ------------------- | ---------------------------------------------------- | -------------------------------------------------- |
| `swiftui-pro`       | [twostraws/SwiftUI-Agent-Skill][swiftui-pro]         | SwiftUI review — deprecated APIs, performance, HIG |

## Swift iOS skill collection

[dpearson2699/swift-ios-skills][swift-ios-skills] is a curated set of 86 skills
covering the modern iOS surface area. `skills-lock.json → collections →
swift-ios-skills` lists every skill grouped by category:

- **SwiftUI** (10) — animation, gestures, layout, navigation, liquid glass, WebKit interop, etc.
- **Core Swift** (10) — concurrency, Codable, Testing, SwiftData, Core Data, Charts
- **App Experience** (15) — WidgetKit, App Intents, ActivityKit, StoreKit, PhotoKit, MapKit, CarPlay, TipKit
- **Data & Services** (8) — CloudKit, HealthKit, WeatherKit, EventKit, MusicKit, PassKit
- **AI & ML** (5) — Foundation Models, Core ML, Vision, Speech, Natural Language
- **iOS Engineering** (16) — accessibility, auth, background tasks, CryptoKit, debugging, localization, networking, security, SwiftLint, simulator tooling
- **Hardware** (8) — Core Bluetooth, Core NFC, Core Motion, PencilKit, RealityKit, SensorKit
- **Platform Integration** (10) — CallKit, HomeKit, SharePlay, permission/energy/audio kits
- **Gaming** (4) — GameKit, SceneKit, SpriteKit, TabletopKit

Only install the ones relevant to what the app actually does — an app with no
health features has no business shipping the HealthKit skill.

## Installing a skill

```sh
# From swift-ios-skills:
curl -L https://github.com/dpearson2699/swift-ios-skills/archive/refs/heads/main.tar.gz \
  | tar -xz --strip-components=2 -C .claude/skills/ swift-ios-skills-main/skills/<name>

# Or clone + copy the tree:
git clone --depth 1 https://github.com/dpearson2699/swift-ios-skills /tmp/swift-ios-skills
cp -R /tmp/swift-ios-skills/skills/<name> .claude/skills/<name>
```

Then commit the vendored skill directory. If the upstream skill later changes,
re-vendor from the same source pinned in `skills-lock.json`.

## Adding a new skill

1. Create `.claude/skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`,
   `description`) and a body that describes when Claude should activate it.
2. Add reference material under `.claude/skills/<skill-name>/references/` if
   the skill needs long-form context beyond `SKILL.md`.
3. Register the skill in `skills-lock.json` — either as a top-level `skills`
   entry (single skill) or under `collections` (a curated set from one source).

[swiftui-pro]: https://github.com/twostraws/SwiftUI-Agent-Skill
[swift-ios-skills]: https://github.com/dpearson2699/swift-ios-skills
