//
//  CLDUIImageView.swift
//
//  Copyright (c) 2018 Cloudinary (http://cloudinary.com)
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

@objc open class CLDUIImageView: UIImageView {
    // Delegate most of the logic to a helper instance. To use responsive downloads in situations
    // where one cannot use CLDUIImageView a CLDResponsiveViewHelper can be used in any other custom UIVIew
    // as long as these two methods are used.
    internal let responsiveHelper: CLDResponsiveViewHelper = CLDResponsiveViewHelper()

    /**
     Download an image asynchronously from the specified URL and set it to the UIImageView's image.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached. Note: this must be used on the main thread.
     
     - parameter publicId:          The remote asset's name (e.g. the public id of an uploaded image).
     - parameter cloudinary:        An instance of CLDCloudinary.
     - parameter signUrl:           A boolean parameter indicating whether or not to generate a signature out of the API secret and add it to the generated URL. Default is false.
     - parameter resourceType       The resource type of the image to download (can be useful to display video frames for thumbnails).
     - parameter responsive         An instance of CLDResponsiveParams to configure fetching a pre-scaled image to fit in the UIImageView.
     - parameter transformation:    An instance of CLDTransformation.
     - parameter placeholder:       A placeholder image to be set as the background image until the asynchronus download request finishes.
     
     */
    @objc public func cldSetImage(publicId: String, cloudinary: CLDCloudinary, signUrl: Bool = false, resourceType: CLDUrlResourceType = CLDUrlResourceType.image,
                                  responsiveParams: CLDResponsiveParams, transformation: CLDTransformation? = nil, placeholder: UIImage? = nil) {

        responsiveHelper.cldSetImage (view: self, publicId: publicId, cloudinary: cloudinary, signUrl: signUrl, resourceType: resourceType, responsiveParams: responsiveParams, transformation : transformation, placeholder: placeholder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        // notify the delegate that the view now knows it's own size
        responsiveHelper.onViewSizeKnown(view: self)
    }
}
