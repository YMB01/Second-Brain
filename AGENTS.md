# Second Brain — Agent Instructions

These rules apply to all work in this repository. Apply the architecture below as features are introduced; do not create placeholder files, folders, or dependencies in advance.

## 1. Feature Architecture

- **Flat Feature Structure ONLY:** Every feature under `lib/features/<feature_name>/` MUST have a completely flat directory structure.
- **NO SUBFOLDERS:** Do not create subdirectories inside a feature folder, including `bloc/`, `data/`, `domain/`, `pages/`, `widgets/`, `models/`, or `repositories/`.
- All feature-related files must live directly in `lib/features/<feature_name>/`. Use the following names when those files are needed:
  - `<feature>_model.dart`
  - `<feature>_repository.dart`
  - `<feature>_bloc.dart`
  - `<feature>_event.dart`
  - `<feature>_state.dart`
  - `<feature>_page.dart`
  - `<feature>_widget.dart`
- Multi-page flows may use descriptive page filenames directly in the same feature folder, such as `habit_detail_page.dart` and `create_habit_page.dart`.
- **Feature Granularity:** Group cohesive multi-step workflows under a single feature folder instead of splitting them into many tiny features. For example, habit creation and habit details may both live directly in `lib/features/habit/`.
- These naming examples do not require introducing a state-management package or creating unused files.

## 2. UI Components & Widgets

- Place feature-specific UI components and sub-widgets in `<feature>_widget.dart`, or consolidate them directly into `<feature>_page.dart`.
- Do not create a `widgets/` folder inside a feature.
- If a widget is needed across more than one feature, promote it to `lib/core/widgets/` to prevent duplication.

## 3. Shared/Core Code

- Shared utilities, theme tokens, global network clients, storage, and cross-cutting concerns must live under `lib/core/`.
- Use these shared directories as needed:
  - `lib/core/theme/`: colors, gradients, typography, and design tokens.
  - `lib/core/widgets/`: reusable UI kit components.
  - `lib/core/network/`: network clients, authentication interceptors, error handling, and failure models.
  - `lib/core/utils/`: validators, date/currency formatters, and string extensions.
  - `lib/core/constants/`: API endpoints, storage keys, and asset constants.
- Shared storage code must also live under `lib/core/`.
- The flat-directory requirement applies to feature folders; shared/core code may use the directories above.

## 4. Scope & Workflow

- Work one small step at a time. Implement only the current user-approved step.
- Do not create screens, navigation, features, or designs unless requested for the current step.
- Install and actively use UI/UX Pro Max before implementing custom UI. Resolve its prerequisites and verify its search script before relying on it.
- Do not install additional packages or skills unless authorized.
- Do not commit or push changes without the user's approval.
