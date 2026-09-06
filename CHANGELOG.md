# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.3]

### Fixed
- `_layouts/default.html`: pages with `layout-wrapper-full: true` (every blog post, via the `posts` collection default) rendered a Bootstrap `.row` directly inside `.page-body` with no `.container` around it. The row's default negative horizontal margins had no container padding to cancel them out, pushing content past the viewport edge and causing a persistent horizontal scrollbar on every post. Wrapped the row in a `container-xl`, matching the non-full-width branch.

## [0.5.2]

### Fixed
- `_includes/utils/comments.html`: Giscus never actually followed the site's dark/light mode. Its `data-theme` was baked at Jekyll build time from `page.layout-dark`/`site.layout-dark`, which has nothing to do with this theme's actual runtime dark mode (toggled client-side via the settings panel, persisted under the `tabler-theme` localStorage key and the `theme-dark` body class); the widget therefore always rendered with `data-theme="light"`. The existing `postMessage`-based sync for later toggles was also racing the async `giscus.app/client.js` load and silently doing nothing on the very first paint. Fixed by building the `<script>` tag client-side and computing the real theme (checking the `dark`/`theme-dark` classes, then the `tabler-theme`/`theme` localStorage keys, then `prefers-color-scheme`) at the moment the widget is created.

## [0.5.1]

### Fixed
- Giscus comments never rendered on sites whose `lang`/`giscus.lang` used a regional IETF tag (e.g. `pt-BR`) instead of a bare language code: giscus.app 404s on `/pt-BR/widget` (only `/pt/widget` exists), and the resulting error page's own CSP blocks the browser from ever showing it inside the iframe - so the whole widget silently disappeared. Found by actually testing Giscus end-to-end after enabling it on a real site. Added `site.giscus.lang` so a site can pin the exact code giscus expects, independent of its real `lang`.

## [0.5.0]

