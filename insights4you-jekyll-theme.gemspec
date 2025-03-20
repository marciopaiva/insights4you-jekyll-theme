Gem::Specification.new do |spec|
  spec.name          = "insights4you-jekyll-theme"
  spec.version       = "0.1.1" 
  spec.authors       = ["Marcio Paiva Barbosa"]
  spec.email         = ["mpaivabarbosa@gmail.com"]

  spec.summary       = "A sleek and modern Jekyll theme inspired by the Tabler Admin Dashboard."
  spec.description   = "A sleek and modern Jekyll theme inspired by the [Tabler Admin Dashboard](https://github.com/tabler). This theme offers a clean, professional, and responsive interface, making it ideal for developers, content creators, and businesses. Whether you're building documentation sites, admin panels, or project showcases, this theme provides a minimal-effort solution with customizable layouts and modern design elements."
  spec.homepage      = "https://github.com/marciopaiva/insights4you-jekyll-theme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f|
    f.match(%r!^((_(includes|layouts|sass|(data\/(locales|origin)))|assets)\/|README|LICENSE)!i)
  }

  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme/issues",
    "documentation_uri" => "https://github.com/marciopaiva/insights4you-jekyll-theme/#readme",
    "source_code_uri"   => "https://github.com/marciopaiva/insights4you-jekyll-theme",
    "wiki_uri"          => "https://github.com/marciopaiva/insights4you-jekyll-theme/wiki",
    "plugin_type"       => "theme"
  }

  spec.required_ruby_version = "~> 3.1"

  spec.add_runtime_dependency "jekyll", ">= 3.9", "< 5.0"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.8"

  spec.add_development_dependency "bundler", "~> 2.4"
end