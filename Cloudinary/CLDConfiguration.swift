//
//  CLDConfiguration.swift
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

/**
 The CLDConfiguration class holds the configuration parameters to be used by the `CLDCloudinary` instance.
*/
@objc open class CLDConfiguration: NSObject {

    fileprivate struct Defines {
        fileprivate static let ENV_VAR_CLOUDINARY_URL = "CLOUDINARY_URL"
    }
    
    /**
     Your account's cloud name on Cloudinary.
    */
    open fileprivate(set) var cloudName: String!
    
    /**
     Your account's API key, can be found in your account's dashboard on Cloudinary as part of the account details.
     */
    open fileprivate(set) var apiKey: String?
    
    /**
     Your account's API secret, can be found in your account's dashboard on Cloudinary as part of the account details.
     */
    open fileprivate(set) var apiSecret: String?
    
    /**
     A boolean value specifying whether or not to use a private CDN. false by default.
     */
    open fileprivate(set) var privateCdn: Bool = false
    
    /**
     A boolean value specifying whether or not to use a secure CDN connection. false by default.
     */
    open fileprivate(set) var secure: Bool = true
    
    /**
     A boolean value specifying whether or not to use a CDN subdomain. false by default.
     */
    open fileprivate(set) var cdnSubdomain: Bool = false
    
    /**
     A boolean value specifying whether or not to use a secure connection with a CDN subdomain. false by default.
     */
    open fileprivate(set) var secureCdnSubdomain: Bool = false
    
    /**
     Your secure distribution domain to be set when using a secure distribution (advanced plan only). nil by default.
     */
    open fileprivate(set) var secureDistribution: String?
    
    /**
     Your custom domain. nil by default.
     */
    open fileprivate(set) var cname: String?
    
    /**
     A custom upload prefix to be used instead of Cloudinary's default API prefix. nil by default.
     */
    open fileprivate(set) var uploadPrefix: String?
    
    internal var userPlatform : CLDUserPlatform?
    
    // MARK: - Init
    
    fileprivate override init() {
        super.init()
    }
    
    /**
     Initializes a CLDConfiguration instance, using the URL specified in the environment parameters under `CLOUDINARY_URL`.
     The URL should be in this form: `cloudinary://<API_KEY>:<API_SECRET>@<CLOUD_NAME>`.
     Extra parameters may be added to the url: `secure` (boolean), `cdn_subdomain` (boolean), `secure_cdn_distribution` (boolean), `cname`, `upload_prefix`
     
     - returns:                             A new `CLDConfiguration` instance if the environment parameter URL exists and is valid, otherwise returns nil.
     
     */
    open static func initWithEnvParams() -> CLDConfiguration? {
        let dict = ProcessInfo.processInfo.environment
        if let url = dict[Defines.ENV_VAR_CLOUDINARY_URL] {
            return CLDConfiguration(cloudinaryUrl: url)
        }
        
        return nil
    }
    
