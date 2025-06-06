# Project Filtering and Sorting Logic

## 1. Introduction

This document details the strategy for enabling users to filter and sort the displayed list of projects within the Insights4YOU Jekyll theme. The primary goal is to provide intuitive controls for refining the project view based on various criteria, implemented primarily using Jekyll's Liquid templating language.

## 2. Data Source

All filtering and sorting operations will be performed on the **unified `all_projects` list**. This list, as defined in `docs/presentation-layer-design.md`, is a combination of local projects (`site.local_projects`) and GitHub projects (`site.data.github_projects`) that have already been transformed into a consistent data structure suitable for rendering.

The generation of this `all_projects` list (including initial transformation and potential default sorting) happens on the page that will display the projects (e.g., `projects.html` or an equivalent).

## 3. Sorting Strategy

Projects will be sortable by various criteria, with a default sort order applied. User-selected sorting will be controlled via URL parameters.

*   **Default Sort:**
    *   By default, projects will be sorted by `sortable_date` in descending order (most recent first).
    *   This is typically applied after the `all_projects` list is fully constructed.
    *   **Liquid Snippet (Conceptual - applied to `all_projects`):**
        ```liquid
        {% assign sorted_projects = all_projects | sort: "sortable_date" | reverse %}
        ```

*   **User-Selectable Sorting (Liquid-based):**
    *   **Mechanism:** URL parameters will trigger different sort orders. For example:
        *   `?sort_by=date_desc` (default)
        *   `?sort_by=date_asc`
        *   `?sort_by=title_asc`
        *   `?sort_by=title_desc`
        *   `?sort_by=stars_desc` (for GitHub projects, local projects might fall to end or beginning)
    *   **Liquid Logic:**
        1.  **Parse URL Parameter:** Capture the `sort_by` parameter from the URL.
            ```liquid
            {% assign sort_param = site.url | append: page.url | split: "?" | last | split: "&" %}
            {% assign current_sort_by = "date_desc" %} {% comment %} Default sort {% endcomment %}
            {% for param in sort_param %}
              {% if param contains "sort_by=" %}
                {% assign current_sort_by = param | split: "=" | last %}
              {% endif %}
            {% endfor %}
            ```
            *Note: Liquid URL parsing is basic. More robust parsing might involve JavaScript or custom plugins if complex URL structures are needed.*

        2.  **Apply Sorting:** Use Liquid's `sort` filter based on the `current_sort_by` value.
            ```liquid
            {% if current_sort_by == "title_asc" %}
              {% assign processed_projects = all_projects | sort_natural: "display_title" %}
            {% elsif current_sort_by == "title_desc" %}
              {% assign processed_projects = all_projects | sort_natural: "display_title" | reverse %}
            {% elsif current_sort_by == "stars_desc" %}
              {% comment %} Sorting by a type-specific field needs care.
                  Projects without 'gh_stars' (i.e., local projects) will be nil and typically group at one end.
                  A custom plugin would be better for complex heterogeneous sorting.
                  For simple Liquid, this will sort GitHub projects by stars, local projects will be grouped.
              {% endcomment %}
              {% assign processed_projects = all_projects | sort: "project_type_specific_data.gh_stars" | reverse %}
            {% elsif current_sort_by == "date_asc" %}
              {% assign processed_projects = all_projects | sort: "sortable_date" %}
            {% else %} {% comment %} Default to date_desc {% endcomment %}
              {% assign processed_projects = all_projects | sort: "sortable_date" | reverse %}
            {% endif %}
            ```
    *   **Considerations for Type-Specific Sorting:** When sorting by fields unique to one project type (e.g., `project_type_specific_data.gh_stars`), projects of other types will have `nil` or missing values for these fields. Liquid's `sort` filter will group these `nil` items together, usually at the beginning of the list (or end, if reversed). This is an inherent behavior of simple Liquid sorting on heterogeneous lists.

## 4. Filtering Strategy (Liquid-based)

Filters will allow users to narrow down the project list based on criteria like project type or tags. Filters will also be controlled by URL parameters.

*   **Filter by Type (GitHub/Local):**
    *   **Mechanism:** URL parameters like `?filter_type=github` or `?filter_type=local`.
    *   **Liquid Logic:**
        ```liquid
        {% assign type_filter_param = "" %}
        {% for param in sort_param %} {% comment %} Assuming sort_param is parsed as above {% endcomment %}
          {% if param contains "filter_type=" %}
            {% assign type_filter_param = param | split: "=" | last %}
          {% endif %}
        {% endfor %}

        {% if type_filter_param == "github" %}
          {% assign filtered_projects = all_projects | where_exp: "item", "item.source_type == 'github'" %}
        {% elsif type_filter_param == "local" %}
          {% assign filtered_projects = all_projects | where_exp: "item", "item.source_type == 'local'" %}
        {% else %}
          {% assign filtered_projects = all_projects %} {% comment %} No type filter or invalid value {% endcomment %}
        {% endif %}
        ```
        *(This `filtered_projects` would then be passed to the sorting logic, or sorting is applied first, then filtering)*

