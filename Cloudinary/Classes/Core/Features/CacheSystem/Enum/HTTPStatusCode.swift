//
//  HTTPStatusCode.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
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

internal enum HTTPStatusCode : Int
{
    case `continue`                       = 100
    case switchingProtocols               = 101
    case processing                       = 102
    case checkpoint                       = 103
    
    case ok                               = 200
    case created                          = 201
    case accepted                         = 202
    case nonAuthoritativeInformation      = 203
    case noContent                        = 204
    case resetContent                     = 205
    case partialContent                   = 206
    case multiStatus                      = 207
    case alreadyReported                  = 208
    case imUsed                           = 226
    
    case multipleChoices                  = 300
    case movedPermenantly                 = 301
    case found                            = 302
    case seeOther                         = 303
    case notModified                      = 304
    case useProxy                         = 305
    case temporaryRedirect                = 307
    case permanentRedirect                = 308
    
    case badRequest                       = 400
    case unauthorized                     = 401
    case paymentRequired                  = 402
    case forbidden                        = 403
    case notFound                         = 404
    case methodNotAllowed                 = 405
    case notAcceptable                    = 406
    case proxyAuthenticationRequired      = 407
    case requestTimeout                   = 408
    case conflict                         = 409
    case gone                             = 410
    case lengthRequired                   = 411
    case preconditionFailed               = 412
    case payloadTooLarge                  = 413
    case uriTooLong                       = 414
    case unsupportedMediaType             = 415
    case rangeNotSatisfiable              = 416
    case expectationFailed                = 417
    case imATeapot                        = 418
    case misdirectedRequest               = 421
    case unprocesssableEntity             = 422
    case locked                           = 423
    case failedDependency                 = 424
    case urpgradeRequired                 = 426
    case preconditionRequired             = 428
    case tooManyRequests                  = 429
    case requestHeadersFieldTooLarge      = 431
    case iisLoginTimeout                  = 440
    case nginxNoResponse                  = 444
    case iisRetryWith                     = 449
    case blockedByWindowsParentalControls = 450
    case unavailableForLegalReasons       = 451
    case nginxSSLCertificateError         = 495
    case nginxHTTPToHTTPS                 = 497
    case tokenExpired                     = 498
    case nginxClientClosedRequest         = 499
    
    case internalServerError              = 500
    case notImplemented                   = 501
    case badGateway                       = 502
    case serviceUnavailable               = 503
    case gatewayTimeout                   = 504
    case httpVersionNotSupported          = 505
    case variantAlsoNegotiates            = 506
    case insufficientStorage              = 507
    case loopDetected                     = 508
    case bandwidthLimitExceeded           = 509
    case notExtended                      = 510
    case networkAuthenticationRequired    = 511
    case siteIsFrozen                     = 530
}
extension HTTPStatusCode
{
    internal var isInformational : Bool {
        switch rawValue {
        case 100..<200: return true
        default: return false
        }
    }
    internal var isSuccess       : Bool {
        switch rawValue {
        case 200..<300: return true
        default: return false
        }
    }
    internal var isRedirection   : Bool {
        switch rawValue {
        case 300..<400: return true
        default: return false
        }
    }
    internal var isClientError   : Bool {
        switch rawValue {
        case 400..<500: return true
        default: return false
        }
    }
    internal var isServerError   : Bool {
        switch rawValue {
        case 500..<600: return true
        default: return false
        }
    }
    
    internal var localizedReason : String {
        return HTTPURLResponse.localizedString(forStatusCode: rawValue)
    }
}

// MARK: - CustomStringConvertible
extension HTTPStatusCode : CustomStringConvertible
{
    internal var description : String {
        return "\(rawValue) \(localizedReason)"
    }
}
