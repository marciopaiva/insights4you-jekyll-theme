# Consolidated Jekyll Data Strategy for Projects

## 1. Introduction

This document summarizes and formalizes the data management strategy for the "Projects" feature within the Insights4YOU Jekyll theme. It consolidates decisions made in previous planning documents regarding how data for both local and GitHub-hosted projects will be stored, accessed, and processed by Jekyll.

The aim is to leverage Jekyll's built-in mechanisms (Collections and Data Files) as much as possible, complemented by a simple external script for fetching remote data.

## 2. Local Projects Strategy

Local projects (those manually documented and maintained within the theme or site itself) will be managed using a Jekyll Collection.

*   **Collection Name:** `local_projects`
*   **Directory:** `_local_projects/`
    *   Each file in this directory represents a single local project.
*   **Format:** Markdown files (`.md`) with YAML front matter. The front matter will contain the metadata for the project, adhering to the structure defined in `docs/project-data-structures.md`. The Markdown content of the file can serve as the detailed description or dedicated page content for the project.
*   **Configuration (`_config.yml`):**
    The collection will be defined in the site's `_config.yml` as follows (example):
    ```yaml
    collections:
      local_projects:
        output: true # Or false, depending on whether individual pages are needed
        permalink: /projects/:name # Example if output is true
        # sort_by: created_date # Optional default sort
    ```
    The `output` and `permalink` settings will be determined by whether each local project should have its own standalone page.
*   **Availability in Liquid:** Once configured, local projects will be accessible in Liquid templates via the `site.local_projects` array.
*   **References:**
    *   `docs/project-folder-structure.md` (for folder location)
    *   `docs/project-data-structures.md` (for metadata structure)

## 3. GitHub Projects Strategy

Projects hosted on GitHub will have their data fetched from the GitHub API and made available to Jekyll as a Data File.

*   **Data File:** `_data/github_projects.yml` (or potentially `.json`)
    *   This file will contain an array of GitHub project objects, structured according to the definitions in `docs/project-data-structures.md`.
*   **Generation and Management:**
    *   The content of `_data/github_projects.yml` is generated and managed by an external Ruby script: `_scripts/fetch_github_projects.rb`.
    *   This script handles:
        *   Interacting with the GitHub API (authentication, fetching repository data).
        *   Transforming the API response into the required data structure.
        *   Implementing a caching strategy to minimize API calls and improve build performance (writing a `last_fetched_at` timestamp and respecting cache duration or forced refresh).
*   **Availability in Liquid:** GitHub project data will be accessible in Liquid templates via `site.data.github_projects` (assuming the YAML file contains a top-level key `projects: [...]` or the script outputs the array directly if the file is named `github_projects.yml`). If the script structures the YAML as `last_fetched_at: ... projects: [...]`, then access would be `site.data.github_projects.projects`.
*   **References:**
    *   `docs/project-folder-structure.md` (for file location)
    *   `docs/github-api-integration.md` (for API interaction plan)
    *   `docs/api-caching-strategy.md` (for caching logic)
    *   `docs/project-data-structures.md` (for data structure)

## 4. Data Unification for Presentation

To ensure consistent display, data from both local and GitHub projects will be merged and transformed into a unified structure before rendering.

*   **Process:** As detailed in `docs/presentation-layer-design.md`, the Jekyll page responsible for displaying the projects (e.g., `projects.html`) will:
    1.  Access `site.local_projects` and `site.data.github_projects`.
    2.  Map each project item from both sources to a **Unified Data Structure for Rendering**.
    3.  Combine these into a single list (`all_projects`).
    4.  This `all_projects` list is then used for display, filtering, and sorting, typically by passing individual items to a shared include like `_includes/projects/project_card.html`.
*   **Reference:**
    *   `docs/presentation-layer-design.md`

## 5. Reliance on Standard Jekyll Features

This data strategy primarily relies on core, standard Jekyll functionalities:

*   **Jekyll Collections:** For managing structured content like local projects.
*   **Jekyll Data Files:** For making external or pre-processed data available to the site.
*   **Liquid Templating:** For accessing and rendering the data, as well as implementing filtering and sorting logic.

An external Ruby script (`_scripts/fetch_github_projects.rb`) is used for the specific task of fetching and caching data from the GitHub API. This script is run as a preliminary step before `jekyll build`, not as a Jekyll plugin that hooks into the build process itself.

**Future Enhancements (Out of Initial Scope):**
While the initial implementation will rely heavily on Liquid for data manipulation on the presentation pages:
*   If Liquid's capabilities for data transformation or complex filtering/sorting become too cumbersome or inefficient, custom Jekyll plugins (e.g., new Liquid filters or tags written in Ruby) could be developed as a future enhancement.
*   For now, the design prioritizes using built-in features with an auxiliary script for external data fetching.

This consolidated strategy provides a clear path for managing project data within the Jekyll ecosystem for the Insights4YOU theme.
