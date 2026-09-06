<div align='center'>

# Insights4YOU Jekyll Theme

A sleek and modern Jekyll theme inspired by the [Tabler Admin Dashboard](https://github.com/tabler/tabler). This theme offers a clean, professional, and responsive interface, making it ideal for developers, content creators, and businesses. Whether you're building a personal site, a blog, or a project showcase, this theme provides a minimal-effort solution with customizable layouts and modern design elements.

![Theme Preview](assets/images/preview-dark.png)

[![last commit](https://img.shields.io/github/last-commit/marciopaiva/insights4you-jekyll-theme?logo=github)][repo]
[![gem build](https://github.com/marciopaiva/insights4you-jekyll-theme/actions/workflows/gem.yml/badge.svg)][build]
[![codacy badge](https://img.shields.io/codacy/grade/4e556876a3c54d5e8f2d2857c4f43894?logo=codacy)][codacy]
[![gem version](https://img.shields.io/gem/v/insights4you-jekyll-theme?&logo=rubygems&logoColor=ghostwhite&label=gem&color=orange)][gem]
[![downloads](https://img.shields.io/gem/dt/insights4you-jekyll-theme?logo=rubygems&color=blue)][gem]
[![github license](https://img.shields.io/github/license/marciopaiva/insights4you-jekyll-theme?color=goldenrod)][license]

</div>

## 🌟 Features

- 🌙 **Dark and Light Themes**: A "Theme Builder" panel lets visitors switch color mode, accent color, font family, gray base and corner radius on the fly (saved in `localStorage`)
- 📱 **Responsive Design**: Built on Bootstrap 5 / Tabler, fully usable on mobile, tablet and desktop
- ✍️ **Blog**: `_posts` support with a ready-to-use post layout and a card-based listing page
- 🔍 **Instant Search**: Client-side filtering over any card grid (e.g. the blog listing) as you type - no build step or external service
- 📦 **Projects, two ways**: a `projects` collection for hand-curated local project cards, plus an auto-generated grid of your GitHub repositories that have at least one star (via `jekyll-github-metadata`)
- 💬 **Comments via Giscus**: optional, GitHub Discussions-based comments on posts - no third-party ads or tracking
- 🌐 **Translatable UI strings**: every built-in label (project page headings, error pages, empty states, search placeholder) can be overridden by your own `_data/i4y-strings.yml` and `_data/i4y-errors.json`
- 🚀 **SEO Ready**: ships with `jekyll-seo-tag`, `jekyll-sitemap` and `jekyll-feed` support
- 📦 **Gem-Based Installation**: install via RubyGems, or track the repo directly with Bundler's `github:` source
- 🎨 **200+ bundled icons**: Tabler's icon set, inlined as SVG by default (or as an icon font, if you prefer)

## 📋 Requirements

- Ruby >= 3.2.2
- Jekyll >= 4.4, < 5.0
- Bundler ~> 2.4

⚠️ **This theme will not build on GitHub Pages' native "Deploy from a branch" option.** GitHub Pages' native build pins Jekyll to 3.10 and its Sass converter to the legacy Ruby Sass line, which cannot compile the Dart-Sass module syntax (`@use`, `color.adjust(...)`) that Bootstrap 5.3+ uses. Deploy via **GitHub Actions** instead - see [Deploying to GitHub Pages](#-deploying-to-github-pages) below.

## 🚀 Quick Start

1. **Create a new Jekyll site** (or use an existing one):
```bash
jekyll new my-website && cd my-website
```

2. **Add the theme to your `Gemfile`:**
```ruby
gem "insights4you-jekyll-theme"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jekyll-github-metadata"
  gem "jekyll-paginate"   # required by the theme's own dependencies, even if unused
  gem "jemoji"
end
```

3. **Update your `_config.yml`:**
```yaml
theme: insights4you-jekyll-theme
repository: your-username/your-repo   # NWO used by jekyll-github-metadata

plugins:
  - jemoji
  - jekyll-seo-tag
  - jekyll-sitemap
  - jekyll-feed
  - jekyll-github-metadata

author:
  name: Your Name
  bio: Your one-line bio
  image: https://example.com/your-avatar.jpg
  email: you@example.com
  github: your-username        # matched against _data/i4y-social-media.yml
  linkedin: your-linkedin-slug
```

4. **Install dependencies and start your site:**
```bash
bundle install
bundle exec jekyll serve
```

## 🚢 Deploying to GitHub Pages

Because of the Sass constraint above, set your repository's **Settings → Pages → Source** to **"GitHub Actions"**, and add a workflow like this (adjust the ruby version/paths as needed):

```yaml
name: Deploy Jekyll site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.2"
          bundler-cache: true
      - id: pages
        uses: actions/configure-pages@v5
      - env:
          JEKYLL_ENV: production
          PAGES_REPO_NWO: ${{ github.repository }}
          JEKYLL_GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

`JEKYLL_GITHUB_TOKEN` gives `jekyll-github-metadata` a 5,000 requests/hour budget instead of the unauthenticated 60/hour limit - without it, the GitHub-repositories grid may silently come up empty on repeated builds.

## 🎯 Demo Site

To see the theme in action, check out the included example site:

```bash
git clone https://github.com/marciopaiva/insights4you-jekyll-theme.git
cd insights4you-jekyll-theme
make dev
```

Visit `http://localhost:4000` to see the demo site in action.

## 🎨 Customization

### Layouts
| Layout | Use it for |
|---|---|
| `base` | Root HTML document. You won't use this directly. |
| `default` | Standard pages (home, about, projects...). Set `layout-wrapper-full: true` in front matter for a centered "card" wrapper instead of the full-width container - handy for long-form content. |
| `post` | Blog posts. Renders title, date, tags, content, and Giscus comments (if enabled and `page.comments: true`). |
| `error` | Error pages (404, etc). Set `page-error: "404"` in front matter to pull text/illustration from `_data/i4y-errors.json`. |

### Front matter reference
| Key | Where | Effect |
|---|---|---|
| `weight` | any page | Order in the navbar (lower first) |
| `icon` | any page | Tabler icon name shown next to its navbar entry |
| `external_url` | any page | Makes its navbar entry link elsewhere instead of `page.url` |
| `no-container` | page/layout | Removes the `.container-xl` around the page body |
| `layout-wrapper-full` | page/layout | Centered card wrapper (see `default` layout above) |
| `custom_css` / `custom_js` | any page | Arrays of extra `/assets/{css,js}/<name>.{css,js}` files to load |
| `comments` | posts | Show the Giscus widget on this post (also needs `site.giscus.enabled: true`) |

### Translating the UI
Every hardcoded label lives in `_data/i4y-strings.yml`. Copy the theme's version into your own site's `_data/i4y-strings.yml` and translate it - your site's file takes precedence over the theme's. Error-page copy (`_data/i4y-errors.json`) works the same way.

### Adding local projects
Declare a `projects` collection in `_config.yml`:
```yaml
collections:
  projects:
    output: true
    permalink: /projects/:name
```
Then add files under `_projects/`:
```yaml
---
name: My Project
tools: [Rust, Tauri]
image: /assets/images/my-project.png   # optional
description: One or two sentences about it.
external_url: https://github.com/you/my-project   # omit to link to this file's own body instead
---
Optional markdown body, rendered as the project's own detail page when there's no `external_url`.
```

### Custom Styling
Add your own `_sass` partials and `@import` them from a site-level `assets/css/custom.scss`, then reference it from a page's `custom_css` front matter key.

## 🤝 Contributing

We love your input! We want to make contributing to Insights4YOU as easy and transparent as possible. Please:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Tabler Admin Dashboard for design inspiration
- Jekyll community for the amazing static site generator
- All contributors who help improve this theme

[repo]: https://github.com/marciopaiva/insights4you-jekyll-theme
[build]: https://github.com/marciopaiva/insights4you-jekyll-theme/actions/workflows/gem.yml
[codacy]: https://app.codacy.com/gh/marciopaiva/insights4you-jekyll-theme/dashboard
[gem]: https://rubygems.org/gems/insights4you-jekyll-theme
[license]: https://github.com/marciopaiva/insights4you-jekyll-theme/blob/master/LICENSE
