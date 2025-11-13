# robotframework-starter-pack

Starter pack for cross-platform Robot Framework automation. The template already knows how to:

- share keywords between web, mobile, database, and API layers
- load environment/device/browser profiles from YAML
- serve localized copy (EN/TH out of the box) via `data/locales`
- organise suites per platform (`tests/web`, `tests/mobile`, `tests/api`)

## Repository layout

```
├── configs/
│   ├── browsers.yaml          # Playwright/browser profiles
│   ├── devices.yaml           # Appium device + app capabilities
│   └── environments.yaml      # Web/Mobile/API environment metadata
├── data/
│   ├── locales/
│   │   ├── en.yaml            # English test copy
│   │   └── th.yaml            # Thai test copy
│   └── tests.yaml             # Suite-level variables imported as dictionaries
├── keywords/common/           # Reusable keyword libraries
├── resources/import.resource  # Single entry point for libraries + keywords
├── keywords/pages/support/runtime_features.resource  # Shared YAML/locale helpers used by page objects
├── keywords/pages/web/example_features.resource      # Sample page object importing the central resource bundle
├── keywords/pages/web/web_suite_features.resource    # Web test controller (POM-style)
├── keywords/pages/api/health_api_features.resource   # API suite controller (POM-style)
├── keywords/pages/mobile/mobile_suite_features.resource
├── tests/
│   ├── api/health_check.robot     # RequestsLibrary sample
│   ├── mobile/sample_mobile_smoke.robot
│   └── web/sample_web_smoke.robot
└── requirements.txt / pyproject.toml
```

## Prerequisites

- Python >= 3.10
- pip >= 21.x
- Node >= 16.x (required by `robotframework-browser`)
- Appium server + device/emulator when executing the mobile suite

## Installation

```sh
python -m venv .venv
source .venv/bin/activate  # Windows: .\\.venv\\Scripts\\activate
pip install -r requirements.txt
rfbrowser init
```

## Running the sample suites

Each suite imports `resources/import.resource` plus its page-object resources. Variables come from `data/tests.yaml` via the `Variables` setting, so you can access dictionaries such as `${language['th']}` without declaring a `*** Variables ***` table.

```sh
# API health-check hitting https://httpbin.org
robot --outputdir output tests/api/health_check.robot

# Web Browser smoke (driven by configs + data/tests.yaml)
robot --outputdir output tests/web/sample_web_smoke.robot

# Mobile suite reads run flags / device profiles from data/tests.yaml
robot --outputdir output tests/mobile/sample_mobile_smoke.robot

> ℹ️ Flip `mobile_sample_smoke.run_mobile_tests` to `true` inside `data/tests.yaml` once a real device/Appium server is available.
```

> ℹ️ `RUN_MOBILE_TESTS` intentionally skips the Appium flow until you point the profile to a reachable device/emulator and update the APK path.

## Configuration & localization

- `configs/environments.yaml` — central place for base URLs, default locales, and per-platform profiles.
- `configs/browsers.yaml` — named Browser/Playwright profiles (headless mode, emulation devices, viewport, CLI args).
- `configs/devices.yaml` — Appium device capabilities plus logical `apps` definitions.
- `data/locales/en.yaml` / `data/locales/th.yaml` — localized strings resolved through the `Get localized text` keyword. Add more languages by dropping another `<lang>.yaml` file.
- `data/tests.yaml` — suite toggles, env names, session aliases, language keys, etc. Import it with `Variables   ${CURDIR}/../../data/tests.yaml` and read values like `${language['th']}`.

Helper keywords defined in `keywords/pages/support/runtime_features.resource` handle:

- loading YAML safely (`Load yaml file`)
- resolving profiles (`Get browser profile`, `Get device profile`, `Get app profile`)
- runtime locale selection (`Get localized text`)

Suites can switch environments, profiles, and languages by editing `data/tests.yaml` (or overriding individual variables via `--variable` when needed) without modifying the test logic.

## Page-object workflow

- Robot suites stick to `*** Test Cases ***` only; setups, teardowns, and assertions live inside `keywords/pages/**`.
- `tests/api/health_check.robot` calls keywords from `keywords/pages/api/health_api_features.resource`.
- `tests/web/sample_web_smoke.robot` uses `keywords/pages/web/web_suite_features.resource`, which in turn imports `example_features.resource` for element-level flows.
- `tests/mobile/sample_mobile_smoke.robot` relies on `keywords/pages/mobile/mobile_suite_features.resource` for device/app orchestration.
- Add more page objects beside these samples and keep importing `resources/import.resource` so each file shares the same libraries/helpers.

## Next steps

- Duplicate the sample suites and plug in your real pages/apis/apps.
- Extend the YAML files with additional environments (QA/UAT/Prod) and device labs.
- Add project-specific keywords under `keywords/` or page-object style resources under `keywords/pages/`.
- When creating new Robot resource files, import `resources/import.resource` once to reuse the shared libraries/keywords without copy-pasting settings.

Happy testing! 🎯
