#!/bin/bash

# Variables
THEME_DIR="."
EXAMPLE_SITE_DIR="example-site"
GEM_NAME="insights4you-jekyll-theme"

# Step 1: Build the gem
echo "Building the gem..."
cd "$THEME_DIR" || { echo "Error: Directory $THEME_DIR not found."; exit 1; }
gem build "$GEM_NAME.gemspec" || { echo "Error: Failed to build the gem."; exit 1; }

# Step 2: Install the gem locally
echo "Installing the gem locally..."
gem install "./$GEM_NAME-*.gem" || { echo "Error: Failed to install the gem."; exit 1; }

# Step 3: Navigate to the example site directory
echo "Navigating to the example site directory..."
cd "$EXAMPLE_SITE_DIR" || { echo "Error: Directory $EXAMPLE_SITE_DIR not found."; exit 1; }

# Step 4: Install dependencies
echo "Installing dependencies with Bundler..."
bundle install || { echo "Error: Failed to install dependencies."; exit 1; }

# Step 5: Serve the Jekyll site
echo "Starting the Jekyll server..."
bundle exec jekyll clean && bundle exec jekyll serve --trace || { echo "Error: Failed to start the Jekyll server."; exit 1; }

echo "Jekyll server is running at http://localhost:4000"