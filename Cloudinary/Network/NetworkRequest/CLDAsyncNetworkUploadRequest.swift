//
//  CLDAsyncNetworkUploadRequest.swift
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

internal class CLDAsyncNetworkUploadRequest: CLDNetworkDataRequest {
    
    
    // Once a value is set it should not be overridden
    internal var networkDataRequest: CLDNetworkDataRequest? {
        didSet {
            if networkDataRequest != nil {
                closureQueue.isSuspended = false
            }
        }
    }
    
    fileprivate let closureQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.isSuspended = true
        return operationQueue
    }()
    
    
    // MARK: - CLDNetworkDataRequest
    
    func resume() {
        closureQueue.addOperation {
            self.networkDataRequest?.resume()
        }
    }
    
    func suspend() {
        closureQueue.addOperation {
            self.networkDataRequest?.suspend()
        }
    }
    
    func cancel() {
        closureQueue.addOperation {
            self.networkDataRequest?.cancel()
        }
    }
    
    func response(_ completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> CLDNetworkRequest {
        closureQueue.addOperation {
            self.networkDataRequest?.response(completionHandler)
        }
        return self
    }
    
    func progress(_ progress: ((Progress) -> Void)?) -> CLDNetworkDataRequest {
        closureQueue.addOperation {
            self.networkDataRequest?.progress(progress)
        }        
        return self
    }
}
