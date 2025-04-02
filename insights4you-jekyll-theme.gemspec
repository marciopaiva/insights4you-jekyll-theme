# frozen_string_literal: true

require 'date'

Gem::Specification.new do |spec|
  # Basic Information
  spec.name          = "insights4you-jekyll-theme"
  spec.version       = "0.3.0"
  spec.platform      = Gem::Platform::RUBY
  spec.date          = Time.now.strftime('%Y-%m-%d')
  spec.authors       = ["Marcio Paiva Barbosa"]
  spec.email         = ["mpaivabarbosa@gmail.com"]

  # Descriptions
  spec.summary       = "A sleek and modern Jekyll theme inspired by the Tabler Admin Dashboard."
  spec.description   = File.read('README.md') rescue spec.summary
  spec.homepage      = "https://github.com/marciopaiva/insights4you-jekyll-theme"
  spec.license       = "MIT"
  
  # Files Management - More efficient file selection
  spec.files = Dir.glob(%w[
    {assets,_includes,_layouts,_sass,_data}/**/*
    LICENSE*
    README*
    CHANGELOG*
    *.gemspec
  ]).select { |f| File.file?(f) }

  # Ruby Version Requirement
  spec.required_ruby_version = ">= 3.2.2"

# Metadata - Organized for better readability
spec.metadata = {
  "plugin_type"       => "theme",
  "allowed_push_host" => "https://rubygems.org",
  "rubygems_mfa_required" => "true",
  
  # Documentation Links
  "documentation_uri" => "https://github.com/marciopaiva/insights4you-jekyll-theme/#readme",
  "homepage_uri"      => "https://github.com/marciopaiva/insights4you-jekyll-theme",
  "wiki_uri"          => "https://github.com/marciopaiva/insights4you-jekyll-theme/wiki",
  "usage_uri"         => "https://github.com/marciopaiva/insights4you-jekyll-theme/wiki/Usage",
  
  # Repository Links
  "source_code_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme/tree/main",
  "bug_tracker_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme/issues",
  "changelog_uri"     => "https://github.com/marciopaiva/insights4you-jekyll-theme/blob/main/CHANGELOG.md",
  "examples_uri"      => "https://github.com/marciopaiva/insights4you-jekyll-theme/tree/main/example-site",
  
  # Support
  "funding_uri"       => "https://github.com/sponsors/marciopaiva"
}.freeze

  # Dependencies - Grouped by purpose
  # Runtime Dependencies
  {
    "jekyll" => [">= 4.4.1", "< 5.0"],
    "jekyll-feed" => "~> 0.15",
    "jekyll-seo-tag" => "~> 2.8",
    "jekyll-sitemap" => "~> 1.4",
    "jekyll-paginate" => "~> 1.1"
  }.each do |gem, version|
    spec.add_runtime_dependency gem, version
  end

  # Development Dependencies
  {
    "bundler" => "~> 2.4",
    "rake" => "~> 13.0",
    "rspec" => "~> 3.12",
    "rubocop" => "~> 1.50",
    "webrick" => "~> 1.7",
    "html-proofer" => "~> 5.0"
  }.each do |gem, version|
    spec.add_development_dependency gem, version
  end

  # Installation Message
  spec.post_install_message = <<~MSG.freeze
    ✨ Thanks for installing insights4you-jekyll-theme! ✨
    
    📚 Quick Start:
    1. Add to _config.yml:
       theme: insights4you-jekyll-theme
    2. Documentation:
       #{spec.metadata['documentation_uri']}
    
    🌟 Support:
    - Star: #{spec.homepage}
    - Issues: #{spec.metadata['bug_tracker_uri']}
    - Sponsor: #{spec.metadata['funding_uri']}
    
    Happy theming! 🎨
  MSG
end
