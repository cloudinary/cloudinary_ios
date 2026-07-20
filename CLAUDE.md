@AGENTS.md

# CLAUDE.md — cloudinary_ios

## What this repo is

Official native iOS client SDK (`Cloudinary` pod / SPM package) for Cloudinary — on-device upload, `CLDTransformation`-based delivery URL building, and image download with memory/disk cache, in Swift or Objective-C.

## Key constraints / gotchas

- **Never put `API_SECRET` in the app.** Client configuration is `cloudName` + `apiKey` only. Signed uploads and Admin API calls belong on a backend. `CLOUDINARY_URL` with a secret is for *test* configuration only.
- **Minimum iOS 9.0, Swift 5.0.** SDK 3.0+ dropped iOS 8; don't raise the deployment floor without intent.
- **Library source in `Cloudinary/`; tests and demo in `Example/`.** Add new tests under `Example/Tests/` — keep Swift + Objective-C parity.
- **All public types are prefixed `CLD`** (`CLDCloudinary`, `CLDConfiguration`, `CLDTransformation`, …). Follow the prefix for any new public API.
- **No `upload(file:)`.** Real labels: `upload(url:uploadPreset:)` / `upload(data:uploadPreset:)` (unsigned) and `signedUpload(url:)` / `signedUpload(data:)` (signed). For large files: `uploadLarge` / `signedUploadLarge`.
- **Enum cases are lowercase/camelCase**, not capitalized. Use `.fill`, `.fit`, `.face`, `.northWest` — not `.Fill`, `.NorthWest`.
- **`setTransformation` requires a `CLDTransformation` argument** — there is no zero-argument overload.
- **CI is Travis** (`.travis.yml`), not GitHub Actions. It builds only the `Example/Cloudinary.xcworkspace` (`travis_public_scheme`). SwiftPM builds are not CI-verified.
- **No lint config.** No SwiftLint or SwiftFormat in the tree. Match surrounding style by hand.

## Build / test commands

```bash
# Install Example workspace deps
pod install --project-directory=Example

# Run full test suite (requires live Cloudinary account)
export CLOUDINARY_URL="cloudinary://<api_key>:<api_secret>@<cloud_name>"
xcodebuild test \
  -workspace Example/Cloudinary.xcworkspace \
  -scheme travis_public_scheme \
  -destination 'platform=iOS Simulator,OS=15.2,name=iPhone 8'

# Run a single test class
xcodebuild test \
  -workspace Example/Cloudinary.xcworkspace \
  -scheme travis_public_scheme \
  -destination 'platform=iOS Simulator,OS=15.2,name=iPhone 8' \
  -only-testing:Cloudinary_Tests/CLDConditionExpressionTests

# SwiftPM build (not CI-verified — check locally when touching Package.swift)
swift build
```
