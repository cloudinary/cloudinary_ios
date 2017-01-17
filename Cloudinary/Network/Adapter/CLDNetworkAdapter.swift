//
//  NetworkAdapter.swift
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


// MARK: CLDNetworkAdapter

/**
A protocol defining the way the SDK works with its network layer, allowing the implementation of a custom network layer.
By default the Cloudinary SDK uses CLDNetworkDelegate() as its network adapter, 
to use a custom network adapter you must implement the `CLDNetworkAdapter` protocol and send it when creating the CLDCloudinary instance.
*/
@objc public protocol CLDNetworkAdapter {
    
    // MARK: Actions
    
    /**
    Create a network request for the given URL, with the specified headers and body parameters.
    
    - parameter url:            The URL to make the request to.
    - parameter headers:        A dictionary of the headers to set to the request.
    - parameter parameters:     A dictionary of the parameters to set to the request.
    
    - returns:                  An instance implementing the protocol `CLDNetworkDataRequest`,
                                allowing the options to add response closure to be called once the request has finished,
                                as well as performing actions on the request, such as cancelling, suspending or resuming it.
    */
    func cloudinaryRequest(_ url: String, headers: [String : String], parameters: [String : Any]) -> CLDNetworkDataRequest
    
    /**
     Create a network upload request for the given URL, with the specified headers, body parameters and data.
     
     - parameter url:            The URL to make the request to.
     - parameter headers:        A dictionary of the headers to set to the request.
     - parameter parameters:     A dictionary of the parameters to set to the request.
     - parameter data:           Can receive eithe the data to upload or an NSURL to either a local or a remote file to upload.

     - returns:                 An instance implementing the protocol `CLDNetworkDataRequest`,
                                allowing the options to add a progress closure that is called periodically during the upload
                                and a response closure to be called once the upload is finished,
                                as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    func uploadToCloudinary(_ url: String, headers: [String : String], parameters: [String : Any],  data: Any) -> CLDNetworkDataRequest
    
    /**
     Download a file from the specified url.
     
     - parameter url:           The URL of the file to download.
     
     - returns:                 An instance implementing the protocol `CLDFetchImageRequest`,
                                allowing the option to set a closure returning the fetched image when its available.
                                The protocol also allows the options to add a progress closure that is called periodically during the download,
                                as well as cancelling the request.
     */
    func downloadFromCloudinary(_ url: String) -> CLDFetchImageRequest
    
    // MARK: Setters
    
    /**
    Set a completion handler provided by the UIApplicationDelegate `application:handleEventsForBackgroundURLSession:completionHandler:` method.
    The handler will be called automaticaly once the session finishes its events for background URL session.
    
    default is `nil`.
    */
    func setBackgroundCompletionHandler(_ newValue: (() -> ())?)
    
    /**
     The maximum number of queued downloads that can execute at the same time.
     
     The default value of this property is NSOperationQueueDefaultMaxConcurrentOperationCount.
     */
    func setMaxConcurrentDownloads(_ maxConcurrentDownloads: Int)
    
    // MARK: Getters
    /**
    Get the completion handler to be called automaticaly once the session finishes its events for background URL session.
    
    default is `nil`.
    */
    func getBackgroundCompletionHandler() -> (() -> ())?
}


// MARK: - CLDNetworkRequest

/**
The `CLDNetworkRequest` protocol is returned when creating a network request using one of Cloudinary's API calls.
It allows the options to add a response closure to be called once the request has finished,
as well as performing actions on the request, such as cancelling, suspending or resuming it.
*/
@objc public protocol CLDNetworkRequest {
    
    // MARK: Actions
    
    /**
    Resume the request.
    */
    func resume()
    
    /**
     Suspend the request.
     */
    func suspend()
    
    /**
     Cancel the request.
     */
    func cancel()
    
}

// MARK: - CLDNetworkDataRequest

/**
The `CLDNetworkDataRequest` protocol is returned when creating a data transfer request to Cloudinary, e.g. uploading a file.
It allows the options to add a progress closure that is called periodically during the transfer
and a response closure to be called once the transfer has finished,
as well as performing actions on the request, such as cancelling, suspending or resuming it.
*/
@objc public protocol CLDNetworkDataRequest: CLDNetworkRequest {
    
    //MARK: Handlers

    /**
    Set a progress closure that is called periodically during the data transfer.
    
    - parameter progress:          The closure that is called periodically during the data transfer.
    
    - returns:                          The same instance of CLDNetworkDataRequest.
    */
    @discardableResult
    func progress(_ progress: ((Progress) -> Void)?) -> CLDNetworkDataRequest
    
    /**
     Set a response closure to be called once the request has finished.
     
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:                          The same instance of CLDNetworkRequest.
     */
    @discardableResult
    func response(_ completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> CLDNetworkRequest
}


// MARK: - CLDFetchImageRequest

/**
The `CLDFetchImageRequest` protocol is returned when creating a fetch image request.
It allows the option to set a closure returning the fetched image when its available.
The protocol also allows the options to add a progress closure that is called periodically during the download,
as well as cancelling the request.
*/
@objc public protocol CLDFetchImageRequest: CLDNetworkDataRequest {
    
    //MARK: Actions
      
    /**
     Set a response closure to be called once the fetch image request has finished.
     
     - parameter completionHandler:      The closure to be called once the request has finished, holding either the retrieved UIImage or the error.
     
     - returns:                          The same instance of CLDFetchImageRequest.
     */
    @discardableResult
    func responseImage(_ completionHandler: CLDCompletionHandler?) -> CLDFetchImageRequest
}

