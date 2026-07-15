# ProductListingApp

iOS application built with a modular SPM architecture (AppUI + AppCore) and MVVM pattern.

## Project Structure

```
ProductListingApp/
├── .claude/
│   ├── rules/                    # Coding and architecture rules
│   │   ├── accessibility-identifiers.md
│   │   ├── api-integration.md
│   │   ├── app-architecture.md
│   │   ├── coding-rules.md
│   │   └── test-cases.md
│   ├── skills/                   # Reusable implementation skills
│   │   ├── api-integration.md
│   │   ├── create-reusable-ui.md
│   │   └── test-cases.md
│   └── workflows/                # End-to-end workflows
│       └── feature-integration.md
├── requirements/                  # Feature requirement files
├── ProductListingApp/             # Xcode project
│   ├── AppUI/                     # SPM: Reusable UI components
│   ├── AppCore/                   # SPM: Network, models, services
│   ├── ProductListingApp/         # Main app target
│   ├── ProductListingAppTests/    # ViewModel tests
│   └── ProductListingAppUITests/  # UI automation tests
```

## How to Implement a Feature

### 1. Write the Requirement
Create a text file in the `requirements/` folder describing the feature. Include:
- Feature name and description.
- API endpoint details (URL, method, request/response format).
- UI layout and behavior.
- User interactions.
- Edge cases and error handling.

Example: `requirements/product-list.txt`

### 2. Run the Workflow
Ask Claude to implement the feature using the workflow:

```
Read the requirement file at requirements/product-list.txt.
Use the feature-integration workflow from .claude/workflows/feature-integration.md
with the rules from .claude/rules/ and skills from .claude/skills/ to implement it.
```

### 3. What Happens
The workflow executes these steps in order:
1. **Reads requirements** and creates a checklist.
2. **Implements API layer** (AppCore) — endpoint, models, service, mock, tests, sample response.
3. **Implements ViewModel** (Main App) — state management, DI, business logic.
4. **Writes ViewModel tests** — AAA pattern, 100% coverage.
5. **Creates UI components** (AppUI) — stateless, reusable, parameterized.
6. **Composes screens** (Main App) — binds ViewModel to AppUI components.
7. **Adds accessibility identifiers** — cross-platform naming for automation.
8. **Checks Definition of Done** — verifies every requirement is met.

### 4. Manual Triggering
Rules, skills, and workflows are **not triggered automatically**. They are only used when you explicitly ask Claude to use them. For regular prompts (questions, quick fixes, etc.), Claude responds normally without referencing these files.

## Modules

### AppUI (Swift Package)
Dumb, reusable UI components. No business logic. Interacts only via parameters and callbacks. No dependency on AppCore.

### AppCore (Swift Package)
Network layer, API clients, models, services. Uses async/await. No dependency on AppUI. Includes tests with mock responses.

### Main App
Composes AppUI and AppCore. Contains ViewModels (MVVM), navigation, and app lifecycle. Uses dependency injection throughout.

## Testing
- **AppCore tests**: Service and network tests with mock API client.
- **Main App tests**: ViewModel tests with mock services.
- **Pattern**: AAA (Arrange-Act-Assert) for all tests.
- **Coverage target**: 100%.

Run tests:
```bash
# AppCore module tests
xcodebuild test -scheme AppCore -destination 'platform=iOS Simulator,name=iPhone 16'

# Main app + ViewModel tests
xcodebuild test -scheme ProductListingApp -destination 'platform=iOS Simulator,name=iPhone 16'
```
