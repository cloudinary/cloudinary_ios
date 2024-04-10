//
//  ExtensionCLDDownloader.swift
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

extension CLDDownloader
{
    // MARK: - Actions
    /**
     Asynchronously fetches a remote image from the specified URL.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
     //TODO: REMOVE!!!
     - parameter url:                    The image URL to download.
     - parameter progress:          The closure that is called periodically during the data transfer.
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the retrieved UIImage or the error.
     
     - returns:              A `CLDFetchImageRequest` instance to be used to get the fetched image from, or to get the download progress or cancel the task.
     */
    @discardableResult
    open func fetchImage(_ url: String, _ progress: ((Progress) -> Void)? = nil, completionHandler: CLDCompletionHandler? = nil) -> CLDFetchImageRequest {
        let request = CLDFetchImageRequestImpl(url: url, downloadCoordinator: downloadCoordinator)
        request.responseImage(completionHandler)
        request.progress(progress)
        request.fetchImage()
        return request
    }
    
    /**
     Asynchronously fetches a remote asset from the specified URL.
     The asset is retrieved from the cache if it exists, otherwise its downloaded and cached.
     
     - parameter url:                    The asset URL to download.
     - parameter progress:               The closure that is called periodically during the data transfer.
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the retrieved Data or an error.
     
     - returns:              A `CLDFetchAssetRequest` instance to be used to get the fetched image from, or to get the download progress or cancel the task.
     */
    @discardableResult
    open func fetchAsset(_ url: String, _ progress: ((Progress) -> Void)? = nil, completionHandler: CLDAssetCompletionHandler? = nil) -> CLDFetchAssetRequest {
        
        let request = CLDFetchAssetRequestImpl(url: url, downloadCoordinator: downloadCoordinator)
        request.responseAsset(completionHandler)
        request.progress(progress)
        request.fetchAsset()
        return request
    }
}
