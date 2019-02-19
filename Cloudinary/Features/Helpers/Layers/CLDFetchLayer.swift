//
//  CLDFetchLayer.swift
//  Cloudinary
//
//  Created by Nitzan Jaitman on 19/02/2019.
//  Copyright © 2019 Cloudinary. All rights reserved.
//

import Foundation

@objcMembers open class CLDFetchLayer: CLDLayer {
   
    // MARK: - Init
    
    /**
     Initialize a CLDFetchLayer instance.
     
     - parameter url: The url of the remote resource to fetch
     
     - returns: The new CLDFetchLayer instance.
     */
    public init(url: String) {
        super.init()
        setPublicId(publicId: url.cldBase64UrlEncode())
        resourceType = String(describing: LayerResourceType.fetch)
    }
}
