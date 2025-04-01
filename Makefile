.DEFAULT_GOAL := help
SHELL         := /bin/bash

# Project structure
PROJECT_DIR   := $(shell pwd)
EXAMPLE_DIR   := $(PROJECT_DIR)/example-site
THEME_DIR     := $(PROJECT_DIR)
LOG_FILE      := $(EXAMPLE_DIR)/logs/build.log

# Environment and configuration
ENV           ?= development
ifeq ($(ENV),production)
  JEKYLL_ENV  = production
  JEKYLL_OPTS = --quiet
else
  JEKYLL_ENV  = development
  JEKYLL_OPTS = --trace
endif

# Project variables
GEM_NAME      ?= insights4you-jekyll-theme
JEKYLL_PORT   ?= 4000

# Colors and formatting
RED           := \033[0;31m
GREEN         := \033[0;32m
YELLOW        := \033[1;33m
CYAN          := \033[0;36m
BLUE          := \033[0;34m
NC            := \033[0m
MARGEM        := 15

# Project header
define HEADER


  _              _         _      _         _  _ __     __ ____   _    _ 
 (_)            (_)       | |    | |       | || |\ \   / // __ \ | |  | |
  _  _ __   ___  _   __ _ | |__  | |_  ___ | || |_\ \_/ /| |  | || |  | |
 | || '_ \ / __|| | / _` || '_ \ | __|/ __||__   _|\   / | |  | || |  | |
 | || | | |\__ \| || (_| || | | || |_ \__ \   | |   | |  | |__| || |__| |
 |_||_| |_||___/|_| \__, ||_| |_| \__||___/   |_|   |_|   \____/  \____/ 
                     __/ |                                               
                    |___/                                                

-------------------------------------------------------------------------
endef
export HEADER

.PHONY: help setup build install serve clean kill-services remove-old-gems dev check-deps

help:  ## Display this help message
	@clear
	@printf "\033c"
	@echo "$$HEADER"
	@printf "\n"	
	@printf "$(YELLOW)Insights4You Jekyll Theme Management$(NC)\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-$(MARGEM)s$(NC) %s$(NC)\n", $$1, $$2}'	
	@printf "\n"
	@printf "Usage: $(RED)make$(NC) $(GREEN)[target]$(NC) $(BLUE)[ENV=production|development]$(NC)\n\n"

check-deps: clean ## Check for required dependencies
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@echo "🔍 Checking dependencies..."
	@for cmd in gem bundle jekyll; do \
		command -v $$cmd >/dev/null 2>&1 || { echo "$(RED)❌ Error: '$$cmd' is not installed.$(NC)" >&2; exit 1; } \
	done
	@echo "✅ All dependencies are installed."

build: check-deps ## Build the Jekyll theme gem
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@echo "🛠️  Building $(GEM_NAME)..." | tee -a $(LOG_FILE)
	@cd "$(THEME_DIR)" && gem build "$(GEM_NAME).gemspec" 2>&1 | tee -a $(LOG_FILE)
	@gem install "./$(GEM_NAME)-*.gem" 2>&1 | tee -a $(LOG_FILE)
	@rm -f "./$(GEM_NAME)-*.gem"
	@echo "✅ Build completed successfully."

remove-old-gems: ## Remove old versions of the theme gem
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@echo "🧹 Removing old versions of $(GEM_NAME)..."
	@gem list "$(GEM_NAME)" --local | grep -oP "$(GEM_NAME) \(\K[^\)]+" | tr ',' '\n' | \
	sort -V | head -n -1 | xargs -I {} gem uninstall "$(GEM_NAME)" -v {} --executables --force || true
	@echo "✅ Old gems removed."

kill-services: ## Kill existing Jekyll processes
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@echo "🔄 Killing existing Jekyll processes..."
	@-lsof -ti :$(JEKYLL_PORT) | xargs -r kill -9 2>/dev/null || true
	@-pgrep -f "jekyll serve" | xargs -r kill -9 2>/dev/null || true
	@echo "✅ All Jekyll processes terminated."

install: check-deps ## Install dependencies in example site
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@echo "📦 Installing dependencies..." | tee -a $(LOG_FILE)
	@cd "$(EXAMPLE_DIR)" && bundle install --quiet 2>&1 | tee -a $(LOG_FILE)
	@echo "✅ Dependencies installed successfully."

clean: ## Clean Jekyll site
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@echo "🧹 Cleaning Jekyll site..."
	@cd "$(EXAMPLE_DIR)" && bundle exec jekyll clean
	@rm -f $(LOG_FILE)
	@echo "✅ Clean completed."

serve: build remove-old-gems kill-services install  ## Build and serve the site
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@printf "🚀 Starting Jekyll server on port $(JEKYLL_PORT)...\n" | tee -a $(LOG_FILE)
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@printf "$(BLUE)Environment: $(ENV)$(NC)\n"
	@printf "$(BLUE)Project Directory: $(PROJECT_DIR)$(NC)\n"
	@printf "$(BLUE)Theme Directory: $(THEME_DIR)$(NC)\n"
	@printf "$(BLUE)Example Site: $(EXAMPLE_DIR)$(NC)\n"
	@printf "$(BLUE)Server URL: http://localhost:$(JEKYLL_PORT)$(NC)\n"
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"	
	@cd "$(EXAMPLE_DIR)" && JEKYLL_ENV=$(JEKYLL_ENV) bundle exec jekyll serve \
		--port $(JEKYLL_PORT) $(JEKYLL_OPTS) \
		--config _config.yml --quiet 2>&1 | tee -a $(LOG_FILE)

dev: build remove-old-gems kill-services install  ## Serve with live reload (development mode)
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@printf "🔧 Starting Jekyll server in development mode...\n" | tee -a $(LOG_FILE)
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@printf "$(BLUE)Environment: development$(NC)\n"
	@printf "$(BLUE)Project Directory: $(PROJECT_DIR)$(NC)\n"
	@printf "$(BLUE)Theme Directory: $(THEME_DIR)$(NC)\n"
	@printf "$(BLUE)Example Site: $(EXAMPLE_DIR)$(NC)\n"
	@printf "$(BLUE)Server URL: http://localhost:$(JEKYLL_PORT)$(NC)\n"
	@printf "$(YELLOW)-----------------------------------------------------------------------------------$(NC)\n"
	@cd "$(EXAMPLE_DIR)" && JEKYLL_ENV=development bundle exec jekyll serve \
		--port $(JEKYLL_PORT) --livereload --trace \
		--config _config.yml 2>&1 | tee -a $(LOG_FILE)

setup: check-deps clean install ## Initial setup of the project
	@echo "🎯 Setting up project..."
	@echo "✅ Setup completed successfully."
