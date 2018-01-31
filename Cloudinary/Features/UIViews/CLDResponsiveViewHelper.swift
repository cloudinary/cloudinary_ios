//
//  CLDResponsiveViewHelper.swift
//  Cloudinary
//
//  Created by Nitzan Jaitman on 29/01/2018.
//  Copyright © 2018 Cloudinary. All rights reserved.
//

import Foundation
import UIKit

@objc open class CLDResponsiveViewHelper : NSObject{
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
    
    @objc public func cldSetImage(view: UIImageView, publicId: String, cloudinary: CLDCloudinary, signUrl: Bool = false, resourceType: CLDUrlResourceType = CLDUrlResourceType.image,
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
                (params.reloadOnSizeChange && didGetLarger(view)) {
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
        
        // TODO: Evaluate DPR behaviour
        return responsiveTransformation.setDpr(Float(UIScreen.main.scale))
    }
    
    fileprivate func getRoundedContentHeight(_ view: UIImageView) -> Int {
        return trimAndRoundUp(Int(round(view.frame.height - view.layoutMargins.top - view.layoutMargins.bottom)))
    }
    
    fileprivate func getRoundedContentWidth(_ view: UIImageView) -> Int {
        return trimAndRoundUp(Int(round(view.frame.width - view.layoutMargins.left - view.layoutMargins.right)))
    }
    
    fileprivate func trimAndRoundUp(_ dimension: Int) -> Int {
        let value = ((dimension - 1) / responsiveParams!.stepSize + 1) * responsiveParams!.stepSize;
        return max(responsiveParams!.minDimension, min(value, responsiveParams!.maxDimension));
    }
}
