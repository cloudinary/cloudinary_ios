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

@objc internal class CLDUploadLargeRequest: CLDUploadRequest {
    private var state = RequestState.started
    internal var totalLength: Int64 = 0
    internal var totalProgress: Progress!
    internal var progressHandler: ((Progress) -> Void)?
    internal var requests: [CLDUploadRequest]? = nil
    internal var requestsProgress = [CLDUploadRequest: Int64]()
    internal var result: CLDUploadResult?
    internal var error: NSError?

    fileprivate let closureQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.isSuspended = true
        return operationQueue
    }()

    internal override init() {
    }

    internal func setRequests(_ requests: [CLDUploadRequest], _ totalLength: Int64) {
        self.requests = requests
        self.totalLength = totalLength
        self.totalProgress = Progress(totalUnitCount: totalLength)

        // setup closures and pending state
        for request in requests {
            request.response() { result, error in
                guard (self.state != RequestState.cancelled && self.state != RequestState.error) else {
                    return
                }

                if (error != nil) {
                    // single part error fails everything
                    self.state = RequestState.error
                    self.cancel()
                    self.requestDone(nil, error)
                } else if result?.done ?? false {
                    // last part arrived successfully
                    self.state = RequestState.success
                    self.requestDone(result, nil)
                } else if (self.requests!.count == 1) {
                    // If there's only one part the server doesn't return the 'done' flag
                    self.state = RequestState.success
                    self.requestDone(result, nil)
                }
            }

            request.progress() { innerProgress in
                guard (self.state != RequestState.cancelled && self.state != RequestState.error) else {
                    return
                }

                self.requestsProgress[request] = innerProgress.completedUnitCount
                self.totalProgress.completedUnitCount = self.requestsProgress.values.reduce(0, +)
                self.progressHandler?(self.totalProgress)
            }

            if (state == RequestState.suspended) {
                request.suspend()
            } else if (state == RequestState.cancelled) {
                request.cancel()
            }
        }
    }

    internal func setRequestError(_ error: NSError){
        state = RequestState.error
        requestDone(nil, error)
    }

    fileprivate func requestDone(_ result: CLDUploadResult?, _ error: NSError?) {
        self.error = error
        self.result = result
        requestsProgress.removeAll()
        requests?.removeAll()
        closureQueue.isSuspended = false
    }

    // MARK: - Public

    /**
     Resume the request.
     */
    open override func resume() {
        state = RequestState.started
        if let requests = self.requests {
            for request in requests {
                request.resume()
            }
        }
    }

    /**
     Suspend the request.
     */
    open override func suspend() {
        state = RequestState.suspended
        if let requests = self.requests {
            for request in requests {
                request.suspend()
            }
        }
    }

    /**
     Cancel the request.
     */
    open override func cancel() {
        state = RequestState.cancelled
        if let requests = self.requests {
            for request in requests {
                request.cancel()
            }
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
        closureQueue.addOperation {
            completionHandler(self.result, self.error)
        }
        
        return self
    }

    /**
     Set a progress closure that is called periodically during the data transfer.
     
     - parameter progressBlock:          The closure that is called periodically during the data transfer.
     
     - returns:                          The same instance of CLDUploadLargeRequest.
     */
    @discardableResult
    open override func progress(_ progress: @escaping ((Progress) -> Void)) -> CLDUploadLargeRequest {
        self.progressHandler = progress
        return self
    }

    internal func cleanupHandler(handler: @escaping (_ success: Bool) -> ()) -> CLDUploadLargeRequest {
        closureQueue.addOperation {
            handler(self.state == RequestState.success)
        }
        return self
    }
}

fileprivate enum RequestState: Int {
    case started, suspended, cancelled, error, success
}
