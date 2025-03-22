Gem::Specification.new do |spec|
  spec.name          = "insights4you-jekyll-theme"
  spec.version       = "0.2.0" # Incremented version
  spec.authors       = ["Marcio Paiva Barbosa"]
  spec.email         = ["mpaivabarbosa@gmail.com"]

  spec.summary       = "A sleek and modern Jekyll theme inspired by the Tabler Admin Dashboard."
  spec.description   = <<~DESC
    A sleek and modern Jekyll theme inspired by the [Tabler Admin Dashboard](https://github.com/tabler). 
    This theme offers a clean, professional, and responsive interface, making it ideal for developers, 
    content creators, and businesses. Whether you're building documentation sites, admin panels, or 
    project showcases, this theme provides a minimal-effort solution with customizable layouts and 
    modern design elements.
  DESC
  spec.homepage      = "https://github.com/marciopaiva/insights4you-jekyll-theme"
  spec.license       = "MIT"

  # Include only relevant files for the theme
  spec.files         = `git ls-files -z`.split("\x0").select { |f|
    f.match(%r!^((_(includes|layouts|sass|(data\/(locales|origin)))|assets|_posts)\/|README|LICENSE)!i)
  }

  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme/issues",
    "documentation_uri" => "https://github.com/marciopaiva/insights4you-jekyll-theme/#readme",
    "source_code_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme",
    "wiki_uri"          => "https://github.com/marciopaiva/insights4you-jekyll-theme/wiki",
    "changelog_uri"     => "https://github.com/marciopaiva/insights4you-jekyll-theme/blob/main/CHANGELOG.md",
    "plugin_type"       => "theme",
    "funding_uri"       => "https://github.com/sponsors/marciopaiva" # Optional
  }

  spec.required_ruby_version = "~> 3.1"

  spec.add_runtime_dependency "jekyll", ">= 3.9", "< 5.0"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.8"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.15" # For generating RSS feeds

  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "webrick", "~> 1.7" # Required for local servers on some Ruby versions
end