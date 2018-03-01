//
//  CLDTagsRequestParams.swift
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
 This class represents the different parameters that can be passed when performing a tag request.
 */
@objcMembers open class CLDTagsRequestParams: CLDRequestParams {
    
    //MARK: Init
    
    public override init() {
        super.init()
    }
    
    /**
    Initializes a CLDTagsRequestParams instance.
    - parameter tag:                The tag to assign, remove, or replace.
    - parameter publicIds:          An array of Public IDs of images uploaded to Cloudinary.
    
    - returns:                       A new instance of CLDTagsRequestParams.
    */
    internal init(tag: String, publicIds: [String]) {
        super.init()
        setParam(TagsParams.Tag.rawValue, value: tag)
        setParam(TagsParams.PublicIds.rawValue, value: publicIds)
    }
    
    /**
     Initializes a CLDTagsRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDTagsRequestParams.
     */
    public init(params: [String : AnyObject]) {
        super.init()
        self.params = params
    }
    
    // MARK: - Set Params
    
    /**
     Sets the desired action to be done.
     
     - parameter command:            The action to perform on asset resources using the given tag.
     Either add the given tag, remove the given tag, or replace the given tag,
     which adds the given tag while removing all other tags assigned.
     
     - returns:                       The same instance of CLDTagsRequestParams.
     */
    internal func setCommand(_ command: TagsCommand) -> Self {
        setParam(TagsParams.Command.rawValue, value: command.description)
        return self
    }
    
    // MARK: Private
    
    fileprivate enum TagsParams: String {
        case PublicIds =            "public_ids"
        case Tag =                  "tag"
        case Command =              "command"
    }
    
    internal enum TagsCommand: CustomStringConvertible {
        case add, remove, replace
        
        var description: String {
            switch self {
            case .add:              return "add"
            case .remove:           return "remove"
            case .replace:          return "replace"
            }
        }
    }

}
