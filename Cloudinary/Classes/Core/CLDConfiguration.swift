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
@objcMembers open class CLDConfiguration: NSObject {
    
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
     A boolean value specifying whether or not to use long encryption. false by default.
     */
    open fileprivate(set) var longUrlSignature: Bool = false
    
    /**
     An enum value specifying the desired hash algorithm. sha1 by default.
     */
    open fileprivate(set) var signatureAlgorithm: SignatureAlgorithm = .sha1

    /**
        A int value specifying the signature version to use.
     */
    open fileprivate(set) var signatureVesion : Int = 2

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
    
    /**
     A custom timeout in milliseconds to be used instead of Cloudinary's default timeout. nil by default.
     */
    open fileprivate(set) var timeout: NSNumber?

    /**
     A boolean value specifying whether or not to use analytics. true by default.
    */
    open var analytics: Bool = true


    /**
     An analytics object
    */
    open var analyticsObject: CLDAnalytics = CLDAnalytics()


    internal var userPlatform: CLDUserPlatform?
    
    // MARK: - Init
    fileprivate override init() {
        super.init()
    }
    
    /**
     Initializes a CLDConfiguration instance, using the URL specified in the environment parameters under `CLOUDINARY_URL`.
     The URL should be in this form: `cloudinary://<API_KEY>:<API_SECRET>@<CLOUD_NAME>`.
     Extra parameters may be added to the url: `secure` (boolean), `cdn_subdomain` (boolean), `secure_cdn_distribution` (boolean), `long_url_signature`(boolean), `cname`, `upload_prefix`, `signature_algorithm`
     
     - returns:                             A new `CLDConfiguration` instance if the environment parameter URL exists and is valid, otherwise returns nil.
     
     */
    public static func initWithEnvParams() -> CLDConfiguration? {
        let dict = ProcessInfo.processInfo.environment
        if let url = dict[Defines.ENV_VAR_CLOUDINARY_URL], validateUrl(url: url) {
            return CLDConfiguration(cloudinaryUrl: url)
        }
        
        return nil
    }
    
