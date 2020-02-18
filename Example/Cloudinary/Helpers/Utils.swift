//
//  Utils.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 29/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit
import Photos

class Utils {
    static func getImage(relativePath: String) -> UIImage? {

        var image: UIImage?

        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL = NSURL(fileURLWithPath: documentDirectory)
        let localPath = photoURL.appendingPathComponent(relativePath)
        let path: String! = localPath?.path

        if FileManager.default.fileExists(atPath: path) {
            if let newImage = UIImage(contentsOfFile: path) {
                image = newImage
            } else {
                print("getImage() [Warning: file exists at \(String(describing: path)) :: Unable to create image]")
            }

        } else {
            print("getImage() [Warning: file does not exist at \(String(describing: path))]")
        }

        return image
    }

    static func saveImageUrl(imageUrl: URL, contentType: String, completionHandler: @escaping (URL?, String?) -> ()) {
        let allResources = PHAsset.fetchAssets(withALAssetURLs: [imageUrl], options: nil)

        if (allResources.count > 0) {
            let resource = allResources[0]
            var name: String?
            let resources = PHAssetResource.assetResources(for: resource)
            name = resources.first?.originalFilename ?? String(Date().timeIntervalSince1970)
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let resURL = NSURL(fileURLWithPath: documentDirectory)
            let localPath = resURL.appendingPathComponent(name!)

            if (contentType.contains("movie")) {
                let asset = AVAsset(url: imageUrl)
                let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
                session?.outputURL = localPath
                session?.outputFileType = AVFileType.mov
                session?.exportAsynchronously() {
                    completionHandler(localPath, name)
                }
            } else {
                PHImageManager.default().requestImageData(for: resource, options: nil) { (imageData, dataURI, orientation, info) -> Void in
                    do {
                        try imageData?.write(to: localPath!, options: Data.WritingOptions.atomic)
                        completionHandler(localPath, name)
                    } catch {
                        completionHandler(nil, nil)
                    }
                }
            }
        }
    }

    static func saveImage(name: String, image: UIImage) -> Data? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL = NSURL(fileURLWithPath: documentDirectory)
        let localPath = photoURL.appendingPathComponent(name)

        let data = image.jpegData(compressionQuality: 1.0)

        do {
            try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
        } catch {
            // Catch exception here and act accordingly
        }

        return data
    }
}
