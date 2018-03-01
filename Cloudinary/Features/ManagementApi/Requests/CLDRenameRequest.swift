//
//  CLDRenameRequest.swift
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

/**
 The `CLDRenameRequest` object is returned when creating a rename request.
 It allows the options to add a response closure to be called once the request has finished,
 as well as performing actions on the request, such as cancelling, suspending or resuming it.
 */
@objcMembers open class CLDRenameRequest: CLDRequest {

    /**
     Set a response closure to be called once the request has finished.
     
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:                          The same instance of CLDRenameRequest.
     */
    @discardableResult
    open func response(_ completionHandler: ((_ result: CLDRenameResult?, _ error: NSError?) -> ())?) -> CLDRenameRequest {
        responseRaw { (response, error) in
            if let res = response as? [String : AnyObject] {
                completionHandler?(CLDRenameResult(json: res), nil)
            }
            else if let err = error {
                completionHandler?(nil, err)
            }
            else {
                completionHandler?(nil, CLDError.generalError())
            }
        }
        
        return self
    }
}
