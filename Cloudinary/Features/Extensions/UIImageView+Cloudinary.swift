//
//  UIImageView+Cloudinary.swift
//
//  Copyright (c) 2016 Cloudinary (http://cloudinary.com)
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

import Foundation

public extension UIImageView {
    
    /**
     Download an image asynchronously from the specified URL and set it to the UIImageView's image.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
     
     - parameter url:               The image URL to download.
     - parameter cloudinary:        An instance of CLDCloudinary.
     - parameter placeholder:       A placeholder image to be set as the background image untill the asynchronus download request finishes.
     
     */
    @objc public func cldSetImage(_ url: String, cloudinary: CLDCloudinary, placeholder: UIImage? = nil) {
        fetchImageForUIElement(url, placeholder: placeholder, cloudinary: cloudinary) { [weak self] (image: UIImage) in
            self?.image = image
        }
    }
    
    /**
     Download an image asynchronously from the specified URL and set it to the UIImageView's image.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
     
     - parameter publicId:          The remote asset's name (e.g. the public id of an uploaded image).
     - parameter cloudinary:        An instance of CLDCloudinary.
     - parameter signUrl:           A boolean parameter indicating whether or not to generate a signature out of the API secret and add it to the generated URL. Default is false.
     - parameter resourceType       The resource type of the image to download (can be useful to display video frames for thumbnails).
     - parameter transformation:    An instance of CLDTransformation.
     - parameter placeholder:       A placeholder image to be set as the background image until the asynchronus download request finishes.
     
     */
    @objc public func cldSetImage(publicId: String, cloudinary: CLDCloudinary, signUrl: Bool = false, resourceType:CLDUrlResourceType = CLDUrlResourceType.image, transformation: CLDTransformation? = nil, placeholder: UIImage? = nil) {
        
        let urlGen = cloudinary.createUrl()
        
        if let transformation = transformation {
            urlGen.setTransformation(transformation)
        }
        
        guard let url = urlGen.setResourceType(resourceType).generate(publicId, signUrl: signUrl) else {
            if let placeholder = placeholder {
                DispatchQueue.main.async { [weak self] in
                    self?.image = placeholder
                }
            }
            
            return
        }

        fetchImageForUIElement(url, placeholder: placeholder, cloudinary: cloudinary) { [weak self] (image: UIImage) in
            self?.image = image
        }
    }
    
    /**
     Static var used to generate a unique address for the associated object
     */
    private struct AssociatedKeys {
        static var cldCurrentUrl = "cldCurrentUrl"
    }
    
    /**
     Add an associated object to UIImageView so we can track the current url 'attached' to the image view.
     This is important in case the view is used in an collection adapter where views are recycled, to verify
     that when the async download finishes the associated url hasn't changed
    */
    internal var cldCurrentUrl:String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cldCurrentUrl) as? String
        }
        set {
            objc_setAssociatedObject(self,  &AssociatedKeys.cldCurrentUrl, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
