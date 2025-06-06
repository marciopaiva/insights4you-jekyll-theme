# Unified Presentation Layer for Projects

## 1. Introduction

This document outlines the design for a unified presentation layer to display both local and GitHub projects consistently within the Insights4YOU Jekyll theme. The primary goal is to create a reusable UI component (a "project card") that can adapt to different project types by leveraging a common, unified data structure.

This approach ensures:
*   **Consistency:** All projects share a similar look and feel.
*   **Maintainability:** Changes to project display logic are centralized.
*   **Extensibility:** New project sources could be integrated with minimal changes to the presentation layer, provided they can be mapped to the unified data structure.

## 2. Data Unification Point

The page responsible for listing or displaying projects (e.g., a dedicated `projects.html` page, or a section within `index.html` or other pages) will be the point where data from different sources is unified.

The process will be as follows:

1.  **Fetch Raw Data:**
    *   Access local projects: `site.local_projects` (from the `_local_projects` collection).
    *   Access GitHub projects: `site.data.github_projects` (from `_data/github_projects.yml`).
2.  **Transform to Unified Structure:**
    *   Iterate through each local project and map its front matter and content to the **Unified Data Structure for Rendering** (defined in `docs/project-data-structures.md`).
    *   Iterate through each GitHub project from the data file and map its fields to the same unified structure.
3.  **Combine and Sort:**
    *   Concatenate the two lists of transformed project objects into a single array.
    *   Sort this combined array based on the `sortable_date` field (e.g., most recent first) to ensure a consistent chronological display if desired. Other sorting criteria could also be applied.

## 3. Unified Data Structure for the Include

The `_includes/projects/project_card.html` (or similar include) will expect each `project` object passed to it to conform to the following unified structure (refer to `docs/project-data-structures.md` for full details):

*   `display_title`: String
*   `display_description`: String
*   `display_url`: String (Primary link for the project)
*   `display_tags`: Array of Strings (Optional)
*   `display_date_text`: String (e.g., "Updated on Jan 5, 2024", "Created on Mar 10, 2023")
*   `sortable_date`: Date (ISO 8601 string, for sorting prior to include usage)
*   `source_type`: String (Enum: 'github', 'local')
*   `project_type_specific_data`: Object (Contains type-specific fields)
    *   For `github`: `gh_stars`, `gh_forks`, `gh_language`, `gh_pushed_at`
    *   For `local`: `local_image_path`, `local_demo_url`, `local_source_code_url`, `local_created_date`, `local_status`

## 4. Jekyll Include Design (`_includes/projects/project_card.html`)

*   **Path:** `_includes/projects/project_card.html`
*   **Purpose:** To render a single project item in a card-like format. This include will be called iteratively for each project in the unified list.
*   **Input:** A single variable, `project`, which is an object conforming to the Unified Data Structure described above. The include will be called like: `{% include projects/project_card.html project=my_unified_project_object %}`.

*   **Conceptual HTML Structure & Logic:**

    ```html+liquid
    {% comment %} _includes/projects/project_card.html {% endcomment %}
    <div class="project-card">
      <h3 class="project-card-title">
        <a href="{{ project.display_url | relative_url }}" {% if project.source_type == 'github' %}target="_blank" rel="noopener noreferrer"{% endif %}>
          {{ project.display_title }}
        </a>
      </h3>
      <p class="project-card-date">{{ project.display_date_text }}</p>
      <p class="project-card-description">{{ project.display_description | markdownify | truncatewords: 30 }}</p>

      {% if project.display_tags and project.display_tags.size > 0 %}
        <div class="project-card-tags">
          Tags:
          {% for tag in project.display_tags %}
            <span class="tag">{{ tag }}</span>
          {% endfor %}
        </div>
      {% endif %}

      {% comment %} Type-specific information {% endcomment %}
      <div class="project-card-specifics">
        {% if project.source_type == 'github' %}
          <span class="project-card-language">{{ project.project_type_specific_data.gh_language }}</span>
          <span class="project-card-stars">Stars: {{ project.project_type_specific_data.gh_stars }}</span>
          <span class="project-card-forks">Forks: {{ project.project_type_specific_data.gh_forks }}</span>
        {% elsif project.source_type == 'local' %}
          {% if project.project_type_specific_data.local_image_path %}
            <img src="{{ project.project_type_specific_data.local_image_path | relative_url }}" alt="{{ project.display_title }} thumbnail" class="project-card-image">
          {% endif %}
          {% if project.project_type_specific_data.local_status %}
            <span class="project-card-status">Status: {{ project.project_type_specific_data.local_status }}</span>
          {% endif %}
          {% if project.project_type_specific_data.local_demo_url %}
            <a href="{{ project.project_type_specific_data.local_demo_url }}" class="project-card-demo-link" target="_blank" rel="noopener noreferrer">View Demo</a>
          {% endif %}
        {% endif %}
      </div>

      <a href="{{ project.display_url | relative_url }}" class="project-card-readmore" {% if project.source_type == 'github' %}target="_blank" rel="noopener noreferrer"{% endif %}>
        Learn More
      </a>
    </div>
    ```

