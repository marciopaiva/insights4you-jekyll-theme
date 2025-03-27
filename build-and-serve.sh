#!/bin/bash

# Default values
THEME_DIR=${1:-"."}
EXAMPLE_SITE_DIR=${2:-"example-site"}
GEM_NAME=${3:-"insights4you-jekyll-theme"}
JEKYLL_PORT=${PORT:-4000}

# Logging function
log() {
  echo "$1"
}

# Run commands silently
run_command() {
  eval "$@" >/dev/null 2>&1 || handle_error "Failed to execute: $*"
}

# Error handling
handle_error() {
  log "Error: $1"
  exit 1
}

# Function to kill existing services
kill_existing_services() {
  local port=$1
  log "Checking for existing services on port $port..."

  # Find processes using the specified port
  local pids=$(lsof -ti :"$port" 2>/dev/null)

  if [ -n "$pids" ]; then
    log "Found existing processes on port $port. Killing them..."
    echo "$pids" | xargs kill -9 2>/dev/null || log "Warning: Failed to kill some processes."
  else
    log "No existing services found on port $port."
  fi

  # Additionally, find and kill any lingering Jekyll processes
  local jekyll_pids=$(pgrep -fl "jekyll serve" | awk '{print $1}')
  if [ -n "$jekyll_pids" ]; then
    log "Found lingering Jekyll processes. Killing them..."
    echo "$jekyll_pids" | xargs kill -9 2>/dev/null || log "Warning: Failed to kill some Jekyll processes."
  fi
}

# Function to remove older versions of the gem
remove_old_gem_versions() {
  local gem_name=$1

  log "Checking for old versions of gem '$gem_name'..."

  # Get the list of installed versions for the gem
  local installed_versions=$(gem list "$gem_name" --local | grep -oP "$gem_name \(\K[^\)]+" | tr ',' '\n')

  if [ -z "$installed_versions" ]; then
    log "No versions of '$gem_name' found. Nothing to remove."
    return
  fi

  # Find the latest version using semantic versioning
  local latest_version=$(echo "$installed_versions" | sort -V | tail -n 1)

  log "Latest version of '$gem_name' is $latest_version."

  # Remove all versions except the latest
  while IFS= read -r version; do
    if [ "$version" != "$latest_version" ]; then
      log "Removing old version: $version"
      run_command "gem uninstall \"$gem_name\" -v \"$version\" --executables --force"
    fi
  done <<< "$installed_versions"
}

# Main script
log "Using THEME_DIR: $THEME_DIR"
log "Using EXAMPLE_SITE_DIR: $EXAMPLE_SITE_DIR"
log "Using GEM_NAME: $GEM_NAME"

# Check prerequisites
check_tool() {
  if ! command -v "$1" &> /dev/null; then
    log "Error: '$1' is not installed. Please install it and try again."
    exit 1
  fi
}

check_tool "gem"
check_tool "bundle"
check_tool "jekyll"

# Step 1: Build the gem
log "Building the gem..."
run_command "cd \"$THEME_DIR\" && gem build \"$GEM_NAME.gemspec\""

# Step 2: Install the gem locally
log "Installing the gem locally..."
run_command "gem install \"./$GEM_NAME-*.gem\""

# Step 2.1: Remove old versions of the gem
remove_old_gem_versions "$GEM_NAME"

# Clean up the generated .gem file
log "Cleaning up generated .gem file..."
run_command "rm -f \"./$GEM_NAME-*.gem\""

# Step 3: Navigate to the example site directory
log "Navigating to the example site directory..."
run_command "cd \"$EXAMPLE_SITE_DIR\""

# Step 4: Install dependencies
log "Installing dependencies with Bundler..."
run_command "bundle install"

# Step 5.1: Clean the Jekyll site
log "Cleaning the Jekyll site..."
run_command "bundle exec jekyll clean"

# Step 5.2: Serve the Jekyll site
log "Starting the Jekyll server on port $JEKYLL_PORT..."

# Kill existing services on the specified port or related to Jekyll
kill_existing_services "$JEKYLL_PORT"

# Start the Jekyll server
log "Setup complete!"
log "--------------------------------------------------"
log "Gem Name: $GEM_NAME"
log "Theme Directory: $THEME_DIR"
log "Example Site Directory: $EXAMPLE_SITE_DIR"
log "Jekyll Server URL: http://localhost:$JEKYLL_PORT"
log "--------------------------------------------------"
run_command "bundle exec jekyll serve --port \"$JEKYLL_PORT\" --trace "




