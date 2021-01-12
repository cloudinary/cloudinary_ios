//
//  CLDWidgetAssetContainer.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import AVKit

class CLDWidgetAssetContainer: NSObject {
    
    enum AssetType: Int {
        case image
        case video
    }
    
    private(set) var originalImage    : UIImage?
                 var editedImage      : UIImage?
    private(set) var originalVideo    : AVPlayerItem?
                 var presentationImage: UIImage
                 
    private(set) var assetType        : AssetType
    
    init(originalImage: UIImage, editedImage: UIImage) {
        
        self.originalImage     = originalImage
        self.editedImage       = editedImage
        self.presentationImage = editedImage
        assetType = .image
        
        super.init()
    }
    
    init(videoUrl: URL) {
        
        let playerItem = AVPlayerItem(url: videoUrl)
        self.originalVideo = playerItem
        self.presentationImage = CLDWidgetAssetContainer.createThumbnailForVideo(playerItem: self.originalVideo)
        
        assetType = .video
        
        super.init()
    }
    
    init(videoItem: AVPlayerItem) {
        
        self.originalVideo = videoItem
        self.presentationImage = CLDWidgetAssetContainer.createThumbnailForVideo(playerItem: self.originalVideo)
        
        assetType = .video
        
        super.init()
    }
    
    private static func createThumbnailForVideo(playerItem: AVPlayerItem?) -> UIImage {
        
        if let urlAsset = playerItem?.asset as? AVURLAsset {
            
            let url = urlAsset.url
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                return UIImage(cgImage: cgThumbImage)
            } catch {
                print(error.localizedDescription)
                return UIImage()
            }
        }
        else {
            return UIImage()
        }
    }
}
