//
//  CLDDeleteByTokenRequestParams.swift
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
 This class represents the different parameters that can be passed when performing a `delete by token` request.
 */
open class CLDDeleteByTokenRequestParams: CLDRequestParams {

    
    // MARK: Init
    
    fileprivate override init() {
        super.init()
    }
    
    /**
    Initializes a CLDDeleteByTokenRequestParams instance.
    
    - parameter token:      The delete token received in the upload response, after uploading the asset using `return_delete_token` set to true.
    
    - returns:              A new instance of CLDDeleteByTokenRequestParams.
    */
    internal init(token: String) {
        super.init()
        setParam(DeleteByTokenParams.Token.rawValue, value: token)
    }
    
    /**
     Initializes a CLDDeleteByTokenRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDDeleteByTokenRequestParams.
     */
    public init(params: [String : Any]) {
        super.init()
        self.params = params
    }
    
    // MARK: Params
    
    fileprivate enum DeleteByTokenParams: String {
        case Token =                "token"
    }
    
}
