//
//  CLDFetchAssetRequestImpl.swift
//
//  Copyright (c) 2021 Cloudinary (http://cloudinary.com)
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

internal class CLDFetchAssetRequestImpl: CLDFetchAssetRequest {
    
    fileprivate let url                : String
    fileprivate let downloadCoordinator: CLDDownloadCoordinator
    
    fileprivate let closureQueue: OperationQueue
    
    fileprivate var data : Data?
    fileprivate var error: NSError?
    
    // Requests
    fileprivate var dataDownloadRequest: CLDNetworkDownloadRequest?
    fileprivate var progress           : ((Progress) -> Void)?
    
    init(url: String, downloadCoordinator: CLDDownloadCoordinator) {
        self.url = url
        self.downloadCoordinator = downloadCoordinator
        closureQueue = {
            let operationQueue = OperationQueue()
            operationQueue.name = "com.cloudinary.CLDFetchAssetRequest"
            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            return operationQueue
            }()
    }
    
    // MARK: - Actions
    func fetchAsset() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.downloadData()
        }
    }
    
    // MARK: Private
    fileprivate func downloadData() {
        
        dataDownloadRequest = downloadCoordinator.download(url) as? CLDNetworkDownloadRequest
        dataDownloadRequest?.progress(progress)
        
        dataDownloadRequest?.responseData { [weak self] (responseData, responseError) -> () in
            if let data = responseData,
               let err = responseError {
                self?.data  = data
                self?.error = err
            }
            else if let data = responseData {
                self?.data = data
            }
            else if let err = responseError {
                self?.error = err
            }
            else {
                let error = CLDError.error(code: .failedDownloadingAsset, message: "Failed attempting to download asset.")
                self?.error = error
            }
            self?.closureQueue.isSuspended = false
        }
    }
    
    // MARK: - CLDFetchDataRequest
    @discardableResult
    @objc func responseAsset(_ completionHandler: CLDAssetCompletionHandler?) -> CLDFetchAssetRequest {
        closureQueue.addOperation {
            
            if let data = self.data,
               let error = self.error {
                completionHandler?(data, error)
            }
            else if let data = self.data {
                completionHandler?(data, nil)
            }
            else if let error = self.error {
                completionHandler?(nil, error)
            }
            else {
                completionHandler?(nil, CLDError.generalError())
            }
        }
        return self
    }
    
    @discardableResult
    @objc func progress(_ progress: ((Progress) -> Void)?) -> CLDNetworkDataRequest {
        if let downloadRequest = self.dataDownloadRequest {
            downloadRequest.progress(progress)
        }
        else {
            self.progress = progress
        }
        return self
    }
    
    @objc func resume() {
        dataDownloadRequest?.resume()
    }
    
    @objc func suspend() {
        dataDownloadRequest?.suspend()
    }
    
    
    @objc func cancel() {
        dataDownloadRequest?.cancel()
    }
    
    @objc func response(_ completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> CLDNetworkRequest {
        responseAsset(completionHandler)
        return self
    }
}
