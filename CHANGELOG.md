# Changelog

Entries up to and including 2.0.0 were reconstructed on 2026-10-09 from the
git history, tags and GitHub release notes. Versions before 2.0.0 were
released as MDView.

## 2.0.0 — 2026-10-09 (GitHub release; App Store pending)

The first release as Plainview and the first for the Mac App Store. Version
set on 2026-10-01; build 2 was the first upload to App Store Connect, and the
build 3 was rejected (blank Settings window, no way to reopen a closed
window), and build 4 fixes both. Tagged `v2.0.0` and released on GitHub with a
signed, notarized app: build 3 at first, replaced by build 4 the same day.

- Renamed from MDView to Plainview (a Markdown reader called MDView was
  already on the Mac App Store): app, Xcode project, targets, scheme, Swift
  package, `install.sh`, and the bundle ID, now
  `com.victorshammas.plainview`.
- New icon: an amber ".md" in Figtree Black on an espresso squircle, drawn on
  Apple's icon grid by `make_icon.swift`.
- App Store preparation: privacy manifest (no tracking or collected data;
  UserDefaults reason CA92.1), missing Info.plist keys, signing with the
  Apple Developer team, and handler ranks (Default for Markdown, Alternate
  for plain text, so Plainview appears in Open With for `.txt` without
  competing with TextEdit).
- Plainview's commands now sit in the standard View menu instead of a second
  View menu.
- Plainview › Settings holds the reading preferences: font, text size, line
  width, justification and appearance (Match System, Light or Dark).
- File › New Window (Cmd+N) opens an empty window, so a window can be
  brought back after the last one is closed.
- Help › Plainview Help (Cmd+?) opens the support page on the website.
- Checklist boxes stay on the same line as their text.
- Website at https://victorshammas.com/plainview/ (home, support, privacy),
  served from `docs/`, with an app bar linking Gaugeline, Quoth and Staple.

## 1.2.0 — 2026-10-01

GitHub release "MDView v1.2.0", source only.

- Quick Look extension: press Space on a Markdown file in Finder to see it
  rendered, in light or dark mode.
- File › Export as PDF, with clickable web, email and heading links.
- Live reload when the file changes on disk, keeping the scroll position.
- Links to headings (`[Setup](#setup)`) work, using GitHub's anchor names.
- File › Page Setup; printing uses the chosen paper size, breaks pages
  between lines, keeps headings with their text and wraps long code lines.
  Printouts are laid out in a hidden web view, so the window no longer jumps.
- Fixed: long documents printed mostly blank pages; text cut off at the
  right margin; printed text off-center; duplicate hidden text in PDFs.
- A window opens at launch; new windows have a reading-friendly size,
  remember the last size and cascade. Unreadable files show an error.
- Older encodings (UTF-16, Windows-1252, Latin-1) are detected; `.mdown` and
  `.mkd` files can be dropped onto a window.
- Recently Read follows moved or renamed files and drops missing ones.
- Security: raw HTML can no longer run scripts, redirect the window or point
  images elsewhere (Content-Security-Policy, navigation limited to the page);
  links to apps or scripts are revealed in Finder instead of opened.
- Runs in the App Sandbox; images next to a document load after a one-time
  permission for their folder.
- New Xcode project with the app and the Quick Look extension; `install.sh`
  still builds the app without Quick Look.
- Requires macOS 14 (was macOS 12).

## 1.1.1 — 2026-05-31

GitHub release "MDView v1.1.1", with `MDView-v1.1.1.zip`.

- Find works on large files: faster highlighting, capped at 10,000 matches.
- Searches typed while a large file is still loading run once it has loaded,
  instead of reporting "No matches".

## 1.1.0 — 2026-05-23

First public release, GitHub release "MDView v1.1.0", with
`MDView-v1.1.0.zip` (universal binary, macOS 12+). The app bundle in this
build still reported version 1.0.

- Markdown viewer: open files with File › Open, drag and drop or Finder; a
  window per file; Recently Read list.
- Five typefaces, zoom, line width, justified text, dark mode toggle.
- Find in document.
- Print and Save as PDF (Cmd+P) with page breaks between blocks, always in
  light colors.
