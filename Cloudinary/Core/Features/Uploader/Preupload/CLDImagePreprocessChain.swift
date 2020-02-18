//
//
//  CLDImagePreprocessChain.swift
//
//  Copyright (c) 2017 Cloudinary (http://cloudinary.com)
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
 The CLDImagePreprocessChain is used to run preprocessing on images before uploading.
 It support processing, validations and encoders, all fully customizable.
*/
public class CLDImagePreprocessChain: CLDPreprocessChain<UIImage> {
    public override init() {
    }

    internal override func decodeResource(_ resourceData: Any) throws -> UIImage? {
        if let url = resourceData as? URL {
            if let resourceData = try? Data(contentsOf: url) {
                return UIImage(data: resourceData)
            }
        } else if let data = resourceData as? Data {
            return UIImage(data: data)
        }

        return nil
    }

    internal override func verifyEncoder() throws {
        if (encoder == nil) {
            setEncoder(CLDPreprocessHelpers.defaultImageEncoder)
        }
    }
}