*   **Filter by Tags:**
    *   **Mechanism:** URL parameters like `?filter_tag=javascript`.
    *   **Liquid Logic:**
        ```liquid
        {% assign tag_filter_param = "" %}
        {% for param in sort_param %}
          {% if param contains "filter_tag=" %}
            {% assign tag_filter_param = param | split: "=" | last | url_decode %} {% comment %} Decode if tag names have spaces/special chars {% endcomment %}
          {% endif %}
        {% endfor %}

        {% if tag_filter_param != "" %}
          {% assign projects_after_tag_filter = filtered_projects | where_exp: "item", "item.display_tags contains tag_filter_param" %}
        {% else %}
          {% assign projects_after_tag_filter = filtered_projects %}
        {% endif %}
        ```
    *   **Generating Tag List for UI:** To create the filter UI, a unique list of all available tags should be generated:
        ```liquid
        {% assign all_tags = "" | split: "" %}
        {% for project in all_projects %}
          {% for tag in project.display_tags %}
            {% assign all_tags = all_tags | push: tag %}
          {% endfor %}
        {% endfor %}
        {% assign unique_tags = all_tags | uniq | sort_natural %}
        ```
        This `unique_tags` array can then be used to render filter links/buttons.

*   **Combining Filters:**
    *   Filters can be combined by including multiple URL parameters (e.g., `?filter_type=github&filter_tag=ruby`).
    *   The Liquid logic will apply these filters sequentially. The output of one filter operation becomes the input for the next.
        ```liquid
        {% assign current_list = all_projects %}

        {% comment %} Apply type filter {% endcomment %}
        {% if type_filter_param != "" %}
          {% assign current_list = current_list | where_exp: "item", "item.source_type == type_filter_param" %}
        {% endif %}

        {% comment %} Apply tag filter {% endcomment %}
        {% if tag_filter_param != "" %}
          {% assign current_list = current_list | where_exp: "item", "item.display_tags contains tag_filter_param" %}
        {% endif %}

        {% assign processed_projects = current_list %}
        {% comment %} Then apply sorting to processed_projects {% endcomment %}
        ```

## 5. User Interface (UI) Elements

*   **Sorting Controls:**
    *   Links or dropdown menus that, when clicked, reload the page with the appropriate `sort_by` URL parameter.
    *   Example: `<a href="?sort_by=title_asc">Sort by Title (A-Z)</a>`
*   **Filtering Controls:**
    *   **Type Filters:** Buttons or links for "All", "GitHub", "Local".
        *   Example: `<a href="?filter_type=github">GitHub Projects</a>`
    *   **Tag Filters:** A list of links, with each link representing a tag.
        *   Example: `{% for tag in unique_tags %}<a href="?filter_tag={{ tag | url_encode }}">{{ tag }}</a>{% endfor %}`
*   **Active State:** It's important for the UI to indicate the currently active sort order and filters (e.g., by highlighting the active sort link/button, showing selected tags). This can be achieved in Liquid by comparing current URL parameters with the values of the UI elements.

## 6. Implementation Notes

*   **Location of Logic:** All Liquid-based filtering and sorting logic will reside on the main project listing page template (e.g., `projects.html` or the page where the unified `all_projects` list is generated and displayed).
*   **Page Reloads:** This approach relies on page reloads whenever a sort order or filter is changed. The URL parameters are processed by Liquid during the Jekyll site build/regeneration for that page request.
*   **Simplicity vs. Dynamism:** While Liquid provides sufficient capability for this, it results in full page reloads. Client-side JavaScript (e.g., using libraries like Isotope, List.js, or custom code) could offer a more dynamic, instant filtering/sorting experience without page reloads. However, this is outside the scope of the initial Jekyll/Liquid-focused design and can be considered a progressive enhancement.
*   **URL Parameter Parsing:** As noted, parsing multiple URL parameters and their values robustly in Liquid can be verbose and somewhat fragile. Complex scenarios might benefit from very simple JavaScript to manage URL parameters or a custom Jekyll plugin/tag to simplify access to them within Liquid. For this design, we assume basic parsing as shown in the conceptual snippets.
*   **Order of Operations:** Typically, filtering is applied first to narrow down the dataset, and then sorting is applied to the filtered list.

This strategy provides a functional, server-rendered (Jekyll-processed) method for users to interact with and refine the list of projects.
