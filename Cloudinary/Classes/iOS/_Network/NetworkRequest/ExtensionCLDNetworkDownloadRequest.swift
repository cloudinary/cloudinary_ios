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

public typealias CLDCompletionHandler = (_ responseImage: UIImage?, _ error: NSError?) -> ()
private let lock = NSLock()

extension Data {
    
    func cldToUIImageThreadSafe() -> UIImage? {
        lock.lock()
        let image = UIImage(data: self)
        lock.unlock()
        return image
    }
}


extension CLDNetworkDownloadRequest : CLDFetchImageRequest {
    
    //MARK: - Handlers
    public func responseImage(_ completionHandler: CLDCompletionHandler?) -> CLDFetchImageRequest {
        
        return responseData { (responseData, error) -> () in
            
            if let data = responseData {
                
                if let image = data.cldToUIImageThreadSafe() {
                    completionHandler?(image, nil)
                }
                else {
                    let error = CLDError.error(code: .failedCreatingImageFromData, message: "Failed creating an image from the received data.")
                    completionHandler?(nil, error)
                }
            }
            else if let err = error {
                completionHandler?(nil, err)
            }
            else {
                completionHandler?(nil, CLDError.generalError())
            }
        } as! CLDFetchImageRequest
    }
    
}
#endif
