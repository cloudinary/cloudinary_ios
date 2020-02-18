//
//  UIView+Cloudinary.swift
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

internal extension UIView {    
    func fetchImageForUIElement(_ url: String, placeholder: UIImage?, cloudinary: CLDCloudinary, fetchedImageHandler: @escaping ((_ fetchedImage: UIImage) -> ())) {
        if let placeholder = placeholder {
            fetchedImageHandler(placeholder)
        }
        
        DispatchQueue.main.async {
            self.setInProgressUrl(url)
        }
        
        cloudinary.createDownloader().fetchImage(url) { [weak self] (responseImage, error) in
            if let img = responseImage {
                DispatchQueue.main.async {
                    if let view = self, view.isUrlStillRelevant(url) {
                        fetchedImageHandler(img)
                    }
                }
            }
        }
    }
    
    // set a url as the current request url for this view, if possible
    func setInProgressUrl(_ url: String?){
        // The associated propery `cldCurrentUrl` is only available on UIImageViews.
        if let imageView = self as? UIImageView {
            imageView.cldCurrentUrl = url
        }
    }
    
    // check whether the url is in sync with the last request url on this view, if possible
    func isUrlStillRelevant(_ url: String) -> Bool {
        // The associated property `cldCurrentUrl` is only available on UIImageViews,
        // we do not store the url for other UIViews
        if let imageView = self as? UIImageView, let lastRequestUrl = imageView.cldCurrentUrl {
            return url == lastRequestUrl
        }
        
        return true
    }
}
