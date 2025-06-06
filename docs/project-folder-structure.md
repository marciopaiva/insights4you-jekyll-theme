# Projects Feature: Folder Structure Specification

This document outlines the proposed folder structure for managing project-related data, UI components, and assets within the Insights4YOU Jekyll theme. A clear and consistent structure is essential for maintainability and ease of use.

## 1. Local Projects Collection Folder

*   **Directory:** `_local_projects/`
*   **Location:** Site root (`./_local_projects/`)
*   **Purpose:** This directory will house the Markdown files for local projects. Each `.md` file in this directory will represent a single local project, using YAML front matter for its metadata as defined in `docs/project-data-structures.md`.
*   **Jekyll Collection Configuration:** To enable Jekyll to recognize and process these files as a collection, the following configuration should be added to the site's `_config.yml`:

    ```yaml
    # In _config.yml
    collections:
      local_projects:
        output: true # Set to true if each local project should have its own page.
                     # Set to false if they are only data for a listing page and won't have individual pages.
        permalink: /projects/:name # Example permalink structure if output is true. Adjust as needed.
                                   # :name uses the filename (without extension)
                                   # :slug could be used if a slug is defined in front matter
        # sort_by: created_date # Optional: define a default sort order for the collection
    ```
    *   **Note:** The choice of `output: true` or `output: false` depends on whether individual pages are desired for each local project. If `true`, a layout should be specified in the front matter of each project or as a default in `_config.yml` for the collection.

## 2. GitHub Data File Location

*   **File:** `github_projects.yml` (or `github_projects.json`)
*   **Location:** `_data/` directory (`./_data/github_projects.yml`)
*   **Purpose:** This file will store the array of project data fetched from the GitHub API. Storing it in the `_data` directory makes it globally accessible within Jekyll templates via `site.data.github_projects`.
*   **Format:** YAML is generally preferred for its readability in Jekyll data files, but JSON is also a valid option. The structure of this data will conform to the GitHub project fields defined in `docs/project-data-structures.md`.

## 3. UI Component Includes Folder

*   **Directory:** `_includes/projects/`
*   **Location:** Within the standard `_includes/` directory (`./_includes/projects/`)
*   **Purpose:** This directory will contain reusable HTML snippets (includes) specific to the projects feature. This helps in organizing UI components and keeping the main layout files cleaner.
*   **Examples:**
    *   `_includes/projects/project_card.html`: A component to display a single project (either local or GitHub) in a card format.
    *   `_includes/projects/project_list.html`: A component to iterate over a list of projects and display them.
    *   `_includes/projects/project_filter_ui.html`: Snippets for any filtering or sorting UI elements.

## 4. Assets Folder for Local Projects

*   **Directory:** `assets/images/projects/`
*   **Location:** Within the main `assets/` directory (`./assets/images/projects/`)
*   **Purpose:** This directory will store images (e.g., screenshots, logos, thumbnails) specifically associated with local projects.
*   **Usage:** The `image_path` field in the front matter of local project Markdown files (e.g., `_local_projects/my-project.md`) will typically reference images from this folder. For example: `image_path: /assets/images/projects/my-cool-app.png`.
    *   **Note:** It's crucial to maintain consistency in how these paths are defined and resolved in templates. Using root-relative paths (starting with `/`) is generally recommended.

## Summary of Proposed Structure

```
.
├── _config.yml
├── _data/
│   └── github_projects.yml  # For fetched GitHub project data
├── _includes/
│   └── projects/            # For project-specific UI components
│       ├── project_card.html
│       └── ...
├── _local_projects/         # Collection for local project .md files
│   ├── my-first-local-project.md
│   └── another-local-project.md
├── assets/
│   └── images/
│       └── projects/        # For images used by local projects
│           ├── my-first-local-project-thumb.png
│           └── ...
├── docs/
│   ├── project-data-structures.md
│   └── project-folder-structure.md # This file
└── ... (other site files and folders)
```

This folder structure aims to provide a logical organization for all parts of the "Projects" feature, facilitating development, maintenance, and content management.
