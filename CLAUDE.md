# Plainview (macOS app)

Plainview is a Markdown reader for macOS, not an editor: it opens `.md`,
`.markdown`, `.mdown`, `.mkd` and `.txt` files in a clean window, with a
Quick Look extension for Finder. Native Swift (SwiftUI + AppKit + WKWebView),
macOS 14+, one dependency (apple/swift-markdown), sandboxed, MIT licensed.
Until 2.0 it was called MDView (the repo was renamed from
`victor-shammas/mdview`; old URLs redirect). It is headed for the Mac App
Store; the 1.x versions shipped as GitHub releases.

## Layout

- `Sources/App.swift` — `PlainviewApp` (`@main`, menus and shortcuts),
  `DocumentState` (per-window document, file watching for live reload,
  find), `AppState` (preferences and Recently Read in `UserDefaults`,
  security-scoped bookmarks, folder grants), `AppDelegate` (NSWindows, open,
  print, Export as PDF)
- `Sources/ContentView.swift` — window content: `FindBar`, `FolderAccessBar`
  (the "allow access to this folder" bar for images), `ContentView`
- `Sources/MarkdownWebView.swift` — the WKWebView: page loading, injected find
  script (`FIND_CAP` 10000), navigation policy (only http/https/mailto open;
  Markdown links open in Plainview; other local files are revealed in Finder)
- `Sources/FileAccess.swift` — security-scoped bookmark helpers and
  `LocalFileSchemeHandler` (`plainview-file:` scheme that serves images next
  to a document under the sandbox)
- `Sources/PrintRenderer.swift` — print and PDF export: lays the document out
  in an offscreen web view at paper width, captures one PDF page per sheet,
  keeps links clickable
- `Sources/Shared/` — shared with the Quick Look extension:
  `HTMLConverter.swift` (swift-markdown → HTML, GitHub-style heading
  anchors), `MarkdownFile.swift` (extensions, encoding fallback),
  `PageStyle.swift` (fonts, appearance, alignment), `PageTemplate.swift`
  (page CSS and the Content-Security-Policy)
- `QuickLook/` — `PreviewProvider.swift` (data-based HTML preview),
  `Info.plist` (Markdown only, `net.daringfireball.markdown`),
  `QuickLook.entitlements`
- `Support/Plainview.xcconfig` — name, bundle ID, version, build number,
  deployment target, signing team. Read by both the Xcode project and
  `install.sh`
- `Support/Info.plist`, `Support/Plainview.entitlements`,
  `Support/PrivacyInfo.xcprivacy`, `Support/Assets.xcassets` (app icon)
- `Plainview.xcodeproj` — targets `Plainview` (app) and `PlainviewQuickLook`
  (app extension, embedded in the app); shared scheme `Plainview`
- `Package.swift` — SwiftPM executable `plainview` built from `Sources/`
  (no Quick Look)
- `install.sh` — SwiftPM universal build packaged as an app bundle
- `make_icon.swift` — draws the icon; `IconSource/` holds Figtree (OFL), used
  only for the icon; outputs are `AppIcon.iconset/`, `AppIcon.icns`,
  `Support/Assets.xcassets/AppIcon.appiconset/`
- `screenshot.png` — README screenshot (also the first App Store screenshot)
- `docs/` — the website (see below)

## Build and run

- **Xcode** (the full app with Quick Look): open `Plainview.xcodeproj`, run the
  `Plainview` scheme. From the command line:

      xcodebuild -project Plainview.xcodeproj -scheme Plainview -configuration Debug build

  `xcodebuild` needs full Xcode; on a Mac with only the Command Line Tools,
  use SwiftPM instead.
- **SwiftPM** (debug, current architecture, no Quick Look):

      swift build
      .build/debug/plainview

- **Install locally**: `./install.sh` builds arm64 and x86_64 release
  binaries, joins them with `lipo`, writes `Plainview.app` to `/Applications`
  (or the folder given, e.g. `./install.sh ~/Applications`), fills
  `Support/Info.plist` from the xcconfig with `sed`, copies `AppIcon.icns`,
  and signs ad hoc with the app's sandbox entitlements. It deletes any
  existing `Plainview.app` at the destination first.