    public init?(options: [String : AnyObject]) {
        guard let
            cloudName = options[ConfigParam.CloudName.rawValue] as? String else {
                return nil
        }
        
        
        self.cloudName = cloudName
        
        for key in options.keys {
            if let option = ConfigParam(rawValue: key) {
                switch option {
                case .Secure:
                    if let value = options[ConfigParam.Secure.rawValue] as? Bool {
                        secure = value
                    }
                    else if let value = options[ConfigParam.Secure.rawValue] as? String {
                        secure = value.cldAsBool()
                    }
                    break
                case .CdnSubdomain:
                    if let value = options[ConfigParam.CdnSubdomain.rawValue] as? Bool {
                        cdnSubdomain = value
                    }
                    else if let value = options[ConfigParam.CdnSubdomain.rawValue] as? String {
                        cdnSubdomain = value.cldAsBool()
                    }
                    break
                case .SecureCdnSubdomain:
                    if let value = options[ConfigParam.SecureCdnSubdomain.rawValue] as? Bool {
                        secureCdnSubdomain = value
                    }
                    else if let value = options[ConfigParam.SecureCdnSubdomain.rawValue] as? String {
                        secureCdnSubdomain = value.cldAsBool()
                    }
                    break
                case .CName:
                    if let value = options[ConfigParam.CName.rawValue] as? String {
                        cname = value
                    }
                    break                    
                case .UploadPrefix:
                    if let value = options[ConfigParam.UploadPrefix.rawValue] as? String {
                        uploadPrefix = value
                    }
                    break
                    
                case .APISecret:
                    if let value = options[ConfigParam.APISecret.rawValue] as? String {
                        apiSecret = value
                    }
                    break
                case .APIKey:
                    if let value = options[ConfigParam.APIKey.rawValue] as? String {
                        apiKey = value
                    }
                    break
                case .PrivateCdn:
                    if let value = options[ConfigParam.PrivateCdn.rawValue] as? Bool {
                        privateCdn = value
                    }
                    else if let value = options[ConfigParam.PrivateCdn.rawValue] as? String {
                        privateCdn = value.cldAsBool()
                    }
                    break
                case .SecureDistribution:
                    if let value = options[ConfigParam.SecureDistribution.rawValue] as? String {
                        secureDistribution = value
                    }
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    /**
     Initializes a CLDConfiguration instance with the specified parameters.
     
     - parameter cloudName:                 Your account's cloud name on Cloudinary.
     - parameter apiKey:                    Your account's API key, can be found in your account's dashboard on Cloudinary as part of the account details.
     - parameter apiSecret:                 Your account's API secret, can be found in your account's dashboard on Cloudinary as part of the account details.
     - parameter privateCdn:                A boolean value specifying whether or not to use a private CDN. false by default.
     - parameter secure:                    A boolean value specifying whether or not to use a secure CDN connection. false by default.
     - parameter cdnSubdomain:              A boolean value specifying whether or not to use a CDN subdomain. false by default.
     - parameter secureCdnSubdomain:        A boolean value specifying whether or not to use a secure connection with a CDN subdomain. false by default.
     - parameter secureDistribution:        Set your secure distribution domain to be set when using a secure distribution (advanced plan only). nil by default.
     - parameter cname:                     Set your custom domain. nil by default.
     - parameter uploadPrefix:              Set a custom upload prefix to be used instead of Cloudinary's default API prefix. nil by default.
     
     - returns:                             A new `CLDConfiguration` instance.
     
     */
    public init(cloudName: String, apiKey: String? = nil, apiSecret: String? = nil, privateCdn: Bool = false, secure: Bool = false, cdnSubdomain: Bool = false, secureCdnSubdomain: Bool = false, secureDistribution: String? = nil, cname: String? = nil, uploadPrefix: String? = nil) {
        self.cloudName = cloudName
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.privateCdn = privateCdn
        self.secure = secure
        self.cdnSubdomain = cdnSubdomain
        self.secureCdnSubdomain = secureCdnSubdomain
        self.secureDistribution = secureDistribution
        self.cname = cname
        self.uploadPrefix = uploadPrefix
        super.init()
    }
    
    /**
     Initializes a CLDConfiguration instance, using a given URL.
     The URL should be in this form: `cloudinary://<API_KEY>:<API_SECRET>@<CLOUD_NAME>`.
     Extra parameters may be added to the url: `secure` (boolean), `cdn_subdomain` (boolean), `secure_cdn_distribution` (boolean), `cname`, `upload_prefix`
     
     - returns:                             A new `CLDConfiguration` instance if the URL is valid, otherwise returns nil.
     
     */
    public init?(cloudinaryUrl: String) {
        super.init()
        
        guard let
            uri = URL(string: cloudinaryUrl),
            let cloudName = uri.host
            else {
                return nil
        }
        
        self.cloudName = cloudName

        if let apiKey = uri.user {
            self.apiKey = apiKey
        }
        if let apiSecret = uri.password {
            self.apiSecret = apiSecret
        }
        
        if !uri.path.isEmpty {
            privateCdn = true
            let index1 = uri.path.characters.index(uri.path.startIndex, offsetBy: 1)
            secureDistribution = uri.path.substring(from: index1)
        }        
        
        if let params = uri.query?.components(separatedBy: "&") {
            for param in params {
                let keyValue = param.components(separatedBy: "=")
                if keyValue.count < 2 {
                    continue
                }
                else {
                    if let key = ConfigParam(rawValue: keyValue[0]) {
                        switch (key) {
                        case .Secure: secure = keyValue[1].cldAsBool()
                        case .CdnSubdomain: cdnSubdomain = keyValue[1].cldAsBool()
                        case .SecureCdnSubdomain: secureCdnSubdomain = keyValue[1].cldAsBool()
                        case .CName: cname = keyValue[1]
                        case .UploadPrefix: uploadPrefix = keyValue[1]
                            
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Optional Url Params
    
    internal enum ConfigParam: String, CustomStringConvertible {
        case Secure =               "secure"
        case CdnSubdomain =         "cdn_subdomain"
        case SecureCdnSubdomain =   "secure_cdn_subdomain"
        case CName =                "cname"
        case UploadPrefix =         "upload_prefix"
        
        case APIKey =               "api_key"
        case APISecret =            "api_secret"
        case CloudName =            "cloud_name"
        case PrivateCdn =           "private_cdn"
        case SecureDistribution =   "secure_distribution"
        
        internal var description: String {
            get {
                switch self {
                case .Secure:               return "secure"
                case .CdnSubdomain:         return "cdn_subdomain"
                case .SecureCdnSubdomain:   return "secure_cdn_subdomain"
                case .CName:                return "cname"
                case .UploadPrefix:         return "upload_prefix"
                case .APIKey:               return "api_key"
                case .APISecret:            return "api_secret"
                case .CloudName:            return "cloud_name"
                case .PrivateCdn:           return "private_cdn"
                case .SecureDistribution:   return "secure_distribution"
                }
            }
        }
        
    }
    
    // MARK: User Platform
    
    internal func setUserPlatform(_ platformName: String, version: String) {
        userPlatform = CLDUserPlatform(platform: platformName, version: version)
    }
    
    internal func clearUserPlatform() {
        userPlatform = nil
    }
    
    internal struct CLDUserPlatform {
        var platform: String
        var version: String
        
        init(platform: String, version: String) {
            self.platform = platform
            self.version = version
        }
    }
}
