# CLAUDE.md

## Project Overview
ProductListingApp — modular iOS app using SPM (AppUI + AppCore) with MVVM architecture.

## Rules, Skills, and Workflows
Located in `.claude/rules/`, `.claude/skills/`, and `.claude/workflows/`.
**These are triggered manually only** — do not read or apply them unless the user explicitly asks.

## Key Conventions
- async/await for all network calls
- Dependency injection via protocols
- AAA pattern for all tests
- 100% code coverage target
- Alphabetical ordering for enum cases and struct properties
- `// MARK: -` for code organization
- Cross-platform accessibility identifiers via `AccessibilityID` enum
- SwiftData for local caching
- No dependency between AppUI and AppCore modules

## Requirements
Feature requirements are placed as text files in the `requirements/` folder.
