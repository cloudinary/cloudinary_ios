//
//  CLDURLCache.swift
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

@objc(CLDURLCacheDelegate)
internal protocol CLDURLCacheDelegate : NSObjectProtocol {
    @objc optional func networkAvailable(for urlCache: CLDURLCache) -> Bool
    @objc optional func shouldExclude(response: HTTPURLResponse, for urlCache: CLDURLCache) -> Bool
}

@objcMembers
@objc(CLDURLCache)
internal final class CLDURLCache : URLCache
{
    /// MARK: - Private properties
    internal fileprivate(set) var warehouse : Warehouse<CachedURLResponse>!
    internal fileprivate(set) var settings  : CLDURLCacheConfiguration!
    fileprivate var path                    : String?
    internal weak var delegate              : CLDURLCacheDelegate?
    
    fileprivate var shouldReceateCacheResponse = false
    
    /// MARK: - Initializers
    internal init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?, configuration settings: CLDURLCacheConfiguration = CLDURLCacheConfiguration.defualt)
    {
        self.settings = settings
        self.path     = path
        
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
        
        handleWarehouse(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path, configuration: settings)
    }
    
    internal override init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?)
    {
        fatalError("init(memoryCapacity:diskCapacity:diskPath) is not implemented, plase use: init(memoryCapacity:diskCapacity:diskPath:configuration: instead")
    }
    
    /// MARK: - Properties Overrides
    ///
    ///
    ///
    internal override var memoryCapacity : Int {
        get { return warehouse.memoryCapacity }
        set { /* No-Op*/ }
    }
    internal override var diskCapacity   : Int {
        get { return warehouse.diskCapacity }
        set { /* No-Op*/ }
    }
    
    internal override var currentMemoryUsage : Int {
        return warehouse.currentMemoryUsage
    }
    internal override var currentDiskUsage   : Int {
        return warehouse.currentDiskUsage
    }
    
    /// MARK: - Method Overrides
    ///
    ///
    ///
    internal override func cachedResponse(for request: URLRequest) -> CachedURLResponse?
    {
        guard let urlObject = request.url else {
            printLog(.debug, text: "CLDURLCache cannot extract CachedURLResponse for nil URLs")
            return nil
        }
        let absoluteURLString = urlObject.absoluteString
        
        guard !absoluteURLString.isEmpty else {
            printLog(.debug, text: "CLDURLCache cannot extract CachedURLResponse for empty URLs")
            return nil
        }
        
        //is caching allowed
        guard request.cachePolicy != .reloadIgnoringLocalCacheData else {
            printLog(.debug, text: "CLDURLCache cannot extract CachedURLResponse for this cache policy: \(request.cachePolicy)")
            return nil
        }
        
        var entry : StorehouseEntry<CachedURLResponse>? = nil
        do {
            entry = try warehouse.entry(forKey: absoluteURLString)
        }
        catch let error as NSError {
            printLog(.debug, text: "CLDURLCache cannot read StorehouseEntry<CachedURLResponse> from storage. Error: \(error.debugDescription)")
        }
        
        guard let responseEntry = entry else { return nil }
        
        // Check file status only if we have network, otherwise return it anyway.
        if networkAvailable() && responseEntry.expiry.isExpired
        {
            let maxAge = request.value(forHTTPHeaderField: "Access-Control-Max-Age") ?? String(settings.maxCacheResponseAge)
            printLog(.debug, text: "CLDURLCache cannot read item, older than \(maxAge) seconds")
        }
        
        let response = responseEntry.object
        
        // I have to find out the difrence. For now I will let the developer checkt which version to use
        if shouldReceateCacheResponse
        {
            if let HTTPURLResponse = response.response as? HTTPURLResponse, HTTPURLResponse.statusCode == 302
            {
                if let redirectTo = HTTPURLResponse.allHeaderFields["Location"] as? String , let redirectURL = URL(string: redirectTo) {
                    
                    printLog(.debug, text: "Redirecting from: \(response.response.url?.absoluteString ?? "")\nto: \(redirectTo)")
                    
                    // returning the response of the redirected url
                    let redirectRequest = URLRequest(url: redirectURL, cachePolicy: request.cachePolicy, timeoutInterval: request.timeoutInterval)
                    return cachedResponse(for: redirectRequest)
                }
            }
            
            guard let responseURL = response.response.url else { return response }
            let URLResponse = Foundation.URLResponse(url: responseURL, mimeType: response.response.mimeType, expectedContentLength: response.data.count, textEncodingName: response.response.textEncodingName)
            return CachedURLResponse(response: URLResponse, data: response.data, userInfo: response.userInfo, storagePolicy: .allowed)
        }
        return response
    }
    
    ///
    ///
    ///
    internal override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest)
    {
        let requestObject = request.cld_URLRequestWithoutFragment
        
        // When cache is ignored for read, it's a good idea not to store the result as well as this option
        // have big chance to be used every times in the future for the same request.
        // NOTE: This is a change regarding default URLCache behavior
        switch requestObject.cachePolicy
        {
        case .reloadIgnoringLocalCacheData         : return
        case .reloadIgnoringLocalAndRemoteCacheData: return
        default: break
        }
        
        guard let httpResponse = cachedResponse.response as? HTTPURLResponse else { return }
        guard let httpStatus   = httpResponse.cld_code                       else { return }
        
        let shouldExclude = delegate?.shouldExclude?(response: httpResponse, for: self)
        guard shouldExclude == false else { return }
        
        let expirationDate = httpResponse.cld_expirationDate(forCache: settings)
        
        switch cachedResponse.storagePolicy
        {
        case .allowed: fallthrough
        case .allowedInMemoryOnly:
            
            guard cachedResponse.data.count < diskCapacity else { break }
            
            // RFC 2616 section 13.3.4 says clients MUST use Etag in any cache-conditional request if provided by server
            guard let _ = httpResponse.cld_header.etag    else { break }
            guard let expirationDate = expirationDate else {
                // This response is not cacheable, headers said
                return
            }
            
            guard expirationDate.timeIntervalSinceNow - settings.expirationDelayMinimum > 0 else {
                // This response is not cacheable, headers said
                return
            }
            
        default: return
        }
        
        if httpStatus.isClientError || httpStatus.isServerError
        {
            printLog(.debug, text: "CLDURLCache Do not cache error \(httpResponse.statusCode) page for : \(String(describing: requestObject.url)) \(httpResponse.debugDescription)")
            return
        }
        
        if let previousResponse = self.cachedResponse(for: requestObject) , previousResponse.data == cachedResponse.data {
            
            return
        }
        
        guard let urlObject = requestObject.url , let expiration = expirationDate else { return }
        do {
            try warehouse.setObject(cachedResponse, forKey: urlObject.absoluteString, expiry: .date(expiration))
            try warehouse.removeExpiredObjects()
        }
        catch let error as NSError {
            printLog(.error, text: "Error \(error.debugDescription)")
        }
    }
    
    ///
    ///
    ///
    internal override func removeCachedResponse(for request: URLRequest)
    {
        guard let urlObject = request.url else { return }
        do {
            try warehouse.removeObject(forKey: urlObject.absoluteString)
        }
        catch let error as NSError {
            printLog(.error, text: "Error \(error.debugDescription)")
        }
    }
    
    ///
    ///
    ///
    internal override func removeAllCachedResponses()
    {
        do {
            try warehouse.removeAll()
        }
        catch let error as NSError {
            printLog(.error, text: "Error \(error.debugDescription)")
        }
    }
    
    ///
    ///
    ///
    internal override func removeCachedResponses(since date: Date)
    {
        do {
            try warehouse.removeStoredObjects(since: date)
        }
        catch let error as NSError {
            printLog(.error, text: "Error \(error.debugDescription)")
        }
    }
    
    ///
    ///
    ///
    internal override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for dataTask: URLSessionDataTask)
    {
        guard let urlRequest = dataTask.currentRequest else { return }
        storeCachedResponse(cachedResponse, for: urlRequest)
    }
    
    ///
    ///
    ///
    internal override func getCachedResponse(for dataTask: URLSessionDataTask, completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        guard let urlRequest = dataTask.currentRequest else { completionHandler(nil) ; return }
        let response = cachedResponse(for: urlRequest)
        completionHandler( response )
    }
    
    ///
    ///
    ///
    internal override func removeCachedResponse(for dataTask: URLSessionDataTask)
    {
        guard let urlRequest = dataTask.currentRequest else { return }
        removeCachedResponse(for: urlRequest)
    }
    
    ///
    /// Clears the cache, by removing all CachedURLResponse objects that it stores older then the minCacheResponseAge.
    ///
    internal func clearCachedResponsesToMinAgeThreshold()
    {
        let current   = Date()
        let threshold = current.addingTimeInterval(-settings.minCacheResponseAge)
        removeCachedResponses(since: threshold)
    }
    
    ///
    ///
    ///
    internal func updateDiskCapacity(_ newDiskCapacity: Int) {
        handleWarehouse(memoryCapacity: memoryCapacity, diskCapacity: newDiskCapacity, diskPath: path, configuration: self.settings, onlyUpdate: true)
    }

    ///
    ///
    ///
    internal func updateMemoryCapacity(_ newMemoryCapacity: Int) {
        handleWarehouse(memoryCapacity: newMemoryCapacity, diskCapacity: diskCapacity, diskPath: path, configuration: self.settings, onlyUpdate: true)
    }
}

