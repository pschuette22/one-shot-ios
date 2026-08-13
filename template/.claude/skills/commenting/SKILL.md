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
  EAGAIN here on macOS < 14", "this ordering matches the on-disk format").
- A **workaround** for a specific bug in an external system, ideally with a
  link or issue number.
- Behavior that would **surprise a careful reader** — an intentional swap, a
  deliberately non-idiomatic construct, a subtle ordering.

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
- **A section header or decorative divider.** (`// MARK: - helpers`,
  `// ============`.) Structure the file so the shape is obvious from the code.
- **A `TODO` or `FIXME` without a name and issue link.** Untracked TODOs
  accumulate forever. Prefer filing an issue.

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
- Keep them terse. A single-sentence summary is usually enough.
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
