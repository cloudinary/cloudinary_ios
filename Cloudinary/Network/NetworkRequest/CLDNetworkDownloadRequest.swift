//
//  CLDNetworkDownloadRequest.swift
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
import Alamofire

internal class CLDNetworkDownloadRequest: CLDNetworkDataRequestImpl<DataRequest>, CLDFetchImageRequest {

    //MARK: - Handlers
    
    func responseImage(_ completionHandler: CLDCompletionHandler?) -> CLDFetchImageRequest {
        
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
        }
    }
    
    // MARK: - Private
    
    @discardableResult
    internal func responseData(_ completionHandler: ((_ responseData: Data?, _ error: NSError?) -> ())?) -> CLDFetchImageRequest {
        request.responseData { response in
            if let imageData = response.result.value {
                completionHandler?(imageData, nil)
            }
            else if let err = response.result.error {
                let error = err as NSError
                completionHandler?(nil, error)
            }
            else {
                completionHandler?(nil, CLDError.generalError())
            }
        }
        return self
    }
}
