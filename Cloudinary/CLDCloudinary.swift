//
//  CLDCloudinary.swift
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

public typealias CLDCompletionHandler = (_ responseImage: UIImage?, _ error: NSError?) -> ()
public typealias CLDUploadCompletionHandler = (_ response: CLDUploadResult?, _ error: NSError?) -> ()

@objc open class CLDCloudinary: NSObject {
    
    /**
     Holds the configuration parameters to be used by the `CLDCloudinary` instance.
     */
    open fileprivate(set) var config: CLDConfiguration
    
    /**
     The network coordinator coordinates between the SDK's API level classes to its network adapter layer.
     */
    fileprivate var networkCoordinator: CLDNetworkCoordinator
    
    
    // MARK: - SDK Configurations
    
    // MARK: Log Level
    
    /**
     Sets Cloudinary SDK's log level, default level is set to **None**.
     */
    open static var logLevel: CLDLogLevel {
        get {
            return CLDLogManager.minimumLogLevel
        }
        set {
            CLDLogManager.minimumLogLevel = newValue
        }
    }
    
    // MARK: Image Cache
    
    /**
     Sets Cloudinary SDK's caching policy for images that are downloaded via the SDK's CLDDownloader.
     The options are: **None**, **Memory** and **Disk**. default is Disk
     */
    open var cachePolicy: CLDImageCachePolicy {
        get {
            return CLDImageCache.defaultImageCache.cachePolicy
        }
        set {
            CLDImageCache.defaultImageCache.cachePolicy = newValue
        }
    }
    
    /**
     Sets Cloudinary SDK's image cache maximum disk capacity.
     default is 150 MB.     
     */
    open var cacheMaxDiskCapacity: UInt64 {
        get {
            return CLDImageCache.defaultImageCache.maxDiskCapacity
        }
        set {
            CLDImageCache.defaultImageCache.maxDiskCapacity = newValue
        }
    }
    
    // MARK: - Init
    
    /**
    Initializes the `CLDCloudinary` instance with the specified configuration and network adapter.
     
    - parameter configuration:          The configuration used by this CLDCloudinary instance.
    - parameter networkAdapter:         A network adapter that implements `CLDNetworkAdapter`. CLDNetworkDelegate() by default.
    
     - returns: The new `CLDCloudinary` instance.
     */
    public init(configuration: CLDConfiguration, networkAdapter: CLDNetworkAdapter? = nil, sessionConfiguration: URLSessionConfiguration? = nil) {
        config = configuration
        if let customNetworkAdapter = networkAdapter {
            networkCoordinator = CLDNetworkCoordinator(configuration: config, networkAdapter: customNetworkAdapter)
        }
        else {
            if let sessionConfiguration = sessionConfiguration {
                networkCoordinator = CLDNetworkCoordinator(configuration: config, sessionConfiguration: sessionConfiguration)
            } else {
                networkCoordinator = CLDNetworkCoordinator(configuration: config)
            }
        }
        super.init()
    }
    
    // MARK: Factory Methods
    
    /**
    A factory method to create a new `CLDUrl` instance
    
    - returns: A new `CLDUrl` instance.
    */
    open func createUrl() -> CLDUrl {
        return CLDUrl(configuration: config)
    }
    
    /**
     A factory method to create a new `CLDUploader` instance
     
     - returns: A new `CLDUploader` instance.
     */
    open func createUploader() -> CLDUploader {
        return CLDUploader(networkCoordinator: networkCoordinator)
    }
    
    /**
     A factory method to create a new `CLDDownloader` instance
     
     - returns: A new `CLDDownloader` instance.
     */
    open func createDownloader() -> CLDDownloader {
        return CLDDownloader(networkCoordinator: networkCoordinator)
    }
    
    /**
     A factory method to create a new `CLDAdminApi` instance
     
     - returns: A new `CLDAdminApi` instance.
     */
    open func createManagementApi() -> CLDManagementApi {
        return CLDManagementApi(networkCoordinator: networkCoordinator)
    }

    // MARK: - Network Adapter
    
    /**
    The maximum number of queued downloads that can execute at the same time.
    
    default is NSOperationQueueDefaultMaxConcurrentOperationCount.
    
    - parameter maxConcurrentDownloads:     The maximum concurrent downloads to allow.
    */
    @available(iOS 8.0, *)
    open func setMaxConcurrentDownloads(_ maxConcurrentDownloads: Int) {
        networkCoordinator.setMaxConcurrentDownloads(maxConcurrentDownloads)
    }
    
    // MARK: Background Session
    
    /**
        Set a completion handler provided by the UIApplicationDelegate `application:handleEventsForBackgroundURLSession:completionHandler:` method.
        The handler will be called automatically once the session finishes its events for background URL session.
    
        default is `nil`.
    */
    @available(iOS 8.0, *)
    open func setBackgroundCompletionHandler(_ newValue: (() -> ())?) {
        networkCoordinator.setBackgroundCompletionHandler(newValue)
    }
    
    // MARK: - Advanced
    /**
    Sets the "USER-AGENT" HTTP header on all network requests to be **"PlatformName/ver CloudinaryiOS/ver"**
    By default the header is set to **"CloudinaryiOS/ver"**
    */
    open func setUserPlatform(_ platformName: String, version: String) {
        config.setUserPlatform(platformName, version: version)
    }
    
}
