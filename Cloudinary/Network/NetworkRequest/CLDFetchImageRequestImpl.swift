//
//  CLDFetchImageRequestImpl.swift
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

internal class CLDFetchImageRequestImpl: CLDFetchImageRequest {
    
    fileprivate let url: String
    fileprivate let networkCoordinator: CLDNetworkCoordinator
    
    fileprivate let closureQueue: OperationQueue
    
    fileprivate var image: UIImage?
    fileprivate var error: NSError?
    
    
    // Requests
    fileprivate var imageDownloadRequest: CLDNetworkDownloadRequest?
    fileprivate var progress: ((Progress) -> Void)?
    
    init(url: String, networkCoordinator: CLDNetworkCoordinator) {
        self.url = url
        self.networkCoordinator = networkCoordinator
        closureQueue = {
            let operationQueue = OperationQueue()
            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            return operationQueue
            }()
    }
    
    // MARK: - Actions
    
    func fetchImage() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if CLDImageCache.defaultImageCache.hasCachedImageForKey(self.url) {
                CLDImageCache.defaultImageCache.getImageForKey(self.url, completion: { [weak self] (image) -> () in
                    if let fetchedImage = image {
                        self?.image = fetchedImage
                        self?.closureQueue.isSuspended = false
                    }
                    else {
                        self?.downloadImageAndCacheIt()
                    }
                })
            }
            else {
                self.downloadImageAndCacheIt()
            }
        }
    }
    
    // MARK: Private
    
    fileprivate func downloadImageAndCacheIt() {
        imageDownloadRequest = networkCoordinator.download(url) as? CLDNetworkDownloadRequest
        imageDownloadRequest?.progress(progress)
        
        imageDownloadRequest?.responseData { [weak self] (responseData, responseError) -> () in
            if let data = responseData {
                if let
                    image = data.cldToUIImageThreadSafe(),
                    let url = self?.url {
                    self?.image = image
                    CLDImageCache.defaultImageCache.cacheImage(image, data: data, key: url, completion: nil)
                }
                else {
                    let error = CLDError.error(code: .failedCreatingImageFromData, message: "Failed creating an image from the received data.")
                    self?.error = error
                }
            }
            else if let err = responseError {
                self?.error = err
            }
            else {
                let error = CLDError.error(code: .failedDownloadingImage, message: "Failed attempting to download image.")
                self?.error = error
            }
            self?.closureQueue.isSuspended = false
        }
    }
    
    // MARK: - CLDFetchImageRequest
    
    @discardableResult
    @objc func responseImage(_ completionHandler: CLDCompletionHandler?) -> CLDFetchImageRequest {
        closureQueue.addOperation {
            if let image = self.image {
                completionHandler?(image, nil)
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
        if let downloadRequest = self.imageDownloadRequest {
            downloadRequest.progress(progress)
        }
        else {
            self.progress = progress
        }
        return self
    }
    
    @objc func resume() {
        imageDownloadRequest?.resume()
    }
    
    @objc func suspend() {
        imageDownloadRequest?.suspend()
    }
    
    
    @objc func cancel() {
        imageDownloadRequest?.cancel()
    }
    
    @objc func response(_ completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> CLDNetworkRequest {
        responseImage(completionHandler)
        return self
    }
}
