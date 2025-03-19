
Gem::Specification.new do |spec|
    spec.name          = "insights4you-jekyll-theme"
    spec.version       = "1.0.0"
    spec.authors       = ["Marcio Paiva Barbosa"]
    spec.email         = ["mpaivabarbosa@gmail.com"]
  
    spec.summary       = "A minimal, responsive, and feature-rich Jekyll theme for technical writing."
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
  
    spec.add_runtime_dependency "jekyll", "~> 4.3"

    spec.add_development_dependency "bundler", "~> 2.0"
  
  end