    internal static func validateUrl(url: String) -> Bool{
        return url.starts(with: "cloudinary://")
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
                case .LongUrlSignature:
                    if let value = options[ConfigParam.LongUrlSignature.rawValue] as? Bool {
                        longUrlSignature = value
                    }
                    else if let value = options[ConfigParam.LongUrlSignature.rawValue] as? String {
                        longUrlSignature = value.cldAsBool()
                    }
                    break
                case .SignatureAlgorithm:
                    if let value = options[ConfigParam.SignatureAlgorithm.rawValue] as? SignatureAlgorithm {
                        signatureAlgorithm = value
                    }
                    else if let value = options[ConfigParam.SignatureAlgorithm.rawValue] as? String {
                        signatureAlgorithm = SignatureAlgorithm(stringValue: value)
                    }
                    break
                case .SignatureVersion:
                    if let value = options[ConfigParam.SignatureVersion.rawValue] as? Int {
                        signatureVesion = value
                    }
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
                case .Timeout:
                    if let value = options[ConfigParam.Timeout.rawValue] as? NSNumber {
                        timeout = value
                    }
                    else if let value = options[ConfigParam.Timeout.rawValue] as? String {
                        timeout = value.cldAsNSNumber()
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
     - parameter longUrlSignature:          A boolean value specifying whether or not to use long encryption. false by default.
     - parameter signatureAlgorithm:        An enum value specifying the desired hash algorithm. sha1 by default.
     - parameter secureDistribution:        Set your secure distribution domain to be set when using a secure distribution (advanced plan only). nil by default.
     - parameter cname:                     Set your custom domain. nil by default.
     - parameter uploadPrefix:              Set a custom upload prefix to be used instead of Cloudinary's default API prefix. nil by default.
     - parameter timeout:                   A custom timeout in milliseconds to be used instead of Cloudinary's default timeout. nil by default.
     
     - returns:                             A new `CLDConfiguration` instance.
     
     */
    public init(
        cloudName: String,
        apiKey: String? = nil,
        apiSecret: String? = nil,
        privateCdn: Bool = false,
        secure: Bool = false,
        cdnSubdomain: Bool = false,
        secureCdnSubdomain: Bool = false,
        longUrlSignature: Bool = false,
        signatureAlgorithm: SignatureAlgorithm = .sha1,
        signatureVersion: Int = 2,
        secureDistribution: String? = nil,
        cname: String? = nil,
        uploadPrefix: String? = nil,
        timeout: NSNumber? = nil,
        analytics: Bool = true
    ) {
        self.cloudName = cloudName
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.privateCdn = privateCdn
        self.secure = secure
        self.cdnSubdomain = cdnSubdomain
        self.secureCdnSubdomain = secureCdnSubdomain
        self.longUrlSignature = longUrlSignature
        self.signatureAlgorithm = signatureAlgorithm
        self.signatureVesion = signatureVersion
        self.secureDistribution = secureDistribution
        self.cname = cname
        self.uploadPrefix = uploadPrefix
        self.timeout = timeout
        self.analytics = analytics
        super.init()
    }
    
    /**
     Initializes a CLDConfiguration instance, using a given URL.
     The URL should be in this form: `cloudinary://<API_KEY>:<API_SECRET>@<CLOUD_NAME>`.
     Extra parameters may be added to the url: `secure` (boolean), `cdn_subdomain` (boolean), `secure_cdn_distribution` (boolean), `long_url_signature`(boolean), `cname`, `upload_prefix`, `signature_algorithm`
     
     - returns:                             A new `CLDConfiguration` instance if the URL is valid, otherwise returns nil.
     
     */
    public init?(cloudinaryUrl: String) {
        super.init()
        
        guard let
            uri = URL(string: cloudinaryUrl),
            CLDConfiguration.validateUrl(url: cloudinaryUrl),
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
            let index1 = uri.path.index(uri.path.startIndex, offsetBy: 1)
            secureDistribution = String(uri.path[index1...])
        }
        
        if let queryItems = URLComponents(url: uri, resolvingAgainstBaseURL: false)?.queryItems {
            for item in queryItems
            {
                guard let value = item.value else { continue }
                
                switch ConfigParam(rawValue: item.name) {
                case .Secure: secure = value.cldAsBool()
                case .CdnSubdomain: cdnSubdomain = value.cldAsBool()
                case .SecureCdnSubdomain: secureCdnSubdomain = value.cldAsBool()
                case .LongUrlSignature: longUrlSignature = value.cldAsBool()
                case .SignatureAlgorithm: signatureAlgorithm = SignatureAlgorithm(stringValue: value)
                case .SignatureVersion: signatureVesion = Int(value) ?? 2
                case .CName: cname = value
                case .UploadPrefix: uploadPrefix = value
                case .Timeout: timeout = value.cldAsNSNumber()
                case .Analytics: analytics = value.cldAsBool()
                default:
                    continue
                }
            }
        }
    }
    
    // MARK: Optional Url Params
    internal enum ConfigParam: String, CustomStringConvertible {
        
        case Secure             = "secure"
        case CdnSubdomain       = "cdn_subdomain"
        case SecureCdnSubdomain = "secure_cdn_subdomain"
        case LongUrlSignature   = "long_url_signature"
        case SignatureAlgorithm = "signature_algorithm"
        case SignatureVersion   = "signature_version"
        case CName              = "cname"
        case UploadPrefix       = "upload_prefix"
        case APIKey             = "api_key"
        case APISecret          = "api_secret"
        case CloudName          = "cloud_name"
        case PrivateCdn         = "private_cdn"
        case SecureDistribution = "secure_distribution"
        case Timeout            = "timeout"
        case Analytics          = "analytics"
        
        internal var description: String {
            switch self {
            case .Secure:               return "secure"
            case .CdnSubdomain:         return "cdn_subdomain"
            case .SecureCdnSubdomain:   return "secure_cdn_subdomain"
            case .LongUrlSignature:     return "long_url_signature"
            case .SignatureAlgorithm:   return "signature_algorithm"
            case .SignatureVersion:     return "signature_version"
            case .CName:                return "cname"
            case .UploadPrefix:         return "upload_prefix"
            case .APIKey:               return "api_key"
            case .APISecret:            return "api_secret"
            case .CloudName:            return "cloud_name"
            case .PrivateCdn:           return "private_cdn"
            case .SecureDistribution:   return "secure_distribution"
            case .Timeout:              return "timeout"
            case .Analytics:            return "analytics"
            }
        }
    }
    
    
    // MARK: signatureAlgorithm
    @objc public enum SignatureAlgorithm: Int, CustomStringConvertible {
        
        case sha1   = 0
        case sha256 = 1
        
        public init(stringValue: String) {
            switch stringValue {
            case "sha1":   self = .sha1
            case "sha256": self = .sha256
            default:       self = .sha1
            }
        }
        
        public var description: String {
            switch self {
            case .sha1:   return "sha1"
            case .sha256: return "sha256"
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
