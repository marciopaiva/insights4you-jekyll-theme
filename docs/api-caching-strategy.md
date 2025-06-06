# GitHub API Caching Strategy

## 1. Introduction

This document outlines the caching strategy for data fetched from the GitHub API by the `_scripts/fetch_github_projects.rb` script. Caching is crucial for several reasons:

*   **Performance:** Reduces build times by avoiding repeated API calls for data that hasn't changed.
*   **Rate Limiting:** Helps stay within GitHub API rate limits, especially for sites with many projects or frequent builds.
*   **Resilience:** Allows the site to build with existing project data if the GitHub API is temporarily unavailable or if the `GITHUB_TOKEN` is missing.

## 2. Cache Storage

*   **Primary Cache File:** The `_data/github_projects.yml` file will serve as the primary cache storage.
*   **Management:** The `_scripts/fetch_github_projects.rb` script will be solely responsible for reading from, writing to, and managing the validity of this cache file.
*   **Structure:** The cached data will be an array of GitHub project objects. To manage the cache, the script will embed a metadata field directly within this YAML file, for example, at the top level or as a separate entry if YAML structure allows (alternatively, a simple top-level key alongside the projects array). A common approach is to have a structure like:
    ```yaml
    last_fetched_at: "YYYY-MM-DDTHH:MM:SSZ"
    projects:
      - name: "Project 1"
        # ... other project data
      - name: "Project 2"
        # ... other project data
    ```
    Or, if the file must be strictly an array, a companion file like `_data/github_projects_cache_meta.yml` could be used, though managing this adds complexity. For simplicity, this document assumes the `last_fetched_at` timestamp can be embedded within or alongside the project data in `_data/github_projects.yml`. If the file must be a pure list, the timestamp might be checked by reading the first few lines or by a small companion file. For this strategy, we will assume the script can manage a top-level key in the YAML.

## 3. Cache Invalidation Mechanisms

The cache will be invalidated and data re-fetched under the following conditions:

*   **Time-based Expiration:**
    *   A timestamp, `last_fetched_at: YYYY-MM-DDTHH:MM:SSZ`, will be stored in the `_data/github_projects.yml` file (or a companion metadata file).
    *   A configurable cache duration will be defined within the script (e.g., `CACHE_DURATION_HOURS = 6`). This could also be exposed as an environment variable.
    *   Before attempting to fetch data, the script will check if `_data/github_projects.yml` exists and read its `last_fetched_at` timestamp.
    *   If `current_time - last_fetched_at > CACHE_DURATION`, the cache is considered stale, and the script will proceed to re-fetch the data from the GitHub API.
*   **Manual Refresh:**
    *   **Command-line Flag:** The script `_scripts/fetch_github_projects.rb` should accept a command-line argument, such as `--force-refresh` or `--no-cache`, to bypass the cache check and always fetch fresh data from the API.
        *   Example: `ruby _scripts/fetch_github_projects.rb --force-refresh`
    *   **File Deletion:** Deleting the `_data/github_projects.yml` file before running the script will naturally trigger a fresh fetch, as the cache will be missing.

## 4. Script Logic (`_scripts/fetch_github_projects.rb`)

The script will implement the following logic to manage the cache:

1.  **Check for Force Refresh:** If a `--force-refresh` flag is provided, skip cache checks (steps 2-4) and proceed directly to fetching (step 5).
2.  **Check Cache Existence:** Verify if `_data/github_projects.yml` exists.
    *   If not, proceed to fetching (step 5).
3.  **Read Cache Timestamp:** If the file exists, attempt to read the `last_fetched_at` timestamp from it.
    *   If the timestamp is missing or malformed, treat the cache as invalid and proceed to fetching (step 5), logging a warning.
4.  **Validate Cache Freshness:** Compare the `last_fetched_at` timestamp with the current time and the defined `CACHE_DURATION`.
    *   If `current_time - last_fetched_at <= CACHE_DURATION`, the cache is considered fresh and valid.
    *   The script should log a message indicating that valid cached data is being used (e.g., "Using cached GitHub projects data from [timestamp].").
    *   The script then exits successfully without making any API calls. The existing `_data/github_projects.yml` will be used by Jekyll.
5.  **Fetch Data from API (Cache Miss or Stale):**
    *   If the cache is missing, stale, invalid, or a force refresh is requested, the script proceeds to fetch data from the GitHub API as detailed in `docs/github-api-integration.md`.
    *   This includes authentication, making API requests, handling pagination, and transforming the data.
6.  **Write to Cache:**
    *   If data is successfully fetched from the API:
        *   The script will construct the data structure (e.g., a hash containing the `projects` array and the `last_fetched_at` timestamp set to the current time).
        *   This structure is then written to `_data/github_projects.yml`, overwriting the previous content.
        *   Log a message indicating that fresh data was fetched and cached.
    *   If API fetching fails:
        *   The script should log the error.
        *   **Behavior (configurable, but recommended):** Do not overwrite the existing `_data/github_projects.yml` if it contains potentially usable (though stale) data. Log a warning that stale data is being kept due to API failure.
        *   If there's no existing cache to fall back on, then write an empty list or an error indicator to `_data/github_projects.yml` to ensure the build doesn't break.

## 5. Handling Missing `GITHUB_TOKEN`

The `GITHUB_TOKEN` is essential for reliable API interaction.

*   **If `GITHUB_TOKEN` is not set:**
    1.  The script should first log a prominent warning that the token is missing.
    2.  It should then check if `_data/github_projects.yml` exists.
    3.  **If a cache file exists:**
        *   The script should use the data from this file, regardless of its `last_fetched_at` timestamp (as fresh data cannot be fetched anyway).
        *   A message should be logged indicating that a GITHUB_TOKEN was not provided and stale data is being used.
    4.  **If no cache file exists (and no token):**
        *   The script must ensure `_data/github_projects.yml` is created and contains a valid, empty list for the `projects` key (e.g., `projects: []` and perhaps a `status: "Error - GITHUB_TOKEN not provided and no cache available"`).
        *   This allows the Jekyll build to proceed without GitHub project data but also without failing due to a missing data file.
        *   A clear error/warning message should be logged.

## 6. `.gitignore` Considerations

*   **`_data/github_projects.yml`:** The current strategy assumes that `_data/github_projects.yml` will be versioned (committed to Git).
    *   **Rationale:** This file acts as a fallback for environments where the fetch script cannot be run (e.g., simpler build processes, or if a user clones the theme and builds without setting up the token immediately). The script then updates this file when it runs successfully.
    *   If the strategy were different, and `_data/github_projects.yml` was *always* generated by the script and never manually edited or relied upon from the repo directly, it could be added to `.gitignore`. However, for increased robustness and easier initial setup for theme users, keeping it versioned and updatable by the script is preferred.
*   **Other Cache Files:** If any other temporary cache files or directories (e.g., a dedicated `.cache/` directory for API responses before processing) were to be introduced by the script, those *should* be added to `.gitignore`. (This strategy currently does not propose such additional files).

This caching strategy aims to balance freshness of data with build performance, API rate limit considerations, and resilience to token or API availability issues.
