---
name: docc
description: Write and maintain concise, high-quality DocC symbol documentation. Use when adding or modifying any public API — public types, functions, properties, initializers, protocols, or enum cases.
---

Every new or modified public symbol must ship with DocC documentation. This
includes anything declared `public` or `open`, and anything exposed through a
public protocol conformance. Internal, `fileprivate`, and `private` symbols
are covered by the sibling [`commenting`](../commenting/SKILL.md) skill and
default to *no* documentation.

The bar is **concise**. A great doc comment is one sentence when it can be —
the summary sentence is what shows in Quick Help, symbol completion, and
DocC's symbol index, so it does the most work per character.

## When this skill applies

- Adding a new `public`/`open` symbol → write DocC.
- Changing the signature, semantics, thrown errors, or return contract of an
  existing public symbol → update the DocC.
- Renaming a public symbol → update every DocC reference to it (see
  [Symbol links](#symbol-links)).
- Removing a public symbol → remove references from other DocC comments.
- Reviewing a diff → verify every new/changed public symbol has correct DocC.

## Structure

Always in this order. Skip a section entirely if it doesn't apply — don't
include empty stubs.

1. **Summary** — one sentence. Required.
2. **Discussion** — paragraphs explaining behavior, invariants, or context.
   Optional; omit if the summary is sufficient.
3. **`- Parameters:`** — one entry per parameter. Omit for zero-arg functions.
4. **`- Returns:`** — the return value's meaning. Omit for `Void`.
5. **`- Throws:`** — which errors and when. Omit if the function doesn't throw.

```swift
/// Encrypts a message with the given symmetric key.
///
/// The output is a self-contained sealed box that includes the nonce and
/// authentication tag. Reuse of a `(key, nonce)` pair breaks confidentiality;
/// this function derives a fresh nonce on each call.
///
/// - Parameters:
///   - message: The plaintext to encrypt. Must be non-empty.
///   - key: The symmetric key. Rotate at least monthly.
/// - Returns: A sealed box safe to transmit over an untrusted channel.
/// - Throws: ``CryptoError/invalidKeySize`` if `key` is not 32 bytes.
public func seal(_ message: Data, with key: SymmetricKey) throws -> SealedBox
```

## Summary rules

- **One sentence, ends with a period.**
- **Starts with a verb** for functions, initializers, and methods
  (`Encrypts`, `Returns`, `Creates`, `Fetches`).
- **Starts with a noun phrase** for types, properties, and cases
  (`A cache of decoded images.`, `The number of pending requests.`).
- **Third-person present tense.** `Returns the …`, not `Return the …` and not
  `This method will return …`.
- **Do not restate the symbol name.** For `func decode()`, write `Decodes the
  payload …`, not `The decode function decodes …`.
- **Avoid filler.** No `This function`, `Simply`, `Basically`, `just`.
- **No marketing language.** No `great`, `powerful`, `easy`, `robust`.

## Parameters, Returns, Throws

- **Parameter names match the signature exactly.** If the argument label is
  `_` use the internal parameter name.
- **Describe meaning, not type.** Types are visible in the signature; the
  doc adds constraints, units, or invariants: `The timeout in seconds. Must
  be positive.`
- **Document every parameter or none.** Don't half-fill the list.
- **`- Returns:`** describes what the value means, not that a value is
  returned. `The decoded user, or nil if the payload was empty.`
- **`- Throws:`** names specific error cases with the condition:
  `- Throws: ``DecodingError/keyNotFound`` if the payload is missing "id".`

## Symbol links

Reference other symbols with double backticks and DocC path syntax. Links
are resolved at build time and turn into navigable references in generated
documentation.

| Target                          | Syntax                                    |
| ------------------------------- | ----------------------------------------- |
| A top-level type                | `` ``UserCache`` ``                       |
| A member of a type              | `` ``UserCache/insert(_:)`` ``            |
| An instance property            | `` ``UserCache/count`` ``                 |
| An enum case                    | `` ``CryptoError/invalidKeySize`` ``      |
| An initializer                  | `` ``UserCache/init(capacity:)`` ``       |
| A specific overload             | `` ``sum(_:)-3ki6d`` `` (Xcode fills the hash) |

Use symbol links instead of plain-text names anywhere a symbol is mentioned.
Broken links will fail the DocC build.

## Code samples

Fence with triple backticks and the `swift` identifier. Samples must compile
against the API being documented — a broken sample is worse than none.

```swift
/// A rate limiter that permits `n` events per rolling window.
///
/// ```swift
/// let limiter = RateLimiter(events: 10, per: .seconds(60))
/// if await limiter.tryAcquire() {
///     await sendRequest()
/// }
/// ```
public actor RateLimiter { … }
```

Keep samples short — one realistic use case, not a tutorial.

## Callouts

Use sparingly. A callout on every symbol trains readers to ignore them.

| Callout          | When                                                     |
| ---------------- | -------------------------------------------------------- |
| `- Note:`        | Auxiliary info a reader might otherwise miss.            |
| `- Important:`   | Correctness-critical detail; skipping it causes bugs.    |
| `- Warning:`     | Misuse causes data loss, corruption, or a crash.         |
| `- Tip:`         | Optional but recommended usage pattern.                  |
| `- Experiment:`  | Suggestion for the reader to try something interactively. Rare outside tutorials. |

```swift
/// Persists the change set to disk.
///
/// - Important: Call from the actor's isolated context. Cross-actor callers
///   must `await` first, or writes may interleave and corrupt the log.
public func flush() async throws
```

## Discussion

The discussion is where invariants, threading model, complexity, and
side-effects go. Keep it factual and short — one to three short paragraphs.
Blank lines separate paragraphs.

Include a discussion when any of these are true:

- The symbol has non-obvious preconditions or postconditions.
- Complexity, allocation, or I/O behavior matters to callers.
- There's more than one correct usage pattern and choosing wrong is a
  common mistake.
- Threading, actor isolation, or cancellation behavior isn't obvious from
  the signature.

Skip it when the summary + parameters already say everything.

## What not to write

- **Don't restate the type.** Skip `A String that holds the user's name.`
  when the property is already `let name: String`.
- **Don't reference the task, PR, or ticket that created the symbol.** That
  belongs in the commit message.
- **Don't describe the implementation.** DocC is a *contract* for callers,
  not a code walkthrough. `Uses a dictionary internally to cache lookups.`
  is an implementation detail — either drop it or convert to an invariant
  the caller can rely on (`O(1) average lookup.`).
- **Don't document `Void`.** Omit `- Returns:` for `-> Void` / no return.
- **Don't nest DocC inside DocC.** No `/// See MyThing for more.` — use a
  symbol link.
- **Don't emit emoji or ASCII art.**
- **Don't leave TODOs in shipped DocC.** File an issue instead.

## Maintaining existing docs

When you change a public symbol:

1. Update the summary if the *purpose* changed.
2. Update `- Parameters:` if names, types, or contracts changed.
3. Update `- Throws:` if the error set changed.
4. Grep for symbol links to the renamed/removed symbol and fix them.
5. If the discussion mentions specific behavior you changed, update or
   remove that paragraph — stale discussion is worse than none.

When you delete a public symbol, grep for DocC references and clean them
up in the same commit.

## Review checklist

Before finalizing:

- [ ] Every new or modified `public`/`open` symbol has DocC.
- [ ] Summary is one sentence, third-person present, no filler.
- [ ] Parameter names match the signature exactly.
- [ ] `- Returns:` present iff the function returns a non-`Void` value.
- [ ] `- Throws:` present iff the function is `throws` / `rethrows`.
- [ ] Every mentioned symbol uses `` ``…`` `` link syntax.
- [ ] Code samples compile against the current API.
- [ ] No task/ticket/PR references, no implementation details, no filler.
