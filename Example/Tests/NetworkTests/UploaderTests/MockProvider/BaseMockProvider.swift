//
//  BaseMockProvider.swift
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

@testable import Cloudinary

@objcMembers public class BaseMockProvider: NSObject {
    
    // MARK: - upload result
    static public var uploadResult: CLDUploadResult? {
        guard let resultDictionary = convertToDictionary(string: jsonString()) else { return nil }
         
        return CLDUploadResult(json: resultDictionary)
    }
    
    // MARK: - explicit result
    static public var explicitResult: CLDExplicitResult? {
        guard let resultDictionary = convertToDictionary(string: jsonString()) else { return nil }
        
        return CLDExplicitResult(json: resultDictionary)
    }
    
    fileprivate static func convertToDictionary(string: String) -> [String: AnyObject]? {
        if let data = string.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
        }
        return nil
    }
    
    /**
      Override this function with mock information as json string
     */
    class func jsonString() -> String {
        return ""
    }
}
