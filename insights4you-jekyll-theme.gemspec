# frozen_string_literal: true

require 'date'

Gem::Specification.new do |spec|
  # Basic Information
  spec.name          = "insights4you-jekyll-theme"
  spec.version       = "0.4.0"
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
    "documentation_uri" => "https://github.com/marciopaiva/insights4you-jekyll-theme/#readme",
    "homepage_uri"      => "https://github.com/marciopaiva/insights4you-jekyll-theme",
    "wiki_uri"          => "https://github.com/marciopaiva/insights4you-jekyll-theme/wiki",
    "usage_uri"         => "https://github.com/marciopaiva/insights4you-jekyll-theme/wiki/Usage",
    "source_code_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme/tree/main",
    "bug_tracker_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme/issues",
    "changelog_uri"     => "https://github.com/marciopaiva/insights4you-jekyll-theme/blob/main/CHANGELOG.md",
    "examples_uri"      => "https://github.com/marciopaiva/insights4you-jekyll-theme/tree/main/example-site",
    "funding_uri"       => "https://github.com/sponsors/marciopaiva"
  }.freeze

  # Dependencies - Grouped by purpose
  # Runtime Dependencies
  spec.add_runtime_dependency "jekyll", ">= 4.4.1", "< 5.0"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.15"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.8"
  spec.add_runtime_dependency "jekyll-sitemap", "~> 1.4"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-github-metadata", "~> 2.13"
  spec.add_runtime_dependency "octokit", "~> 4.25.1"



  # Development Dependencies
  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "webrick", "~> 1.7"
  spec.add_development_dependency "html-proofer", "~> 5.0"

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
