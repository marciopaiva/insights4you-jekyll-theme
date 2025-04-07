# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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


[0.4.0]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.2.3...v0.3.0
[0.2.3]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/marciopaiva/insights4you-jekyll-theme/compare/v0.2.0...v0.2.2
