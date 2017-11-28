//
//  CLDUrl.swift
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
 The CLDUrl class represents a URL to a remote asset either on your Cloudinary cloud, or from another remote source.
*/
@objc open class CLDUrl: NSObject {
    
    fileprivate struct CLDUrlConsts {
        static let CLD_OLD_AKAMAI_CHARED_CDN = "cloudinary-a.akamaihd.net"
        static let CLD_SHARED_CDN = "res\(CLD_COM)"
        static let CLD_COM = ".cloudinary.com"
    }

    /**
     The Cloudinary public ID of the resource
    */
    fileprivate var publicId: String?
    /**
     The current Cloudinary session configuration.
    */
    fileprivate var config: CLDConfiguration!
    
    /**
     The media source of the URL. default is upload.
     */
    fileprivate var type: String = String(describing: CLDType.upload)
    
    /**
     The resource type of the remote asset that the URL points to. default is image.
     */
    fileprivate var resourceType: String = String(describing: CLDUrlResourceType.image)
    
    /**
     The format of the remote asset that the URL points to.
     */
    fileprivate var format: String?
    
    /**
     The version of the remote asset that the URL points to.
     */
    fileprivate var version: String?
    
    /**
     A suffix to the URL that points to the remote asset (private CDN only, image/upload and raw/upload only).
     */
    fileprivate var suffix: String?
    
    /**
     A boolean parameter indicating whether or not to use a root path instead of a full path (image/upload only).
     */
    fileprivate var useRootPath: Bool = false
    
    /**
     A boolean parameter indicating whether or not to use a shorten URL (image/upload only).
     */
    fileprivate var shortenUrl: Bool = false
    
    /**
     The transformation to be apllied on the remote asset.
     */
    fileprivate var transformation: CLDTransformation?
    
    // MARK: - Init
    
    fileprivate override init() {
        super.init()
    }
    
    internal init(configuration: CLDConfiguration) {
        config = configuration
        super.init()
    }

    // MARK: - Set Values
    
    /**
    Set the media source of the URL.
    
    - parameter type:       the media source to set.
    
    - returns:               the same instance of CLDUrl.
    */
    open func setPublicId(_ publicId: String) -> CLDUrl {
        self.publicId = publicId
        return self
    }

    /**
    Set the media source of the URL.

    - parameter type:       the media source to set.

    - returns:               the same instance of CLDUrl.
    */
    @objc(setTypeFromType:)
    open func setType(_ type: CLDType) -> CLDUrl {
        return setType(String(describing: type))
    }

    /**
     Set the media source of the URL.
     
     - parameter type:       the media source to set.
     
     - returns:               the same instance of CLDUrl.
     */
    open func setType(_ type: String) -> CLDUrl {
        self.type = type
        return self
    }
    
    /**
     Set the resource type of the asset the URL points to.
     
     - parameter resourceType:      the resource type to set.
     
     - returns:                      the same instance of CLDUrl.
     */
    @objc(setResourceTypeFromUrlResourceType:)
    open func setResourceType(_ resourceType: CLDUrlResourceType) -> CLDUrl {
        return setResourceType(String(describing: resourceType))
    }
    
    /**
     Set the resource type of the asset the URL points to.
     
     - parameter resourceType:      the resource type to set.
     
     - returns:                      the same instance of CLDUrl.
     */
    open func setResourceType(_ resourceType: String) -> CLDUrl {
        self.resourceType = resourceType
        return self
    }
    
    /**
     Set the format of the asset the URL points to.
     
     - parameter format:            the format to set.
     
     - returns:                      the same instance of CLDUrl.
     */
    open func setFormat(_ format: String) -> CLDUrl {
        self.format = format
        return self
    }
    
    
    /**
     Set the version of the asset the URL points to.
     
     - parameter format:            the format to set.
     
     - returns:                      the same instance of CLDUrl.
     */
    open func setVersion(_ version: String) -> CLDUrl {
        self.version = version
        return self
    }
    
    /**
     Set the suffix of the URL. (private CDN only, image/upload and raw/upload only).
     
     - parameter suffix:            the suffix to set.
     
     - returns:                      the same instance of CLDUrl.
     */
    open func setSuffix(_ suffix: String) -> CLDUrl {
        self.suffix = suffix
        return self
    }
    
    /**
     Set whether or not to use a root path instead of a full path. (image/upload only).
     
     - parameter useRootPath:       A boolean parameter indicating whether or not to use a root path instead of a full path.
     
     - returns:                      the same instance of CLDUrl.
     */
    open func setUseRootPath(_ useRootPath: Bool) -> CLDUrl {
        self.useRootPath = useRootPath
        return self
    }
    
