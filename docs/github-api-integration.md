# GitHub API Integration Plan

## 1. Introduction

This document outlines the strategy for fetching public GitHub repository data to be displayed as projects within the Insights4YOU Jekyll theme. The goal is to automate the process of retrieving relevant project information and making it available to Jekyll for site generation.

## 2. Fetching Mechanism

*   **Script:** A Ruby script, tentatively named `_scripts/fetch_github_projects.rb`, will be responsible for interacting with the GitHub API.
*   **Execution:**
    *   This script is intended to be executed *before* the `jekyll build` command.
    *   This can be managed via:
        *   A `Makefile`: e.g., `make fetch-projects && jekyll build`
        *   A `package.json` script (if Node.js is used for other build tasks): e.g., `"build": "ruby _scripts/fetch_github_projects.rb && jekyll build"`
        *   A custom shell script that orchestrates these steps.
*   **GitHub API Endpoint:**
    *   The primary endpoint will be `GET /users/{username}/repos`.
    *   The `{username}` will need to be configurable, likely read from `_config.yml` or an environment variable.
    *   **Pagination:** The script must handle paginated results from the GitHub API to ensure all repositories are fetched. The API returns a default of 30 items per page, so the script will need to follow `Link` headers or use page parameters (e.g., `?per_page=100&page=1`).
*   **Required Ruby Gems:**
    *   `httparty`: For making HTTP requests to the GitHub API.
    *   `json`: For parsing the JSON response from the API.
    *   `yaml`: For formatting the output data into YAML.
    *   `dotenv`: (Optional, but recommended) For managing environment variables like `GITHUB_TOKEN` in a `.env` file during local development.
    *   Consideration for `octokit.rb`: While `httparty` is sufficient for basic GET requests, `octokit.rb` is a more comprehensive GitHub API client that handles authentication, pagination, and rate limiting more gracefully. The final implementation may choose `octokit.rb` for robustness.

## 3. Authentication

*   **Method:** A GitHub Personal Access Token (PAT) is required for authenticated requests to the GitHub API. This increases rate limits and allows access to repository details.
*   **Scope:** The PAT must have the `public_repo` scope to read public repository information.
*   **Environment Variable:** The token must be provided to the script via an environment variable, e.g., `GITHUB_TOKEN`. The script will expect this variable to be set.
*   **Setting the Token:**
    *   **Local Development:** Users can set this variable in their shell, or by using a `.env` file (e.g., `GITHUB_TOKEN=your_pat_here`) if the `dotenv` gem is used. The `.env` file should be added to `.gitignore`.
    *   **GitHub Actions:** If the site is built using GitHub Actions, the token can be stored as a repository secret (e.g., `GH_TOKEN_FOR_PROJECTS`) and passed as an environment variable to the build step.

## 4. Data to be Fetched

The script will retrieve the following fields for each public repository. These fields align with the `github` project type defined in `docs/project-data-structures.md`:

*   `name`: Repository name. (Becomes `title` in the common structure).
*   `description`: Repository description.
*   `stargazers_count`: Number of stars. (Becomes `stars`).
*   `forks_count`: Number of forks. (Becomes `forks`).
*   `html_url`: URL to the repository. (Becomes `url` and `github_url`).
*   `pushed_at`: Timestamp of the last push.
*   `language`: Primary programming language.

## 5. Data Transformation and Storage

*   **Transformation:** The script will iterate through the fetched repositories and transform each one into a Ruby hash (object) that matches the structure defined for GitHub projects in `docs/project-data-structures.md`.
    *   `title`: from `name`
    *   `description`: from `description`
    *   `type`: hardcoded as `"github"`
    *   `url`: from `html_url`
    *   `tags`: (Optional) May initially be empty or could attempt to derive from repository topics if desired.
    *   `date_display`: To be formatted from `pushed_at` (e.g., "Last updated on YYYY-MM-DD").
    *   `sort_date`: from `pushed_at` (ISO 8601 format).
    *   `stars`: from `stargazers_count`
    *   `forks`: from `forks_count`
    *   `language`: from `language`
    *   `github_url`: from `html_url`
    *   `pushed_at`: from `pushed_at` (raw date for internal use if needed)
*   **Storage:** The resulting array of project objects will be written to the `_data/github_projects.yml` file. This makes the data accessible in Jekyll via `site.data.github_projects`. The script will overwrite this file on each run.

## 6. Error Handling

The script should implement basic error handling:

*   **API Errors:** Log any errors received from the GitHub API (e.g., 403 Forbidden, 404 Not Found, 500 Server Error).
*   **Network Issues:** Handle potential network connection problems gracefully.
*   **Missing Token:** If the `GITHUB_TOKEN` environment variable is not set, the script should log a clear error message and exit. It should not attempt to make unauthenticated requests as they are severely rate-limited and may not fetch all necessary data.
*   **Fetching Failure Behavior:**
    *   **Ideal:** If fetching fails, the script could attempt to use the existing `_data/github_projects.yml` as a cache to prevent build failures if the API is temporarily unavailable. A warning should be logged.
    *   **Alternative:** Write an empty list to `_data/github_projects.yml` and log a warning. This ensures the site builds but without GitHub projects.
    *   **Stricter:** Fail the build process if data fetching is critical. This is configurable based on project needs.
    *   A timestamp of the last successful fetch could be stored in the data file or a separate cache file to determine if the cached data is too stale.

## 7. Example Conceptual Snippet (Ruby)

This is a high-level conceptual illustration, not runnable code.

```ruby
# _scripts/fetch_github_projects.rb (Conceptual)
require 'httparty'
require 'json'
require 'yaml'
# require 'dotenv'; Dotenv.load if File.exist?('.env') # For local .env loading

GITHUB_TOKEN = ENV['GITHUB_TOKEN']
GITHUB_USERNAME = "your_username" # This should be configurable

unless GITHUB_TOKEN
  puts "Error: GITHUB_TOKEN environment variable not set."
  exit 1
end

headers = {
  "Authorization" => "token #{GITHUB_TOKEN}",
  "Accept" => "application/vnd.github.v3+json"
}

# Fetch user repositories (simplified, needs pagination handling)
# response = HTTParty.get("https://api.github.com/users/#{GITHUB_USERNAME}/repos?sort=pushed&per_page=100", headers: headers)

# if response.success?
#   raw_repos = JSON.parse(response.body)
#   transformed_projects = raw_repos.map do |repo|
#     {
#       title: repo['name'],
#       description: repo['description'],
#       type: "github",
#       url: repo['html_url'],
#       tags: repo['topics'] || [], # GitHub topics can be used as tags
#       date_display: "Last updated on #{Time.parse(repo['pushed_at']).strftime('%Y-%m-%d')}",
#       sort_date: repo['pushed_at'],
#       stars: repo['stargazers_count'],
#       forks: repo['forks_count'],
#       language: repo['language'],
#       github_url: repo['html_url'],
#       pushed_at: repo['pushed_at']
#     }
#   end

#   File.write("_data/github_projects.yml", transformed_projects.to_yaml)
#   puts "Successfully fetched and wrote #{transformed_projects.count} GitHub projects."
# else
#   puts "Error fetching GitHub projects: #{response.code} - #{response.message}"
#   # Implement fallback/caching logic here
# end
```

This plan provides a comprehensive guide for the implementation of the GitHub API integration script.
