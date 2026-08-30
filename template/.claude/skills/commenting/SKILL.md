---
name: commenting
description: Write concise, minimal comments that only capture critical or non-obvious functionality. Use when writing new code or reviewing comments in a diff.
---

Comments cost attention on every future read and silently rot as code changes.
The default is **no comment**. Add one only when a future reader would otherwise
be confused about *why* the code does what it does — never to restate *what* it
does.

## What a comment must be

A comment earns its place only if it captures one of:

- A **non-obvious invariant** the code relies on (e.g. "callers hold the queue
  lock", "input is guaranteed non-empty by the caller").
- A **hidden constraint** imposed from outside the file (e.g. "kernel returns
  EAGAIN here on macOS < 14", "this ordering matches the on-disk format",
  "Tuist's default hardcodes 1.0/1, shadowing the settings").
- A **workaround** for a specific bug in an external system, ideally with a
  link or issue number.
- Behavior that would **surprise a careful reader** — an intentional swap, a
  deliberately non-idiomatic construct, a subtle ordering.
- The **semantic intent** behind a magic number or opaque literal, when the
  name alone can't carry it (e.g. `/// 8 points — spacing within a component`,
  `/// 20 points — spacing between related components`). This is what makes a
  scale readable without opening the values.
- For a test, **why the test exists** — the bug it pins, the invariant it
  guards, or the strategy it embodies. Not what the assertions do.

If deleting the comment wouldn't confuse someone reading the code fresh, delete
it.

## What a comment must never be

- **A restatement of the code.** Well-named symbols already describe *what*.
  `// increment counter` above `counter += 1` is noise.
- **A reference to the task, ticket, PR, or fix that produced this code.**
  ("Added for the onboarding flow", "fixes bug #4213", "part of the auth
  rewrite.") That context belongs in the commit message and the PR
  description — it rots the moment the surrounding code moves.
- **A description of prior state or removed code.** ("Was previously using X",
  "removed the fallback path", "used to be sync".) Git already knows.
- **A pointer to other files or callers.** ("Called from LoginView",
  "matches the shape in UserRepo".) Grep is authoritative; the reference goes
  stale on the next rename.
- **A decorative divider** (`// ============`, banner ASCII art). Never earns
  its place. Also skip `// MARK:` in short files — if the shape is already
  obvious from the code, the divider is noise. `// MARK: - <Name>` is fine
  in files long enough that visual navigation matters (multi-hundred-line
  types, test files with many suites), but it is not license to keep a file
  long: prefer splitting when the sections are actually independent.
- **A `TODO`, `FIXME`, or `HACK`.** Untracked markers accumulate forever, and
  even the tracked ones rot. File an issue and let git blame carry the pointer;
  don't leave the marker behind.

## Format

- One line whenever possible. Two if truly necessary.
- Sentence case, ends with a period only if it's a full sentence.
- Place immediately above the line or block it describes, at the same indent.
- Do not write multi-paragraph docstrings unless the file is a public
  library API and downstream users need generated docs.
- No emoji.

## Doc comments (`///` in Swift)

Doc comments on public API are different from inline comments and are welcome
when they add value beyond the signature:

- Document **contracts** the type name doesn't already convey: preconditions,
  postconditions, side effects, thread-safety, error conditions.
- On a token or scale, name the **intent** each value carries so a reader can
  choose without opening the numbers (`/// 12 points — spacing between related
  components`, `/// The window background.`, `/// Supporting copy, captions,
  and disabled controls.`).
- On a type that models a domain concept, a two-to-three-sentence lead can
  earn its keep by naming the **role and non-obvious rules**: what the type is
  *for*, what invariants it guards, what it is deliberately *not*. Skip this
  when the name already carries the whole story.
- Keep the summary line terse. A single sentence is usually enough; expand only
  when the type's role or contract genuinely needs more.
- Skip them entirely when the name and parameter labels already say
  everything (`func title() -> String`).

## Review checklist

When you're about to add a comment, ask:

1. Does the code already say this via naming? → Rename, don't comment.
2. Is this about *why*, or about *what*? → If *what*, delete.
3. Would this rot if a nearby symbol were renamed? → Rewrite to be
   self-contained, or delete.
4. Is this about the task or history that produced the code? → Move to the
   commit message.
5. Would a careful reader be surprised without it? → Keep it.

When you're reviewing a diff, apply the same checklist to every added
comment. Delete the ones that fail. Leave a note if you're removing a
non-trivial comment so the author can push back.

## Examples

**Keep** — captures a non-obvious invariant:

```swift
// Kept sorted so binary search in `find(_:)` stays valid.
private var entries: [Entry]
```

**Keep** — external workaround with context:

```swift
// URLSession retries 5xx once on iOS 17.4; disable to avoid duplicate POSTs.
config.httpShouldUsePipelining = false
```

**Delete** — restates the code:

```swift
// Loop over users and print their names.
for user in users { print(user.name) }
```

**Delete** — references the task that produced the code:

```swift
// Added as part of the auth v2 rewrite to handle the new token format.
func parseToken(_ raw: String) -> Token? { ... }
```

**Delete** — describes removed code:

```swift
// Previously used a synchronous call here; switched to async.
let user = try await repo.load(id)
```

**Keep** — names the intent behind a magic number so the scale reads without
opening the values:

```swift
/// 16 points — the default screen margin.
public static let lg: CGFloat = 16
```

**Keep** — a test-strategy comment that pins *why* the assertion matters:

```swift
/// SwiftUI resolves a missing colorset silently, so a renamed or deleted
/// entry would only show up as a wrong color at runtime. Every token declares
/// distinct light and dark values, so a color that resolves identically in
/// both appearances did not come from the catalog.
@Test("every color token resolves from the asset catalog")
func colorsResolve() { ... }
```

**Delete** — restates that a group of things is grouped:

```swift
// Shared build settings applied across the workspace. Keeping deployment
// targets and Swift version in one place avoids drift across per-project
// `Project.swift` files.
extension Settings { ... }
```
