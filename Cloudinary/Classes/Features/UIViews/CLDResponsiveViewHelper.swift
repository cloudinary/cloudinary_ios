//
//  CLDResponsiveViewHelper.swift
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

import Foundation
import UIKit

@objcMembers open class CLDResponsiveViewHelper : NSObject{
    fileprivate var requestedWidth = 0
    fileprivate var requestedHeight = 0
    fileprivate var viewSizeKnown = false
    
    fileprivate var publicId: String!
    fileprivate var cloudinary: CLDCloudinary!
    fileprivate var signUrl: Bool!
    fileprivate var resourceType:CLDUrlResourceType!
    fileprivate var responsiveParams : CLDResponsiveParams?
    fileprivate var baseTransformation: String?
    fileprivate var placeholder: UIImage?
    
    public func cldSetImage(view: UIImageView, publicId: String, cloudinary: CLDCloudinary, signUrl: Bool = false, resourceType: CLDUrlResourceType = CLDUrlResourceType.image,
                                  responsiveParams: CLDResponsiveParams, transformation: CLDTransformation? = nil, placeholder: UIImage? = nil) {
        self.publicId = publicId
        self.signUrl = signUrl
        self.cloudinary = cloudinary
        self.resourceType = resourceType
        self.responsiveParams = responsiveParams
        self.baseTransformation = transformation?.asString()
        self.placeholder = placeholder
        
        if (viewSizeKnown){
            doResponsive(view)
        }
    }
    
    open func onViewSizeKnown(view: UIImageView) {
        viewSizeKnown = true
        
        // if no one called cldSetImage we have nothing to do here
        if let params = responsiveParams {
            // We fetch an image in two cases: 1) This is the first time, or 2) The view got larger and the deverloper requested to reload the image on resize.
            if (requestedWidth == 0 && requestedHeight == 0) ||
                (params.shouldReloadOnSizeChange && didGetLarger(view)) {
                doResponsive(view)
            }
        }
    }
    
    fileprivate func didGetLarger(_ view: UIImageView) -> Bool {
        return getRoundedContentHeight(view) > requestedHeight || getRoundedContentWidth(view) > requestedWidth
    }
    
    fileprivate func doResponsive(_ view: UIImageView){
        let transformation = self.chainResponsiveTransformation(view)
        view.cldSetImage(publicId: publicId, cloudinary: cloudinary, signUrl: signUrl, resourceType: resourceType, transformation: transformation, placeholder: placeholder)
    }
    
    fileprivate func chainResponsiveTransformation(_ view: UIImageView) -> CLDTransformation? {
        guard view.bounds.width > 0 && view.bounds.height > 0 else {
            // nothing to do
            return nil
        }
        
        let params = responsiveParams!
        let responsiveTransformation = CLDTransformation()
        
        if let baseTransformation = baseTransformation {
                responsiveTransformation.setRawTransformation(baseTransformation).chain()
        }
        
        if (params.autoWidth) {
            requestedWidth = getRoundedContentWidth(view)
            responsiveTransformation.setWidth(requestedWidth)
        } else {
            requestedWidth = 0
        }
        
        if (params.autoHeight) {
            requestedHeight = getRoundedContentHeight(view)
            responsiveTransformation.setHeight(requestedHeight)
        } else {
            requestedHeight = 0
        }
        
        if let crop = params.cropMode {
            responsiveTransformation.setCrop(crop)
        }
        
        if let gravity = params.gravity {
            responsiveTransformation.setGravity(gravity)
        }
        
        return responsiveTransformation.setDpr(Float(UIScreen.main.scale))
    }
    
    fileprivate func getRoundedContentHeight(_ view: UIImageView) -> Int {
        return trimAndRoundUp(Int(round(view.frame.height - view.layoutMargins.top - view.layoutMargins.bottom)))
    }
    
    fileprivate func getRoundedContentWidth(_ view: UIImageView) -> Int {
        return trimAndRoundUp(Int(round(view.frame.width - view.layoutMargins.left - view.layoutMargins.right)))
    }
    
    fileprivate func trimAndRoundUp(_ dimension: Int) -> Int {
        let value = ((dimension - 1) / responsiveParams!.stepSizePoints + 1) * responsiveParams!.stepSizePoints;
        return max(responsiveParams!.minDimensionPoints, min(value, responsiveParams!.maxDimensionPoints));
    }
}
