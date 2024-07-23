//
//  SingleUploadCell.swift
//  Cloudinary_Example
//
//  Created by Adi Mizrahi on 18/07/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//


import Foundation
import UIKit
import Cloudinary
class SingleUploadCell: UICollectionViewCell {
    @IBOutlet weak var ivMain: CLDUIImageView!
    
    func setImage(_ url: String, _ cloudinary: CLDCloudinary) {
        var urlString = url
        if urlString.contains("video") {
            urlString = replaceExtension(urlString: urlString) ?? ""
            ivMain.cldSetImage(urlString, cloudinary: cloudinary)
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let publicId = url.lastPathComponent
        ivMain.cldSetImage(publicId: publicId, cloudinary: cloudinary, transformation: CLDTransformation().setCrop("thumb"))
    }

    func replaceExtension(urlString: String) -> String? {
        guard let url = URL(string: urlString) else {
            return nil // Invalid URL
        }
        
        // Get the last path component
        let lastComponent = url.lastPathComponent

        // Get the path extension
        let pathExtension = (lastComponent as NSString).pathExtension

        // Replace the path extension with ".jpg"
        let newLastPathComponent = (lastComponent as NSString).deletingPathExtension + ".jpg"

        // Create a new URL instance with the updated path component
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.path = urlComponents.path.replacingOccurrences(of: lastComponent, with: newLastPathComponent)

            // Get the updated URL string
            if let updatedURLString = urlComponents.string {
                return updatedURLString
            }
        }
        
        return urlString // Return original URL if there's any failure in updating the URL string
    }
}
