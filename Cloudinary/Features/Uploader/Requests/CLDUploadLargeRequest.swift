//
//  CLDUploadLargeRequest.swift
//
//  Copyright (c) 2017 Cloudinary (http://cloudinary.com)
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

@objc open class CLDUploadLargeRequest: CLDUploadRequest {
    internal var totalLength: Int64
    internal var cancelled = false
    internal var totalProgress: Progress
    internal var requests:[CLDUploadRequest]
    internal var completionHandler: ((_ result: CLDUploadResult?, _ error: NSError?) -> ())?
    internal var requestsProgress = [CLDUploadRequest: Int64]()
    internal var cleanupHandler: ((Bool)->())?

    internal init(_ requests: [CLDUploadRequest], _ totalLength: Int64) {
        self.requests = requests
        self.totalLength = totalLength
        self.totalProgress = Progress(totalUnitCount: totalLength)
    }

    // MARK: - Public

    /**
     Resume the request.
     */
    open override func resume() {
        for request in requests {
            request.resume()
        }
    }

    /**
     Suspend the request.
     */
    open override func suspend() {
        for request in requests {
            request.suspend()
        }
    }

    /**
     Cancel the request.
     */
    open override func cancel() {
        cancelled = true
        for request in requests {
            request.cancel()
        }
    }

    //MARK: Handlers

    /**
     Set a response closure to be called once the request has finished.
     
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:                          The same instance of CLDUploadLargeRequest.
     */
    @discardableResult
    open override func response(_ completionHandler: @escaping (_ result: CLDUploadResult?, _ error: NSError?) -> ()) -> CLDUploadLargeRequest {
        self.completionHandler = completionHandler
        for request in requests {
            request.response() { result, error in
                guard (!self.cancelled) else {
                    return
                }

                if (error != nil){
                    // single part error fails everything
                    self.cancelled = true
                    self.cancel()
                    self.requestDone(nil, error, false)
                } else if let done = result?.done, done {
                        // last part arrived successfully
                        self.requestDone(result, nil, true)
                } else if (self.requests.count == 1) {
                    // If there's only one part we just propagate the result (since error is nil this is a successful result):
                    self.requestDone(result, error, true)
                }
            }
        }

        return self
    }

    fileprivate func requestDone(_ result: CLDUploadResult?, _ error: NSError?, _ success: Bool){
        completionHandler?(result, error)
        cleanupHandler?(success)
        requestsProgress.removeAll()
    }

    /**
     Set a progress closure that is called periodically during the data transfer.
     
     - parameter progressBlock:          The closure that is called periodically during the data transfer.
     
     - returns:                          The same instance of CLDUploadLargeRequest.
     */
    @discardableResult
    internal override func progress(_ progress: @escaping ((Progress) -> Void)) -> CLDUploadLargeRequest {

        for request in requests {
            request.progress() { innerProgress in
                guard (!self.cancelled) else {
                    return
                }

                self.requestsProgress[request] = innerProgress.completedUnitCount
                self.totalProgress.completedUnitCount = self.requestsProgress.values.reduce(0, +)
                progress(self.totalProgress)
            }
        }

        return self
    }

    internal func cleanupHandler (handler: @escaping (_ success: Bool)->()) {
        self.cleanupHandler = handler
    }
}
