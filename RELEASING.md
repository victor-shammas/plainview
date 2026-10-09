# Releasing Plainview

Plainview ships through two channels from this repo:

- **Mac App Store**: the main channel from 2.0.0 on (paid, $1.99 per the
  website). Builds are archived and uploaded from Xcode.
- **GitHub release** on `victor-shammas/plainview`, tagged `vX.Y.Z`, for the
  source and release notes. The 1.x releases were titled "MDView vX.Y.Z";
  1.1.0 and 1.1.1 attached a zipped app, 1.2.0 was source only.

The website (`docs/`, GitHub Pages) is updated from this repo too.

## Checklist

1. **Version.** In `Support/Plainview.xcconfig`, set `MARKETING_VERSION`
   (semver: fixes → patch, features → minor) and increase
   `CURRENT_PROJECT_VERSION` (the build number; it must go up with every App
   Store Connect upload, including a re-upload of the same version). Both
   `Info.plist` files and `install.sh` read these; don't edit version strings
   anywhere else. Commit as "Bump version to X.Y.Z".
2. **Changelog.** Add an entry at the top of `CHANGELOG.md`.
3. **Test.** Run the `Plainview` scheme in Xcode and check: open a file from
   Finder, the Open panel and by drag and drop; Quick Look (Space in Finder);
   live reload after saving in an editor; Find; light and dark mode; an image
   next to a document (the folder-access bar); Print and File › Export as PDF
   on a long document (no blank pages, clickable links). Also run
   `swift build`, so the SwiftPM build still compiles.
4. **Archive and upload.** In Xcode, select the `Plainview` scheme and
   "Any Mac", Product › Archive (Release). In the Organizer, Distribute App →
   App Store Connect → Upload. Export compliance is already answered by
   `ITSAppUsesNonExemptEncryption` = false in `Support/Info.plist`.
5. **App Store Connect.** Create the new macOS version, select the uploaded
   build, fill in "What's New" from the changelog, and submit for review. If
   data handling changed, update the App Privacy answers and
   `Support/PrivacyInfo.xcprivacy` together.
   - TODO (author): where the listing text (description, keywords,
     promotional text) and the App Store screenshots are kept; there is no
     metadata folder in this repo.
   - TODO (author): manual or automatic release after approval.
6. **Tag this repo** on the release commit:

       git tag vX.Y.Z && git push --tags

   - TODO (author): tag at upload, or only once the App Store version is
     live.
7. **GitHub release:**

       gh release create vX.Y.Z --title "Plainview X.Y.Z" --notes "…what changed…"

   - TODO (author): attach a build or stay source only (as 1.2.0 did) now
     that the App Store version is paid. If attaching, note that
     `./install.sh <folder>` produces an ad-hoc-signed, non-notarized app
     without Quick Look, and that the repo has no script that zips or
     notarizes it (`release/` is git-ignored, but nothing in the repo writes
     there). How the 1.1.x zips were made is not recorded.
8. **Website** (`docs/`): update anything that changed (features on
   `index.html`, answers and shortcuts on `support.html`, `privacy.html` and
   its effective date if the policy changed). Keep the README's Features and
   Keyboard Shortcuts in step. Commit and push to `main`; GitHub Pages
   publishes https://victorshammas.com/plainview/.

## First App Store launch (2.0.0 only)

Once the app is live:

- In `docs/index.html`, replace the "Coming soon to the Mac App Store"
  `<span>` with the link in the comment above it
  (`https://apps.apple.com/app/id6818242560`, "Download on the Mac App
  Store"). The comment says "see README.md", but the README has no further
  instructions.
- In `README.md`, change "Plainview is coming to the Mac App Store" to say
  it is available, with the link.
- TODO (author): confirm the App Store id `6818242560` and the $1.99 price
  (both only appear in the HTML comment).

## If review is rejected

Fix the issue, increase `CURRENT_PROJECT_VERSION` (keep `MARKETING_VERSION`
unless the fix warrants a new version), archive and upload again, and select
the new build for the same version in App Store Connect.