- **Icon**: `swift make_icon.swift` from the repo root.
- The Xcode project uses synchronized folders: a new file in `Sources/` joins
  the `Plainview` target automatically. A new file in `Sources/Shared/` must
  also be added to the `PlainviewQuickLook` target (its membership list in
  `project.pbxproj`), or the extension won't build. SwiftPM compiles
  everything under `Sources/`, so keep the app code buildable without Xcode.

## Testing

There are no test targets (the scheme's Test action is empty; `Package.swift`
has no test target). Changes have been verified by hand in the running app:
long documents for printing and PDF export (an 82-page document is the
reference case in history), large files for Find, raw-HTML documents against
a local server for the security rules, and Quick Look in Finder (Quick Look
only exists in the Xcode build). Check light and dark mode for visual
changes.

## Signing, sandbox, privacy

- Signing: `CODE_SIGN_STYLE = Automatic`, `DEVELOPMENT_TEAM = JPP8RN6BJB` in
  the xcconfig; Xcode manages certificates and profiles. The repo is public:
  never commit certificates, keys or profiles (`.gitignore` blocks `*.p12`,
  `*.p8`, `*.cer`, `*.mobileprovision`, `*.provisionprofile`).
- Bundle IDs: `com.victorshammas.plainview`, extension
  `com.victorshammas.plainview.QuickLook`. Hardened runtime on both targets.
- App entitlements (`Support/Plainview.entitlements`): app sandbox,
  user-selected read-write (write for Save as PDF), app-scope bookmarks
  (Recently Read and image-folder grants), network client (remote images),
  print. The extension has the sandbox only.
- `Info.plist`: Markdown types with `LSHandlerRank` Default, plain text with
  Alternate (so Plainview doesn't compete with TextEdit);
  `ITSAppUsesNonExemptEncryption` false; category Productivity.
- `PrivacyInfo.xcprivacy`: no tracking, no collected data, UserDefaults access
  with reason `CA92.1`. Keep it, `docs/privacy.html` and the README's Privacy
  section consistent.
- Documents can contain raw HTML, so the page allows no scripts (CSP in
  `PageTemplate.swift`). App JavaScript goes in as a `WKUserScript`, never as
  inline `<script>`. Don't loosen the CSP or the navigation policy.

## Distribution

- **Mac App Store**: version 2.0.0 is the first App Store release; builds go up
  from Xcode (Archive → Organizer → App Store Connect). The website's App
  Store button (commented out in `docs/index.html`) points to app id
  `6818242560` at $1.99. There is no App Store metadata folder in this repo.
- **GitHub releases** on this repo: `v1.1.0` and `v1.1.1` attached a zipped
  `MDView.app`; `v1.2.0` was source only. No GitHub Actions, no Sparkle, no
  DMG or notarization scripts.
- Steps: `RELEASING.md`. History: `CHANGELOG.md`.

## Website (`docs/`)

Static HTML/CSS served by GitHub Pages from `main` `/docs` at
https://victorshammas.com/plainview/ (`.nojekyll`, no build step): `index.html`,
`support.html`, `privacy.html`, `style.css`, icons. Pushing to `main`
publishes it.

It shares its design with the sister sites, each in its own repo:
Gaugeline (`victor-shammas/gaugeline`, repo root), Quoth
(`victor-shammas/quoth`, `docs/`) and Staple (`victor-shammas/staple`, repo
root). Every page ends with the same app bar (`<section class="app-bar">`,
styles at the end of `style.css`): one tile per app with icon, name and a
line, the current one marked `current` with "You're here". When an app is
added or a tagline changes, update the app bar on every page of all four
sites. Icons in the bar load from each site's absolute URL.

## Conventions

- Plain, concrete, unhyped prose in UI, docs and the site; no emoji.
- Wording: a Markdown *reader*, "for reading, not editing".
- Contact: contact+plainview@victorshammas.com.
- Commits: imperative subject; body explains why and what changed; site-only
  commits prefixed `Website:` or `App bar:`; version bumps as
  "Bump version to X.Y.Z"; mention a new build number in the message
  ("Build 3"). Commits end with a `Co-Authored-By:` line.
- Version and build number live only in `Support/Plainview.xcconfig`; never
  hard-code them in the plists.
- Releases: follow `RELEASING.md`; add an entry to `CHANGELOG.md`.
