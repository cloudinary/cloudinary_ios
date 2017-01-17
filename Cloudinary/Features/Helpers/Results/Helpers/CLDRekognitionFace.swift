//
//  CLDRekognitionFace.swift
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

@objc open class CLDRekognitionFace: CLDBaseResult {
    
    open var status: String? {
        return getParam(.status) as? String
    }
    
    open var faces: [CLDFace]? {
        guard let facesArr = getParam(.faces) as? [[String : AnyObject]] else {
            return nil
        }
        var faces: [CLDFace] = []
        for face in facesArr {
            faces.append(CLDFace(json: face))
        }
        return faces
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: CLDRekognitionFaceKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDRekognitionFaceKey: CustomStringConvertible {
        case status, facesData
        
        var description: String {
            switch self {
            case .status:           return "status"
            case .facesData:        return "data"
            }
        }
    }
}