    /**
     Set whether or not to use a shorten URL. (image/upload only).
     
     - parameter shortenUrl:       A boolean parameter indicating whether or not to use a shorten URL.
     
     - returns:                      the same instance of CLDUrl.
     */
    open func setShortenUrl(_ shortenUrl: Bool) -> CLDUrl {
        self.shortenUrl = shortenUrl
        return self
    }
    
    /**
     Set the transformation to be apllied on the remote asset.
     
     - parameter transformation:    The transformation to be apllied on the remote asset.
     
     - returns:                      the same instance of CLDUrl.
     */
    @discardableResult
    open func setTransformation(_ transformation: CLDTransformation) -> CLDUrl {
        self.transformation = transformation
        return self
    }
    
    // MARK: - Actions    

    /**
     Generate a string URL representation of the CLDUrl.

     - parameter signUrl:       A boolean parameter indicating whether or not to generate a signature out of the API secret and add it to the generated URL. Default is false.

     - returns:                  The generated string URL representation.
     */
    open func generate(signUrl: Bool = false) -> String? {
        if let publicId = self.publicId {
            return generate(publicId, signUrl: signUrl)
        } else {
            return nil
        }
    }

    /**
     Generate a string URL representation of the CLDUrl.
     
     - parameter publicId:      The remote asset's name (e.g. the public id of an uploaded image).
     - parameter signUrl:       A boolean parameter indicating whether or not to generate a signature out of the API secret and add it to the generated URL. Default is false.
     
     - returns:                  The generated string URL representation.
     */
    open func generate(_ publicId: String, signUrl: Bool = false) -> String? {
        
        if signUrl && config.apiSecret == nil {
            printLog(.error, text: "Must supply api_secret for signing urls")
            return nil
        }
        
        var sourceName = publicId
        var resourceType = self.resourceType
        var type = self.type
        var version = self.version ?? String()
        var format = self.format
        
        
        let preloadedComponentsMatch = GenerateUrlRegex.preloadedRegex.matches(in: sourceName, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, sourceName.count))
        if preloadedComponentsMatch.count > 0 {
            if let preloadedComponents = preloadedComponentsMatch.first {
                resourceType = (sourceName as NSString).substring(with: preloadedComponents.rangeAt(1))
                type = (sourceName as NSString).substring(with: preloadedComponents.rangeAt(2))
                version = (sourceName as NSString).substring(with: preloadedComponents.rangeAt(3))
                sourceName = (sourceName as NSString).substring(with: preloadedComponents.rangeAt(4))
            }
        }
        
        let transformation = self.transformation ?? CLDTransformation()
        if let unwrappedFormat = format , !unwrappedFormat.isEmpty && type == String(describing: CLDType.fetch) {
            transformation.setFetchFormat(unwrappedFormat)
            format = nil
        }
        
        guard let transformationStr = transformation.asString() else {
                printLog(.error, text: "An invalid transformation was added.")
                return nil
        }
        
        if  version.isEmpty &&
            sourceName.contains("/") &&
            sourceName.range(of: "^v[0-9]+/.*", options: NSString.CompareOptions.regularExpression, range: nil, locale: nil) == nil &&
            sourceName.range(of: "^https?:/.*", options: [NSString.CompareOptions.regularExpression, NSString.CompareOptions.caseInsensitive], range: nil, locale: nil) == nil
        {
            version = "1"
        }
        
        if !version.isEmpty {
            version = "v\(version)"
        }
        
        var toSign: String = String()
        if !transformationStr.isEmpty {
            toSign.append("\(transformationStr)/")
        }
        
        if sourceName.range(of: "^https?:/.*", options: [NSString.CompareOptions.regularExpression, NSString.CompareOptions.caseInsensitive], range: nil, locale: nil) != nil {
            if let encBasename = sourceName.cldSmartEncodeUrl() {
                toSign.append(encBasename)
                sourceName = encBasename
            }
        }
        else {
            if let encBasename = sourceName.removingPercentEncoding?.cldSmartEncodeUrl() {
                toSign.append(encBasename)
                sourceName = encBasename
            }
            
            if let suffix = suffix , !suffix.isEmpty {
                if suffix.range(of: "[/\\.]", options: NSString.CompareOptions.regularExpression, range: nil, locale: nil) != nil {
                    printLog(.error, text: "URL Suffix should not include . or /")
                    return nil
                }
                sourceName = "\(sourceName)/\(suffix)"
            }
            
            if let unwrappedFormat = format {
                sourceName = "\(sourceName).\(unwrappedFormat)"
                toSign.append(".\(unwrappedFormat)")
            }
        }
        
