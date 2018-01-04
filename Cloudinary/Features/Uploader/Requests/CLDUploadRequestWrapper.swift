//
//  CLDUploadRequestWrapper.swift
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
/**
 A `CLDUploadRequestWrapper` object is a wrapper for instances of `CLDUploadRequest`. This is returned as a promise from
 several `CLDUploader` functions, in case the actual concrete request cannot yet be created. This is also allows for multiple
 concrete requests to be represented as one request. This class is used for preprocessing requests as well as uploda large requests.
 */
@objc internal class CLDUploadRequestWrapper: CLDUploadRequest {
    private var state = RequestState.started
    fileprivate var requestsCount: Int!
    fileprivate var totalLength: Int64!
    fileprivate var requestsProgress = [CLDUploadRequest: Int64]()
    fileprivate var totalProgress: Progress?
    fileprivate var progressHandler: ((Progress) -> Void)?
    fileprivate var requests = [CLDUploadRequest]()
    fileprivate var result: CLDUploadResult?
    fileprivate var error: NSError?
    fileprivate let queue = DispatchQueue(label: "RequestsHandlingQueue", attributes: .concurrent)
    fileprivate let closureQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.isSuspended = true
        return operationQueue
    }()
    
    /**
     Once the count and total length of the request are known this method should be called.
     Without this information the progress closures will not be called.
     
     - parameter count:         Number of inner requests expected to be added (or already added).
     - parameter totalLength:   Total length, in bytes, of the uploaded resource (can be spread across several inner request for `uploadLarge`)
     */
    internal func setRequestsData(count: Int, totalLength: Int64?) {
        self.totalLength = totalLength ?? 0
        self.requestsCount = count
        self.totalLength = totalLength ?? 0
        self.totalProgress = Progress(totalUnitCount: self.totalLength)
    }

    /**
     Add a requst to be part of the wrapping request.
     
     - parameter request:   An upload request to add - This is usually a concrete `CLDDefaultUploadRequest` to be part of this wrapper.
     */
    internal func addRequest(_ request: CLDUploadRequest) {
        queue.sync() {
            guard self.state != RequestState.cancelled && self.state != RequestState.error else {
                return
            }

            if (self.state == RequestState.suspended) {
                request.suspend()
            }

            request.response() { result, error in
                guard (self.state != RequestState.cancelled && self.state != RequestState.error) else {
                    return
                }

                if (error != nil) {
                    // single part error fails everything
                    self.state = RequestState.error
                    self.cancel()
                    self.requestDone(nil, error)
                } else if self.requestsCount == 1 || (result?.done ?? false) {
                    // last part arrived successfully
                    self.state = RequestState.success
                    self.requestDone(result, nil)
                }
            }

            request.progress() { innerProgress in
                guard (self.state != RequestState.cancelled && self.state != RequestState.error) else {
                    return
                }

                self.requestsProgress[request] = innerProgress.completedUnitCount
                
                if let totalProgress = self.totalProgress {
                    totalProgress.completedUnitCount = self.requestsProgress.values.reduce(0, +)
                    self.progressHandler?(totalProgress)
                }
            }

            self.requests.append(request)
        }
    }

    /**
     This is used in case the request fails even without any inner upload request (e.g. when the preprocessing fails).
     Once the error is set here it will be send once the completion closures are set.
     
     - parameter error: The NSError to set.
     */
    internal func setRequestError(_ error: NSError) {
        state = RequestState.error
        requestDone(nil, error)
    }

    fileprivate func requestDone(_ result: CLDUploadResult?, _ error: NSError?) {
        self.error = error
        self.result = result
        requestsProgress.removeAll()
        requests.removeAll()
        closureQueue.isSuspended = false
    }

    // MARK: - Public

    /**
     Resume the request.
     */
    open override func resume() {
        queue.sync() {
            state = RequestState.started
            for request in requests {
                request.resume()
            }
        }
    }

    /**
     Suspend the request.
     */
    open override func suspend() {
        queue.sync() {
            state = RequestState.suspended
            for request in requests {
                request.suspend()
            }
        }
    }

    /**
     Cancel the request.
     */
    open override func cancel() {
        queue.sync() {
            state = RequestState.cancelled
            for request in requests {
                request.cancel()
            }
        }
    }

    //MARK: Handlers

    /**
     Set a response closure to be called once the request has finished.
     
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:                          The same instance of CldUploadRequestWrapper.
     */
    @discardableResult
    open override func response(_ completionHandler: @escaping (_ result: CLDUploadResult?, _ error: NSError?) -> ()) -> Self {
        closureQueue.addOperation {
            completionHandler(self.result, self.error)
        }

        return self
    }

    /**
     Set a progress closure that is called periodically during the data transfer.
     
     - parameter progressBlock:          The closure that is called periodically during the data transfer.
     
     - returns:                          The same instance of CLDUploadRequestWrapper.
     */
    @discardableResult
    open override func progress(_ progress: @escaping ((Progress) -> Void)) -> Self {
        self.progressHandler = progress
        return self
    }

    /**
    Sets a cleanup handler that is called when the request doesn't need it's resources anymore.
     This is called whether the request succeeded or not.
     
     - Parameter handler:   The closure to be called once cleanup is necessary.
     
     - returns:             The same instance of CLDUploadRequestWrapper.
     */
    @discardableResult
    internal func cleanupHandler(handler: @escaping (_ success: Bool) -> ()) -> Self {
        closureQueue.addOperation {
            handler(self.state == RequestState.success)
        }
        return self
    }
}

fileprivate enum RequestState: Int {
    case started, suspended, cancelled, error, success
}
