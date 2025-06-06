# Project Data Structures and Metadata Specification

This document outlines the data structures for representing GitHub and local projects within the Insights4YOU Jekyll theme. It also defines the metadata storage format for local projects.

## 1. Common Project Data Structure

These fields are applicable to both GitHub and local projects and form the baseline for project representation.

*   `title`: String
    *   Description: The main title of the project.
    *   Example: "Awesome Project", "My Personal Website"
*   `description`: String
    *   Description: A brief summary of the project.
    *   Example: "A tool to automate daily tasks.", "A portfolio showcasing my work."
*   `type`: String (Enum: 'github', 'local')
    *   Description: Specifies the origin of the project.
    *   Values:
        *   `github`: Project data is sourced from the GitHub API.
        *   `local`: Project data is manually defined in a local file.
*   `url`: String
    *   Description: The primary URL for the project. For GitHub projects, this is typically the repository URL. For local projects, it can be a link to a details page, a live demo, or a source code repository.
    *   Example: "https://github.com/user/repo", "/my-project/details.html"
*   `tags`: Array of Strings (Optional)
    *   Description: A list of keywords or technologies associated with the project.
    *   Example: `["Ruby", "Jekyll", "Web Development"]`
*   `date_display`: String
    *   Description: A human-readable string representing the project's main date. This is derived from specific date fields depending on the project type.
    *   Example: "Last updated on 2023-10-26", "Created on 2024-01-15"
*   `sort_date`: Date
    *   Description: A standardized ISO 8601 date string used for sorting projects chronologically.
    *   Example: "2023-10-26T12:00:00Z"

## 2. GitHub Project Specific Fields

These fields are specific to projects fetched from the GitHub API.

*   `stars`: Number
    *   Description: The number of stars the GitHub repository has.
    *   Example: 150
*   `forks`: Number
    *   Description: The number of forks the GitHub repository has.
    *   Example: 30
*   `language`: String (Primary language)
    *   Description: The primary programming language used in the GitHub repository.
    *   Example: "Ruby", "JavaScript"
*   `github_url`: String
    *   Description: The explicit URL to the GitHub repository. This will often be the same as the common `url` field for GitHub projects.
    *   Example: "https://github.com/user/repo"
*   `pushed_at`: Date (ISO 8601)
    *   Description: The timestamp of the last push to the repository. This field is used to populate `sort_date` and inform `date_display` for GitHub projects.
    *   Example: "2023-10-26T18:30:00Z"

## 3. Local Project Specific Fields

These fields are specific to projects defined manually through local metadata files.

*   `image_path`: String
    *   Description: Relative path to an image representing the project. This path is typically relative to the `assets/images/projects/` directory or a similar configurable base path.
    *   Example: "/assets/images/projects/my-local-project.png"
*   `demo_url`: String (Optional)
    *   Description: A URL to a live demonstration of the local project.
    *   Example: "https://demo.example.com/my-project"
*   `source_code_url`: String (Optional)
    *   Description: A URL to the source code repository if it's different from the main `url` (e.g., if `url` points to a project page).
    *   Example: "https://github.com/user/local-project-source"
*   `created_date`: Date (YYYY-MM-DD)
    *   Description: The creation date of the local project. This field is used to populate `sort_date` and inform `date_display`.
    *   Example: "2024-01-15"
*   `status`: String (Optional)
    *   Description: The current status of the project.
    *   Example: "Completed", "In Progress", "Archived", "Proof of Concept"

## 4. Local Project Metadata Format

Local projects will be defined using Markdown files (`.md`) located in a designated directory (e.g., `_projects/`). Each file will use YAML front matter to store its metadata. The content of the Markdown file after the front matter can be used as a longer description for the project's dedicated page, if applicable.

**Example Front Matter Structure (`_projects/my-local-project.md`):**

```yaml
---
title: "My Awesome Local App"
description: "This is a detailed description of my awesome local application, highlighting its key features and technologies used."
type: "local"
url: "/portfolio/awesome-local-app/" # Could be a link to a page within the Jekyll site
image_path: "/assets/images/projects/awesome-app.jpg"
tags: ["Python", "Flask", "Data Visualization", "API"]
created_date: "2023-11-20" # This will be used for sort_date and date_display
demo_url: "https://my-awesome-app-demo.example.com" # Optional
source_code_url: "https://gitea.example.com/user/awesome-app" # Optional, if not the main URL
status: "Completed" # Optional
# Custom fields can also be added here if needed for specific layouts
custom_highlight: "Featured Project"
---

## Project Overview

This section can contain more detailed Markdown content about the project.
It could include:
- In-depth feature descriptions
- Technical challenges
- Screenshots (using Markdown image syntax)
- Future plans

This content can be rendered on a dedicated page for this project.
```

## 5. Unified Data Structure for Rendering

To simplify the rendering logic in Jekyll templates, data from both GitHub and local projects will be transformed into a consistent structure before being passed to the display components (e.g., project cards, project lists). This unified structure will primarily leverage the common fields, with specific data nested or conditionally accessible.

The goal is to have a set of common `display_*` fields and a way to access type-specific details.

*   `display_title`: String (from `title`)
*   `display_description`: String (from `description`)
*   `display_url`: String (from `url` for local, `github_url` or `url` for GitHub)
*   `display_tags`: Array of Strings (from `tags`)
*   `display_date_text`: String (derived from `date_display`)
*   `sortable_date`: Date (from `sort_date`)
*   `source_type`: String (Enum: 'github', 'local', directly from `type`)
*   `project_type_specific_data`: Object
    *   Description: Contains fields unique to the project type.
    *   Example for GitHub: `{ gh_stars: 100, gh_forks: 15, gh_language: 'Ruby', gh_pushed_at: '2023-10-26T18:30:00Z' }`
    *   Example for Local: `{ local_image_path: '/assets/images/projects/awesome-app.jpg', local_demo_url: '...', local_source_code_url: '...', local_created_date: '2023-11-20', local_status: 'Completed' }`

This unified structure ensures that templates can handle projects from different sources without excessive conditional logic directly within the presentation layer. The transformation logic will be handled in the data processing phase (e.g., in a Jekyll plugin or includes).
