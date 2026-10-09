# Releasing Plainview

Plainview ships through two channels from this repo:

- **Mac App Store**: the main channel from 2.0.0 on (paid, $1.99 per the
  website). Builds are archived and uploaded with `xcodebuild` and an App
  Store Connect API key.
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
4. **Archive and upload.** Uploading from Xcode's Organizer with the Apple ID
   fails ("Actor/relationships/providerId"), so upload from the command line
   with an App Store Connect API key. The key needs the **Admin** role (cloud
   signing requires it); its `.p8` stays in `~/.appstoreconnect/private_keys/`
   and never goes in the repo.

       xcodebuild archive -project Plainview.xcodeproj -scheme Plainview -configuration Release \
         -archivePath build/Plainview.xcarchive -allowProvisioningUpdates
       # ExportOptions.plist: method app-store-connect, destination upload,
       # signingStyle automatic, teamID JPP8RN6BJB, uploadSymbols true
       xcodebuild -exportArchive -archivePath build/Plainview.xcarchive \
         -exportOptionsPlist ExportOptions.plist -exportPath build/export -allowProvisioningUpdates \
         -authenticationKeyPath ~/.appstoreconnect/private_keys/AuthKey_<KEY_ID>.p8 \
         -authenticationKeyID <KEY_ID> -authenticationKeyIssuerID <ISSUER_ID>

   Export compliance is already answered by
   `ITSAppUsesNonExemptEncryption` = false in `Support/Info.plist`.
5. **App Store Connect.** Create the new macOS version, select the uploaded
   build, fill in "What's New" from the changelog, and submit for review. If
   data handling changed, update the App Privacy answers and
   `Support/PrivacyInfo.xcprivacy` together.
   The listing text (description, keywords, promotional text), the
   screenshots and their tools are kept in `release/`, which is gitignored;
   there is no metadata folder in the public repo. Versions release
   automatically once approved.
6. **Tag this repo** on the release commit:

       git tag vX.Y.Z && git push --tags

   Tag when the GitHub release goes out (step 7); 2.0.0 was tagged before
   App Store approval.
7. **GitHub release:**

       gh release create vX.Y.Z --title "Plainview X.Y.Z" --notes "…what changed…"

   Publish a public GitHub release for every version, with a signed,
   notarized app attached (decided 2026-10-09; first done for 2.0.0). Build it
   with full Xcode (on a Mac where `xcode-select` points at the Command Line
   Tools, prefix the commands with
   `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`), signed in to
   the Apple account for team JPP8RN6BJB in Xcode › Settings › Accounts:

       xcodebuild -project Plainview.xcodeproj -scheme Plainview -configuration Release \
         -archivePath build/Plainview.xcarchive -allowProvisioningUpdates archive
       # ExportOptions.plist: method developer-id, destination upload,
       # signingStyle automatic, teamID JPP8RN6BJB
       xcodebuild -exportArchive -archivePath build/Plainview.xcarchive \
         -exportOptionsPlist ExportOptions.plist -exportPath build/export -allowProvisioningUpdates
       # repeat until Apple has notarized it (usually a minute or two):
       xcodebuild -exportNotarizedApp -archivePath build/Plainview.xcarchive -exportPath build/notarized
       spctl -a -vv -t exec build/notarized/Plainview.app   # expect "Notarized Developer ID"
       ditto -c -k --keepParent build/notarized/Plainview.app Plainview-X.Y.Z.zip
       gh release upload vX.Y.Z Plainview-X.Y.Z.zip

   Signing uses Apple's cloud-managed Developer ID certificate, so no
   certificate needs installing, and notarization uses the Xcode account, so
   no notarytool password is needed. Keep `build/` out of git. (`./install.sh`
   still builds a local, ad-hoc-signed copy without Quick Look; don't publish
   that.)
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
- The App Store id `6818242560` and the $1.99 price (US base) in that
  comment are confirmed.

## If review is rejected

Fix the issue, increase `CURRENT_PROJECT_VERSION` (keep `MARKETING_VERSION`
unless the fix warrants a new version), archive and upload again, and select
the new build for the same version in App Store Connect.