*   **Notes on Logic:**
    *   The `| relative_url` filter should be used for URLs that are internal to the site (e.g., local project pages, local images) to ensure they work correctly with `site.baseurl`. External URLs (like GitHub links, demo URLs) should not use this filter. The `display_url` for GitHub projects will be an absolute URL.
    *   Conditional blocks (`{% if project.source_type == '...' %}`) are used to render elements specific to GitHub or local projects.
    *   Accessing nested data: `project.project_type_specific_data.gh_stars`.

## 5. Styling

*   Styling for the project cards (e.g., `.project-card`, `.project-card-title`, etc.) will be required.
*   This could be placed in a new SASS partial, such as `_sass/components/_project-cards.scss` or `_sass/ui/_cards-project.scss`, which would then be imported into the main stylesheet.
*   The theme's existing styling conventions should be followed.

## 6. Example Liquid for Data Preparation and Include Usage

This is a conceptual Liquid snippet demonstrating the data preparation and how the include might be used on a listing page (e.g., `projects.html`).

```liquid
{% comment %}
  Conceptual Liquid for a page like projects.html
  This is simplified. Actual implementation might need more robust assignments or custom plugins for clarity.
{% endcomment %}

{% assign all_projects = "" | split: "" %} {% comment %} Initialize an empty array {% endcomment %}

{% comment %} 1. Process and unify GitHub projects {% endcomment %}
{% if site.data.github_projects and site.data.github_projects.projects %}
  {% for gh_project in site.data.github_projects.projects %}
    {% assign unified_gh_project = "" | split: "" | push: "display_title:" | append: gh_project.title %}
    {% comment %}
      Liquid's object creation is verbose.
      In a real scenario, we'd assign each field of the unified structure here.
      Example for one field:
      gh_project_map = {}
      gh_project_map = gh_project_map | default: 'display_title', gh_project.title
      gh_project_map = gh_project_map | default: 'display_description', gh_project.description
      ... etc. for all fields from docs/project-data-structures.md ...
      gh_project_map = gh_project_map | default: 'source_type', "github"
      gh_project_map = gh_project_map | default: 'project_type_specific_data', gh_project_specific_object
    {% endcomment %}

    {% assign temp_project = '{
      "display_title": "' | append: gh_project.title | append: '",
      "display_description": "' | append: gh_project.description | append: '",
      "display_url": "' | append: gh_project.github_url | append: '",
      "display_tags": ' | append: gh_project.tags | json | append: ',
      "display_date_text": "' | append: gh_project.date_display | append: '",
      "sortable_date": "' | append: gh_project.sort_date | append: '",
      "source_type": "github",
      "project_type_specific_data": {
        "gh_stars": ' | append: gh_project.stars | append: ',
        "gh_forks": ' | append: gh_project.forks | append: ',
        "gh_language": "' | append: gh_project.language | append: '"
      }
    }' | parse_json %}
    {% assign all_projects = all_projects | push: temp_project %}
  {% endfor %}
{% endif %}

{% comment %} 2. Process and unify local projects {% endcomment %}
{% for local_project in site.local_projects %}
  {% comment %} Similar mapping logic as above for local_project fields {% endcomment %}
  {% assign temp_project = '{
    "display_title": "' | append: local_project.title | append: '",
    "display_description": "' | append: local_project.description | append: '",
    "display_url": "' | append: local_project.url | append: '",
    "display_tags": ' | append: local_project.tags | json | append: ',
    "display_date_text": "Created on ' | append: local_project.created_date | date: '%Y-%m-%d' | append: '" ,
    "sortable_date": "' | append: local_project.created_date | date: '%Y-%m-%dT%H:%M:%SZ' | append: '",
    "source_type": "local",
    "project_type_specific_data": {
      "local_image_path": "' | append: local_project.image_path | append: '",
      "local_demo_url": "' | append: local_project.demo_url | append: '",
      "local_status": "' | append: local_project.status | append: '"
    }
  }' | parse_json %}
  {% assign all_projects = all_projects | push: temp_project %}
{% endfor %}

{% comment %} 3. Sort all projects by date {% endcomment %}
{% assign sorted_projects = all_projects | sort: "sortable_date" | reverse %}


{% comment %} 4. Display projects using the include {% endcomment %}
<div class="project-list">
  {% for item in sorted_projects %}
    {% include projects/project_card.html project=item %}
  {% endfor %}
</div>
```

**Acknowledgement of Liquid's Limitations:**
Creating complex objects and transforming data directly in Liquid (as shown conceptually above with string appends and `parse_json`) can be very verbose and error-prone. For a cleaner implementation, especially the data transformation part:
*   A custom Jekyll plugin (Ruby filter) could be developed to handle the mapping from raw project data (GitHub or local) to the unified structure. This would significantly simplify the Liquid templates.
*   Jekyll Hooks could also be used to process this data before page rendering.

However, the structural design of passing a pre-unified `project` object to a common include remains valid regardless of how the unification is technically achieved. The example above illustrates the _intent_ of data preparation.

This presentation layer design promotes modularity and consistency for displaying diverse project types.
