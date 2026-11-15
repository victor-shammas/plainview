# Plainview website (GitHub Pages, custom domain)

The static marketing, support and privacy pages for Plainview, a Markdown reader for the Mac. Plain HTML and
one stylesheet (shared with the other apps at victorshammas.com), with no build step, external fonts,
scripts or trackers. The app's source lives in the private repo `victor-shammas/plainview-app`.

Plainview is on the [Mac App Store](https://apps.apple.com/app/plainview-markdown-reader/id6818242560?mt=12).

| File | Published URL |
|---|---|
| `index.html` | https://victorshammas.com/plainview/ |
| `support.html` | https://victorshammas.com/plainview/support.html (Support URL; the app's Help menu opens it) |
| `privacy.html` | https://victorshammas.com/plainview/privacy.html (Privacy Policy URL) |
| `style.css`, `icon.png`, `favicon.png`, `apple-touch-icon.png` | assets |
| `.nojekyll` | tells Pages to serve files as-is |

Keep these paths stable: the app links to `support.html`, and App Store Connect to the support and privacy pages.

## How the URL works

The user site (`victor-shammas.github.io`) has the custom domain `victorshammas.com`, so every public
project repo with Pages turned on is served at `https://victorshammas.com/<repo-name>/`. This repo must be
named `plainview` and needs no `CNAME` file. Pages: Settings › Pages › Deploy from a branch › `main`, `/ (root)`.

## App bar

Every page ends with the shared app bar, one tile per app. When an app is added or a tagline changes,
update the app bar on every page of every app site, and the cards at https://victorshammas.com/apps/.

## History

Until 2026-11-15 this repo also held the app's source (MIT) and GitHub releases with a free download.
The source moved to the private repo, and the Mac App Store is the only way to get the app.