// MARK: - private methods
extension CLDURLCache {
    
    ///
    /// Create or update Warehouse object
    ///
    fileprivate func handleWarehouse(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?, configuration settings: CLDURLCacheConfiguration = CLDURLCacheConfiguration.defualt, onlyUpdate: Bool = false) {
        
        let pathString : String
        switch path {
        case .none          : pathString = String()
        case .some(let path): pathString = path
        }
        
        let maxTimeFrom1970 = Date(timeIntervalSinceNow: settings.maxCacheResponseAge).timeIntervalSince1970
        let expiry = StorehouseExpiry.secondsFrom1970(maxTimeFrom1970)
        
        let preferredCapacity = Int(floor(Double(memoryCapacity) * 0.7))
        
        let purgingConfiguration = StorehouseConfigurationAutoPurging(expiry: expiry,
                                                         memory: memoryCapacity,
                                                         preferredMemoryUsageAfterPurge: preferredCapacity)
        
        let diskConfiguration    = StorehouseConfigurationDisk(name: pathString,
                                                  expiry: expiry,
                                                  maxSize: diskCapacity,
                                                  protectionType: nil)
        
        let transformer : StorehouseTransformer<CachedURLResponse>
        switch settings.securedStorage {
        case true : transformer = WarehouseTransformerFactory.forSecuredCoding(ofType: CachedURLResponse.self)
        case false: transformer = WarehouseTransformerFactory.forCoding       (ofType: CachedURLResponse.self)
        }
        
        if onlyUpdate {
            try? self.warehouse.updateCacheCapacity(purgingConfig: purgingConfiguration, diskConfig: diskConfiguration, transformer: transformer)
        }
        else {
            self.warehouse = try? Warehouse(purgingConfig: purgingConfiguration, diskConfig: diskConfiguration, transformer: transformer)
        }
    }
    
    ///
    /// Check for network connectivity, assume connection if delegate not available
    ///
    fileprivate func networkAvailable() -> Bool
    {
        return delegate?.networkAvailable?(for: self) ?? true
    }
}
