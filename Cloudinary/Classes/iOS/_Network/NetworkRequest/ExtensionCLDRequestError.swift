//
//  File.swift
//  
//
//  Created by Arkadi Yoskovitz on 5/6/21.
//

#if SWIFT_PACKAGE
    import Cloudinary_Core
#endif

#if os(iOS)
import UIKit

import Foundation

// MARK: - CLDFetchImageRequest
extension CLDRequestError : CLDFetchImageRequest {
    
    public func responseImage(_ completionHandler: CLDCompletionHandler?) -> CLDFetchImageRequest {
        completionHandler?(nil, error as NSError?)
        return self
    }
}
#endif
