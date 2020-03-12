//
//  CLDDownloader+Ios.swift
//  Cloudinary
//
//  Created by Ido Meirov on 23/02/2020.
//

import Foundation

extension CLDDownloader
{
    // MARK: - Actions
       /**
       Asynchronously fetches a remote image from the specified URL.
       The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
       
       - parameter url:                    The image URL to download.
       - parameter progress:          The closure that is called periodically during the data transfer.
       - parameter completionHandler:      The closure to be called once the request has finished, holding either the retrieved UIImage or the error.
       
       - returns:              A `CLDFetchImageRequest` instance to be used to get the fetched image from, or to get the download progress or cancel the task.
       */
       @discardableResult
       open func fetchImage(_ url: String, _ progress: ((Progress) -> Void)? = nil, completionHandler: CLDCompletionHandler? = nil) -> CLDFetchImageRequest {
           let request = CLDFetchImageRequestImpl(url: url, networkCoordinator: networkCoordinator)
           request.fetchImage()
           request.responseImage(completionHandler)
           request.progress(progress)
           return request
       }
}
