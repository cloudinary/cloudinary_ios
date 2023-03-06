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
import UIKit

internal class CLDFetchImageRequestImpl: CLDFetchImageRequest {
    
    fileprivate let url: String
    fileprivate let downloadCoordinator: CLDDownloadCoordinator
    
    fileprivate let closureQueue: OperationQueue
    
    fileprivate var image: UIImage?
    fileprivate var error: NSError?
    
    
    // Requests
    fileprivate var imageDownloadRequest: CLDNetworkDownloadRequest?
    fileprivate var progress: ((Progress) -> Void)?
    
    init(url: String, downloadCoordinator: CLDDownloadCoordinator) {
        self.url = url
        self.downloadCoordinator = downloadCoordinator
        closureQueue = {
            let operationQueue = OperationQueue()
            operationQueue.name = "com.cloudinary.CLDFetchImageRequest"
            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            return operationQueue
            }()
    }
    
    // MARK: - Actions
    
    func fetchImage() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if self.downloadCoordinator.imageCache.hasCachedImageForKey(self.url) {
                self.downloadCoordinator.imageCache.getImageForKey(self.url, completion: { [weak self] (image) -> () in
                    if let fetchedImage = image {
                        self?.image = fetchedImage
                        self?.closureQueue.isSuspended = false
                    }
                    else {
                        self?.checkUrlCacheAndDownload()
                    }
                })
            }
            else {
                self.checkUrlCacheAndDownload()
            }
        }
    }
    
    // MARK: Private
    
    fileprivate func checkUrlCacheAndDownload() {
        var headers: CLDNHTTPHeaders?
        if let cachedResponse = try? self.downloadCoordinator.urlCache.warehouse.entry(forKey: url), downloadCoordinator.imageCache.cachePolicy == .none {
            let lastModified = cachedResponse.expiry.date
            headers = CLDNHTTPHeaders()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")

            let lastModifiedDate = Date() // replace with the actual date you want to use
            let ifModifiedSinceHeader = dateFormatter.string(from: lastModifiedDate)
            headers!["If-Modified-Since"] = ifModifiedSinceHeader
            let headRequest = downloadCoordinator.head(url, headers: headers) as? CLDNetworkDownloadRequest
            headRequest?.responseData { [weak self] (responseData, responseError, httpCode) -> () in
                if httpCode == 200 { // If we get 200 that means the image changed we need to remove it from the cache and download it again
                    if let url = self?.url {
                        try? self?.downloadCoordinator.urlCache.removeCachedResponse(for: URLRequest(url: url, method: .get))
                    }
                }
                self?.downloadImageAndCacheIt()
            }
            return
        } else {
            downloadImageAndCacheIt()
        }
    }

    func downloadImageAndCacheIt() {
        imageDownloadRequest = downloadCoordinator.download(url) as? CLDNetworkDownloadRequest
        imageDownloadRequest?.progress(progress)
        // Here we need to check for the cached image and set the if-modified header with the currect date.

        imageDownloadRequest?.responseData { [weak self] (responseData, responseError, httpCode) -> () in
            if let data = responseData, !data.isEmpty {
                if let
                    image = data.cldToUIImageThreadSafe(),
                   let url = self?.url {
                    self?.image = image
                    if self?.downloadCoordinator.imageCache.cachePolicy != .none {
                        self?.downloadCoordinator.imageCache.cacheImage(image, data: data, key: url, completion: nil)
                    }
                }
                else {
                    let error = CLDError.error(code: .failedCreatingImageFromData, message: "Failed creating an image from the received data.", userInfo: ["statusCode": httpCode])
                    self?.error = error
                }
            }
            else if let err = responseError {
                self?.error = err
            }
            else {
                let error = CLDError.error(code: .failedDownloadingImage, message: "Failed attempting to download image.", userInfo: ["statusCode": httpCode])
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