### Added
- **Blog**: `_layouts/post.html` and a card-based blog listing pattern (see the example site's `pages/blog.html`) - the theme previously had no working blog at all.
- **Local Projects**: the "Local Projects" section of `utils/projects.html` was a static empty placeholder; it now renders real cards from a site's `projects` collection (`name`, `tools`, `image`, `description`, `external_url`), alongside the existing auto-generated GitHub-starred-repos grid.
- **Comments**: optional Giscus (GitHub Discussions) comments on posts, via `_includes/utils/comments.html` and a `giscus:` block in `_config.yml`.
- **i18n**: `_data/i4y-strings.yml` makes every hardcoded UI string (project page headings, empty/error states, search placeholder) overridable by a consuming site.
- **Instant search**: `_includes/utils/search.html`, a dependency-free client-side filter over any card grid - closes the gap with the long-standing "Search Functionality" feature claim in the README, which was never actually implemented.
- Simple tags page pattern (groups posts by `site.tags`).

### Fixed
- `_layouts/error.html` never actually read `_data/i4y-errors.json`: it referenced an undefined `errors` variable, and separately indexed it with an unconverted integer front-matter value against string JSON keys. Error pages always fell back to generic text/icon instead of the configured copy and illustration.
- `_includes/ui/button.html` built internal links with `site.base`, a variable that doesn't exist anywhere in the theme, producing `href="//path"` (a protocol-relative URL pointing at a fake host) for every internal button. Switched to the `relative_url` filter.
- `_sass/bootstrap/scss/vendor/_rfs.scss` was missing from the vendored Bootstrap 5.3.3 copy, so `bundle exec jekyll build` failed on **every** site using this theme with a real Sass compiler. Root cause: `.gitignore` had a bare `vendor/` entry, which ignores a folder named `vendor` at *any* depth, not just the repo root - it was silently dropping this file from every commit. Fixed to `/vendor/`.
- README badge pointed at a non-existent `.github/workflows/gem-build.yml` (the real file is `gem.yml`).
- `spec.description` in the gemspec was `File.read('README.md')`, so the RubyGems.org listing showed raw Markdown/HTML instead of a normal description.
- `example-site/about.markdown` and `pages/blog.html` used `layout: home` / `layout: post`, neither of which existed in the theme - both silently rendered without any layout at all.
- `example-site/pages/404.html` rendered its error illustration twice (once via the layout, once via an extra include in the page body).
- `example-site/_config.yml` set `theme:` and `remote_theme:` at the same time, and used a `github: user:` key that `jekyll-github-metadata` doesn't recognize (the real key is `repository:`).

### Changed
- `spec.files` in the gemspec no longer packages the vendored Bootstrap's JS source or `package.json` - only the `.scss` partials Jekyll actually needs, and the Bootstrap `LICENSE` for compliance. Shrinks the published gem.
- README rewritten to document what the theme actually does today (including the GitHub Pages native-build incompatibility and the GitHub Actions deploy workaround), replacing several `[WIP]` sections and one feature claim ("Search Functionality") that had never been implemented.
- Removed `docs/` - it described a considerably more elaborate, never-implemented version of the projects feature (a separate fetch script, on-disk cache, dedicated local-projects collection). Superseded by the simpler real implementation, now documented in the README.

## [0.4.0]

### Added
- **New UI Components**: Introduced additional UI components in the `_includes/ui` directory.
- **Custom JavaScript**: Added `assets/js/custom.js` for custom JavaScript functionalities.
- **Enhanced Documentation**: Updated `README.md` with detailed instructions and feature descriptions.
- **Gem Metadata**: Enhanced gemspec metadata with additional documentation and support links.

### Changed
- **Theme Configuration**: Updated `_config.yml` in the example site for better theme configuration.
- **Dependencies**: Updated runtime and development dependencies in `insights4you-jekyll-theme.gemspec`.
- **Build Process**: Improved the Makefile for better build and test processes.

### Fixed
- **Bug Fixes**: Resolved minor bugs and improved overall stability.

### Removed
- **Deprecated Files**: Removed any deprecated or unused files to clean up the project structure.

## [0.3.0]

### Added
- **Theme System**: Implemented dark/light theme switching functionality
- **Theme Toggle**: Added theme toggle buttons in header navigation
- **Theme Persistence**: Added localStorage support for saving theme preferences
- **System Theme**: Added automatic system theme preference detection
- **Accessibility**: Added ARIA attributes and screen reader announcements for theme changes
- **Sass Architecture**: Added new _sass directory for better style organization

### Changed
- **Asset Structure**: Reorganized CSS into Sass-based architecture
- **Resource Loading**: Updated stylesheet and script loading in head.html
- **Dependencies**: Updated Tabler Core CSS implementation
- **Example Site**: Updated example pages with new theme support
- **Documentation**: Enhanced configuration documentation
- **Build Process**: Improved asset compilation and organization

### Removed
- **Legacy CSS**: Removed deprecated theme.min.css in favor of Sass structure

### Fixed
- **Resource Loading**: Fixed stylesheet loading order and dependencies
- **Theme Toggle**: Improved theme switching reliability
- **UI Components**: Enhanced component styling for both light and dark themes


## [0.2.3]

### Added
- **Ruby Version Requirement**: Set minimum Ruby version to 3.2.2
- **Security**: Added `rubygems_mfa_required` metadata flag
- **Documentation**: Enhanced metadata with additional documentation URIs

### Changed
- **Dependencies**: Updated Jekyll requirement to >= 4.4.1
- **Gemspec**: Improved file organization and readability
- **Installation**: Enhanced post-install message with quick start guide

### Security
- **Authentication**: Enabled mandatory MFA for RubyGems publishing


## [0.2.2]

### Added

- **Social Media Component**: A new component for integrating social media links.
- **User Profile Component**: A dedicated component for displaying user profile information.

### Changed

- **Notifications**: Resolved issues and improved the functionality of notifications.
- **Gemspec and Versioning**: Updated the gemspec file and version details for better compatibility.
- **Dynamic Menu System**: The menu is now dynamically generated, improving flexibility and maintainability.
- **Component Review**: Conducted a comprehensive review and refinement of all existing components.

### Removed

- **Example Site Test File**: Removed the `example-site/test.html` file as it was no longer needed.


## [0.2.0]

### Added

- **UI Components**: Introduced a set of reusable UI components for consistency across the project.
- **Example Site for Testing**: Implemented an example site to facilitate testing and demonstration of features.
- **Changelog File**: Created the `changelog.md` file to track project updates systematically.

### Changed

- **Layout Adjustments**: Made improvements to the home, default, and error layouts for better usability and design.
- **Gemspec Fixes**: Updated the gemspec file to address development-related issues.

### Removed

- **N/A**: No files or features were removed in this release.


[0.5.3]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.5.2...v0.5.3
[0.5.2]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.2.3...v0.3.0
[0.2.3]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.2.0...v0.2.2
