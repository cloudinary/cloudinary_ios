<!--
  AGENTS.md for cloudinary/cloudinary_ios — for AI coding agents working IN this repo.
  Human "what is this" content stays in README.md. Keep under ~10 KB.
-->

# AGENTS.md — cloudinary_ios

## What this package is (one line)
Official Cloudinary native iOS client SDK (`Cloudinary`): on-device upload (signed/unsigned), delivery + transformation URL building with `CLDTransformation`, and image download with memory/disk caching — in Swift or Objective-C.

## When to use this / when NOT to use this
- **Use this when:** you are building a native iOS app (Swift or Objective-C) and need to upload media from the device, build delivery/transformation URLs, or download and cache images on-device.
- **Do NOT use this when:** you are building a cross-platform React Native app (use [cloudinary-react-native](https://github.com/cloudinary/cloudinary-react-native)); OR you need server-side work — signed uploads from a server, the Admin API, or anything touching `API_SECRET` (use a backend SDK such as [cloudinary_npm](https://github.com/cloudinary/cloudinary_npm)). A secret must never ship inside an app binary.
- **Sibling packages:** `cloudinary_android` = the same SDK for native Android; `cloudinary-react-native` = React Native (iOS + Android); `cloudinary-ios-sample-app` = a complete runnable example app (learn from it, don't depend on it). This repo's own runnable demo lives in `Example/`.

## Setup
This SDK is consumed as a dependency. Pick one:

```ruby
# CocoaPods — in your Podfile
platform :ios, '9.0'
use_frameworks!
target 'MyApp' do
  pod 'Cloudinary', '~> 5.0'
end
```
```
# Swift Package Manager — Xcode > File > Add Packages...
https://github.com/cloudinary/cloudinary_ios.git   (Up to Next Major, 5.0.0)
```
```
# Carthage — in your Cartfile
github "cloudinary/cloudinary_ios" ~> 5.0
# then: carthage update --use-xcframeworks
```

Required configuration: a `cloudName` and `apiKey` only (client-side). No `API_SECRET`.

## Minimal runnable example
```swift
import Cloudinary

let config = CLDConfiguration(cloudName: "CLOUD_NAME", apiKey: "API_KEY")
let cloudinary = CLDCloudinary(configuration: config)

// Build a delivery URL
let t = CLDTransformation().setWidth(100).setHeight(150).setCrop(.fill)
let url = cloudinary.createUrl().setTransformation(t).generate("sample.jpg")
// http://res.cloudinary.com/CLOUD_NAME/image/upload/c_fill,h_150,w_100/sample.jpg

// Unsigned upload via an upload preset (no secret needed).
// CLDUploader exposes upload(url:) and upload(data:) — there is no upload(file:).
cloudinary.createUploader().upload(url: fileUrl, uploadPreset: "sample_preset")
```

## Build / test commands (run these after editing)
There is no `xcodebuild` target at the repo root. The library source is built and exercised through the `Example/` project, which is what CI runs. Tests need a Cloudinary account.

```bash
# 1. Install the Example workspace deps (generates Example/Cloudinary.xcworkspace)
pod install --project-directory=Example

# 2. Tests require a live account — set this before running them
export CLOUDINARY_URL="cloudinary://<api_key>:<api_secret>@<cloud_name>"

# 3. Build + run the test suite (mirrors CI; pick an installed simulator/OS)
xcodebuild test \
  -workspace Example/Cloudinary.xcworkspace \
  -scheme travis_public_scheme \
  -destination 'platform=iOS Simulator,OS=15.2,name=iPhone 8'
```
To run a **single** test class or method, append `-only-testing:` (target/class/method):

```bash
xcodebuild test \
  -workspace Example/Cloudinary.xcworkspace \
  -scheme travis_public_scheme \
  -destination 'platform=iOS Simulator,OS=15.2,name=iPhone 8' \
  -only-testing:Cloudinary_Tests/CLDConditionExpressionTests
```

SwiftPM consumers can also build the library directly: `swift build`. Note that CI does **not** exercise SwiftPM — it builds only the `Example/Cloudinary.xcworkspace` (`travis_public_scheme`) — so verify `swift build` locally if you touch `Package.swift` or its sources.

No lint step is configured in this repo — there is no SwiftLint or SwiftFormat config in the tree, and CI runs none. Match the surrounding code style by hand.

## Conventions & gotchas
- **Never put `API_SECRET` in the app.** Configure with `cloudName` + `apiKey` and use unsigned uploads (upload presets). Signed uploads and Admin API calls belong on a backend. The `cloudinary://key:secret@cloud` form and `CLOUDINARY_URL` env var exist for *test* configuration only — don't bake a secret into a shipped binary.
- **Minimum deployment target is iOS 9.0; Swift version 5.0** (from `Cloudinary.podspec` and `Package.swift`). Don't raise the floor or use APIs unavailable at iOS 9 without intent. SDK 3.0+ dropped iOS 8.
- **Library source lives under `Cloudinary/`; tests and the demo app live under `Example/`.** Add new tests under `Example/Tests/...` (mirror the existing folders, e.g. `NetworkTests`, `TransformationTests`). There are paired Swift + Objective-C tests (`*.swift` and `*.m`) — keep the Objective-C interop surface working.
- **All public types are prefixed `CLD`** (`CLDCloudinary`, `CLDConfiguration`, `CLDTransformation`, `CLDUploadRequestParams`, …). Follow that prefix for new public API.
- **CI is Travis** (`.travis.yml`), not GitHub Actions — it runs the `Example` workspace `travis_public_scheme` across several Xcode/iOS-simulator combos and injects `CLOUDINARY_URL`. Network tests fail without a configured account.

## Canonical docs (leave the repo for depth)
- iOS SDK guide: https://cloudinary.com/documentation/ios_integration
- Image/video upload: https://cloudinary.com/documentation/ios_image_and_video_upload
- Transformation & API references: https://cloudinary.com/documentation/cloudinary_references
- MCP server (agent/no-code path): https://github.com/cloudinary/mcp-servers

## Agent / MCP note
If a task is exposed via the Cloudinary MCP servers, prefer the MCP tool for autonomous task execution and use this SDK for code generation inside an iOS app. See cloudinary/mcp-servers.

## Commit / PR conventions
- Open PRs against the default branch; keep Swift + Objective-C test parity green.
- Add or update tests under `Example/Tests/` for any behavior change; CI must pass on the `Example` workspace.
- There is no `CONTRIBUTING.md` in this repo, but `.github/` provides an issue template and a `pull_request_template.md` — fill the PR template out. No commit-message convention (e.g. Conventional Commits) is configured or enforced.
