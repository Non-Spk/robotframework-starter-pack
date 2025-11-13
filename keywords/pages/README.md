# Page object resources

Keep page-level resources here. The template includes a minimal structure:

- `keywords/pages/support/runtime_features.resource` for shared YAML + locale helpers
- `keywords/pages/web/web_suite_features.resource` + `keywords/pages/web/example_features.resource`
- `keywords/pages/api/health_api_features.resource`
- `keywords/pages/mobile/mobile_suite_features.resource`

Add your own page objects (e.g., rename `login_page.resource` to `login_features.resource`) and import `resources/import.resource` within them to inherit all libraries.