        let prefix = finalizePrefix(sourceName)
        guard let resourceTypeAndType = finalizeResourceTypeAndType(resourceType, type: type)
            else {
                return nil
        }
        
        var signature = String()
        if signUrl {
            if let apiSecret = config.apiSecret {
                toSign.append(apiSecret)
            }
            let encoded = toSign.sha1_base64()
            signature = "s--\(encoded[0...7])--"
        }
        
        let url = [prefix, resourceTypeAndType, signature, transformationStr, version , sourceName].joined(separator: "/")
        
        let regex = try! NSRegularExpression(pattern: "([^:])\\/+", options: NSRegularExpression.Options.caseInsensitive)
        
        return regex.stringByReplacingMatches(in: url, options: [], range: NSMakeRange(0, url.count), withTemplate: "$1/")
    }
    
    fileprivate struct GenerateUrlRegex {
        fileprivate static let preloadedRegexString = "^([^/]+)/([^/]+)/v([0-9]+)/([^#]+)(#[0-9a-f]+)?$"
        static let preloadedRegex: NSRegularExpression = {
            return try! NSRegularExpression(pattern:preloadedRegexString, options: NSRegularExpression.Options.caseInsensitive)
        }()
    }
    
    // MARK: - Helpers
    
    fileprivate func finalizePrefix(_ basename: String) -> String {
        var prefix = String()

        if config.secure {
            var secureDistribution = String()
            if let secureDist = config.secureDistribution , (secureDist != CLDUrlConsts.CLD_OLD_AKAMAI_CHARED_CDN && !secureDist.isEmpty) {
                secureDistribution = secureDist
            }
            else {
                secureDistribution = config.privateCdn ? "\(config.cloudName!)-\(CLDUrlConsts.CLD_SHARED_CDN)" : CLDUrlConsts.CLD_SHARED_CDN
            }
            
            if config.secureCdnSubdomain {
                let sharedDomain = "res-\(basename.toCRC32() % 5 + 1)\(CLDUrlConsts.CLD_COM)"
                secureDistribution = secureDistribution.replacingOccurrences(of: CLDUrlConsts.CLD_SHARED_CDN, with: sharedDomain)
            }
            
            prefix = "https://\(secureDistribution)"
        }
        else if let cname = config.cname {
            prefix = "http://"
            if config.cdnSubdomain {
                prefix += "a\(basename.toCRC32() % 5 + 1)."
            }
            
            prefix += cname
        }
        else {
            prefix = "http://"
            if config.privateCdn {
                prefix += "\(config.cloudName!)-"
            }
            prefix += "res"
            if config.cdnSubdomain {
                prefix += "-\(basename.toCRC32() % 5 + 1)"
            }
            prefix += CLDUrlConsts.CLD_COM
        }
        
        if !config.privateCdn {
            prefix += "/\(config.cloudName!)"
        }
        return prefix
    }
    
    fileprivate func finalizeResourceTypeAndType(_ resourceType: String, type: String) -> String? {
        if !config.privateCdn, let urlSuffix = suffix , !urlSuffix.isEmpty {
            printLog(.error, text: "URL Suffix only supported in private CDN")
            return nil
        }
        
        var resourceTypeAndType = "\(resourceType)/\(type)"
        if let urlSuffix = suffix , !urlSuffix.isEmpty {
            if resourceTypeAndType == "\(String(describing: CLDUrlResourceType.image))/\(String(describing: CLDType.upload))" {
               resourceTypeAndType = "images"
            }
            else if resourceTypeAndType == "\(String(describing: CLDUrlResourceType.image))/\(String(describing: CLDType.private))" {
                resourceTypeAndType = "private_images"
            }
            else if resourceTypeAndType == "\(String(describing: CLDUrlResourceType.raw))/\(String(describing: CLDType.upload))" {
                resourceTypeAndType = "files"
            }
            else {
                printLog(.error, text: "URL Suffix only supported for image/upload, image/private and raw/upload")
                return nil
            }
        }
        
        if useRootPath {
            if resourceTypeAndType == "\(String(describing: CLDUrlResourceType.image))/\(String(describing: CLDType.upload))" || resourceTypeAndType == "images" {
               resourceTypeAndType = String()
            }
            else {
                printLog(.error, text: "Root path only supported for image/upload")
                return nil
            }
        }
        
        if shortenUrl && resourceTypeAndType == "\(String(describing: CLDUrlResourceType.image))/\(String(describing: CLDType.upload))" {
            resourceTypeAndType = "iu"
        }
        
        return resourceTypeAndType
    }
    
   
}








