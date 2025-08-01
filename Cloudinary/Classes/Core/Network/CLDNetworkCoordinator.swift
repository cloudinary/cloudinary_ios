//
//  NetworkCoordinator.swift
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

internal class CLDNetworkCoordinator: NSObject {

    static let DEFAULT_VERSION =        "5.2.2"
    
    fileprivate struct CLDNetworkCoordinatorConsts {
        static let BASE_CLOUDINARY_URL =    "https://api.cloudinary.com"
        static let API_KEY =                "api_key"
    }
    
    fileprivate var config: CLDConfiguration
    fileprivate var networkAdapter: CLDNetworkAdapter
    fileprivate var extraHeaders: [String: String]?

    // MARK: - Init
    
    init(configuration: CLDConfiguration, networkAdapter: CLDNetworkAdapter = CLDDefaultNetworkAdapter.sharedAdapter) {
        config = configuration
        self.networkAdapter = networkAdapter
    }

    init(configuration: CLDConfiguration, sessionConfiguration: URLSessionConfiguration) {
        config = configuration
        self.networkAdapter = CLDDefaultNetworkAdapter(configuration: sessionConfiguration)
    }

    // MARK: - Actions
    
    internal func callAction(_ action: CLDAPIAction, params: CLDRequestParams) -> CLDNetworkDataRequest {
        
        let url = getUrl(action, resourceType: params.resourceType)
        let headers = getHeaders()
        
        params.setTimeout(from: config)
        let requestParams = getSignedRequestParams(params)
        
        return networkAdapter.cloudinaryRequest(url, headers: headers, parameters: requestParams)
    }
    
    internal func upload(_ data: Any, params: CLDUploadRequestParams, extraHeaders: [String:String]?=[:]) -> CLDNetworkDataRequest {
        let url = getUrl(.Upload, resourceType: params.resourceType)
        params.setTimeout(from: config)
        let requestParams = params.signed ? getSignedRequestParams(params) : params.params
        var headers :[String : String] = getHeaders()
        headers.cldMerge(self.extraHeaders) //User's configured extra headers
        headers.cldMerge(extraHeaders)
        return networkAdapter.uploadToCloudinary(url, headers: headers, parameters: requestParams,  data: data)
    }
    
    internal func download(_ url: String) -> CLDNetworkDataRequest {
        return networkAdapter.downloadFromCloudinary(url)
    }
    
    // MARK: - Helpers
    
    fileprivate func getSignedRequestParams(_ requestParams: CLDRequestParams) -> [String : Any] {
        var params: [String : Any] = requestParams.params
        
        guard let apiKey = requestParams.apiKey ?? config.apiKey else {
            printLog(.error, text: "Must supply api key for a signed request")
            return params
        }
        
        if let signatureObj = requestParams.signature {
            params[CLDSignature.SignatureParam.Signature.rawValue] = signatureObj.signature
            params[CLDSignature.SignatureParam.Timestamp.rawValue] = cldParamValueAsString(value: signatureObj.timestamp)
        }
        else if let apiSecret = config.apiSecret {
            let timestamp = Int(Date().timeIntervalSince1970)
            params[CLDSignature.SignatureParam.Timestamp.rawValue] = cldParamValueAsString(value: timestamp)
            
            let signature = cloudinarySignParamsUsingSecret(getSignParams(from: params), cloudinaryApiSecret: apiSecret, signatureVersion: config.signatureVesion)
            params[CLDSignature.SignatureParam.Signature.rawValue] = signature
        }
        else {
            printLog(.error, text: "Must supply api secret for a signed request")
        }
        
        params[CLDNetworkCoordinatorConsts.API_KEY] = apiKey
        return params
    }
    
    fileprivate func getSignParams(from params: [String : Any]) -> [String : Any] {
        var signatureParams = params
        signatureParams.removeValue(forKey: CLDConfiguration.ConfigParam.Timeout.description)
        return signatureParams
    }
    
