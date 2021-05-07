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

/**
 The `CLDFetchImageRequest` protocol is returned when creating a fetch image request.
 It allows the option to set a closure returning the fetched image when its available.
 The protocol also allows the options to add a progress closure that is called periodically during the download,
 as well as cancelling the request.
 */
@objc public protocol CLDFetchImageRequest: CLDNetworkDataRequest {
    
    //MARK: Actions
    
    /**
     Set a response closure to be called once the fetch image request has finished.
     
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the retrieved UIImage or the error.
     
     - returns:                          The same instance of CLDFetchImageRequest.
     */
    @discardableResult
    func responseImage(_ completionHandler: CLDCompletionHandler?) -> CLDFetchImageRequest
}

#endif
