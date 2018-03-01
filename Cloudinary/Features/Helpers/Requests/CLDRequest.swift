//
//  CLDRequest.swift
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
 The `CLDRequest` object is returned when creating a network request using one of Cloudinary's API calls.
 It allows the options to add a response closure to be called once the request has finished,
 as well as performing actions on the request, such as cancelling, suspending or resuming it.
 */
@objcMembers open class CLDRequest: NSObject {
    
    
    internal var networkRequest: CLDNetworkDataRequest
    
    internal init(networkRequest: CLDNetworkDataRequest) {
        self.networkRequest = networkRequest
    }
    
    
    // MARK: - Public
    
    /**
     Resume the request.
     */
    open func resume() {
       networkRequest.resume()
    }
    
    /**
     Suspend the request.
     */
    open func suspend() {
        networkRequest.suspend()
    }
    
    /**
     Cancel the request.
     */
    open func cancel() {
        networkRequest.cancel()
    }
    
    //MARK: Handlers
    
    /**
     Set a response closure to be called once the request has finished.
     
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:                          The same instance of CLDRequest.
     */
    @discardableResult
    open func responseRaw(_ completionHandler: @escaping (_ response: Any?, _ error: NSError?) -> ()) -> CLDRequest {
        networkRequest.response(completionHandler)
        return self
    }        
}
