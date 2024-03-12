## Introduction
This is a very simple application that integrates the [Cloudinary iOS SDK](https://github.com/cloudinary/cloudinary_ios).
The application has the following samples:
1. Delivery
  1. Optimization
  2. Transform
  3. Use cases
2. Upload
   1. Upload
   2. Upload large
   3. Fetch upload
3. UI
   1. Upload Widget
   2. Image Widget
4. Video
    1. Video Widget
    2. Video feed

## Installation
To use the sample project please go to the Example directory and run the following command:

```bash
pod install
```

## Configuration
Once you clone this repository there are two required steps to build the sample app:
1. Configure your Cloudinary cloud name for the app:
    * Once you open the upload controller you'll be asked to enter your cloud name, you can find your cloud name at the top of your [dashboard.](https://console.cloudinary.com/pm/developer-dashboard)
2. Create an upload preset named 'ios_sample' in your cloudinary account console:
    *  Login to your [Cloudinary console](https://cloudinary.com/console), go to settings>upload, scroll down
      to Upload Presets and click `Add upload preset`. Alternatively, head directly to the [new preset page](https://console.cloudinary.com/console/upload_presets/new).
    * Type in `ios_sample` as the name and save, leaving all the fields with their default values.