    fileprivate func getUrl(_ action: CLDAPIAction, resourceType: String?) -> String {
        var urlComponents: [String] = []
        let prefix = config.uploadPrefix ?? CLDNetworkCoordinatorConsts.BASE_CLOUDINARY_URL
        urlComponents.append(prefix)
        urlComponents.append("v1_1")
        urlComponents.append(config.cloudName)
        if action != CLDAPIAction.DeleteByToken {
            let rescourceType = resourceType ?? String(describing: CLDUrlResourceType.image)
            urlComponents.append(rescourceType)
        }
        urlComponents.append(action.rawValue)
        return urlComponents.joined(separator: "/")
    }
    
    fileprivate func getHeaders() -> [String : String] {
        var headers: [String : String] = [:]
        var userAgent: String
        if let userPlatform = config.userPlatform {
            userAgent = "\(userPlatform.platform)/\(userPlatform.version) CloudinaryiOS/\(CLDNetworkCoordinator.getVersion())"
        }
        else {
            userAgent = "CloudinaryiOS/\(CLDNetworkCoordinator.getVersion())"
        }

        userAgent += " (\(UIDevice.current.model); \(UIDevice.current.systemName) \(UIDevice.current.systemVersion))"

        headers["User-Agent"] = userAgent
        headers["X-Requested-With"] = "XMLHttpRequest"

        return headers
    }
    
    static func getVersion() -> String {
        let version = DEFAULT_VERSION
        return version
    }
    
    internal enum CLDAPIAction: String, CustomStringConvertible {
        case Upload =                       "upload"
        case Rename =                       "rename"
        case Destroy =                      "destroy"
        case Tags =                         "tags"
        case Explicit =                     "explicit"
        case Explode =                      "explode"
        case GenerateArchive =              "generate_archive"
        case GenerateSprite =               "sprite"
        case Multi =                        "multi"
        case GenerateText =                 "text"
        case DeleteByToken =                "delete_by_token"
        
        var description: String {
            switch self {
            case .Upload:                   return "upload"
            case .Rename:                   return "rename"
            case .Destroy:                  return "destroy"
            case .Tags:                     return "tags"
            case .Explicit:                 return "explicit"
            case .Explode:                  return "explode"
            case .GenerateArchive:          return "generate_archive"
            case .GenerateSprite:           return "sprite"
            case .Multi:                    return "multi"
            case .GenerateText:             return "text"
            case .DeleteByToken:            return "delete_by_token"
            }
        }
    }
    
    // MARK: - Public
        
    internal func setBackgroundCompletionHandler(_ newValue: (() -> ())?) {
        networkAdapter.setBackgroundCompletionHandler(newValue)
    }
    
    internal func setMaxConcurrentDownloads(_ maxConcurrentDownloads: Int) {
        networkAdapter.setMaxConcurrentDownloads(maxConcurrentDownloads)
    }

    internal func setExtraHeaders(_ extraHeaders: [String: String]) {
        self.extraHeaders = extraHeaders
    }

    internal func getExtraHeaders() -> [String: String]? {
        return extraHeaders
    }
}

class CLDDownloadCoordinator: CLDNetworkCoordinator {

    static var enableCache = true

    static var urlCache = URLCache.init(memoryCapacity: Defines.defaultMaxMemoryCapacity, diskCapacity: Defines.defaultMaxDiskCapacity, diskPath: "")

    init(configuration: CLDConfiguration) {

        let downloadConfiguration                   = URLSessionConfiguration.default
        downloadConfiguration.httpAdditionalHeaders = CLDNSessionManager.defaultHTTPHeaders
        downloadConfiguration.urlCache              = CLDDownloadCoordinator.urlCache

        let downloadAdapter = CLDDefaultNetworkAdapter(configuration: downloadConfiguration)
        
        super.init(configuration: configuration, networkAdapter: downloadAdapter)

    }

    override init(configuration: CLDConfiguration, sessionConfiguration: URLSessionConfiguration) {
        super.init(configuration: configuration, sessionConfiguration: sessionConfiguration)
    }
    
    override init(configuration: CLDConfiguration, networkAdapter: CLDNetworkAdapter) {
        super.init(configuration: configuration, networkAdapter: networkAdapter)
    }
    
}

internal struct Defines {
    static let defaultMaxMemoryCapacity    = 30 * 1024 * 1024   // 30 MB
    static let defaultMaxDiskCapacity      = 150 * 1024 * 1024  // 150 MB
}
