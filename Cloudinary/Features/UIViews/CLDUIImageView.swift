//
//  CLDUIImageView.swift
//  Cloudinary
//
//  Created by Nitzan Jaitman on 23/01/2018.
//  Copyright © 2018 Cloudinary. All rights reserved.
//

import UIKit

@objc open class CLDUIImageView: UIImageView {
    let responsiveHelper: CLDResponsiveViewHelper = CLDResponsiveViewHelper()

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
        responsiveHelper.cldSetImage (view: self, publicId: publicId, cloudinary: cloudinary, signUrl: signUrl, resourceType: resourceType,
                                      responsiveParams: responsiveParams, transformation : transformation, placeholder: placeholder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        responsiveHelper.onViewSizeKnown(view: self)
    }
}
