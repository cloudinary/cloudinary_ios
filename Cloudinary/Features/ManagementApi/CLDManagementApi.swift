//
//  CLDManagementApi.swift
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
 The CLDManagementApi class is used to perform the available methods for managing your cloud assets.
*/
@objcMembers open class CLDManagementApi: CLDBaseNetworkObject {
    
    // MARK: - Init
    
    fileprivate override init() {
        super.init()
    }
    
    override internal init(networkCoordinator:CLDNetworkCoordinator) {
        super.init(networkCoordinator: networkCoordinator)
    }
    
    
    // MARK: - Features
    
    /**
    Rename an asset on your cloud.
    
    - parameter publicId:               The current identifier of the uploaded asset.
    - parameter to:                     The new identifier to assign to the uploaded asset.
    - parameter overwrite:              A boolean parameter indicating whether or not to overwrite an existing image with the target Public ID. Default: false.
    - parameter invalidate:             A boolean parameter whether to invalidate CDN cached copies of the image (and all its transformed versions). Default: false.
    - parameter params:                 An object holding the available parameters for the request.
    - parameter completionHandler:      The closure to be called once the request has finished, holding either the response object or the error.
    
    - returns:              An instance of `CLDRenameRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
    */
    @discardableResult
    open func rename(_ publicId: String, to: String, overwrite: Bool? = nil, invalidate: Bool? = nil, params: CLDRenameRequestParams? = nil, completionHandler: ((_ result: CLDRenameResult?, _ error: Error?) -> ())? = nil) -> CLDRenameRequest {
        let renameParams = CLDRenameRequestParams(fromPublicId: publicId, toPublicId: to, overwrite: overwrite, invalidate: invalidate)
        renameParams.merge(params)
        let request = networkCoordinator.callAction(.Rename, params:renameParams)
        let renameRequest = CLDRenameRequest(networkRequest: request)
        renameRequest.response(completionHandler)
        return renameRequest
    }
    
    /**
     Immediately and permanently delete assets from your Cloudinary account
     
     - parameter publicId:              The identifier of the asset to remove.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDDeleteRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func destroy(_ publicId: String, params: CLDDestroyRequestParams? = nil, completionHandler: ((_ result: CLDDeleteResult?, _ error: Error?) -> ())? = nil) -> CLDDeleteRequest {
        let destroyParams = CLDDestroyRequestParams(publicId: publicId)
        destroyParams.merge(params)
        let request = networkCoordinator.callAction(.Destroy, params: destroyParams)
        let destroyRequest = CLDDeleteRequest(networkRequest: request)
        destroyRequest.response(completionHandler)
        return destroyRequest
    }
    
    /**
     Add a tag to one or more assets in your cloud.
     Tags are used to categorize and organize your images, and can also be used to apply group actions to images, 
     for example to delete images, create sprites, ZIP files, JSON lists, or animated GIFs.
     Each image can be assigned one or more tags, which is a short name that you can dynamically use (no need to predefine tags).
     
     - parameter tag:                   The tag to assign.
     - parameter publicIds:             An array of Public IDs of images uploaded to Cloudinary.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDTagRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func addTag(_ tag: String, publicIds: [String], params: CLDTagsRequestParams? = nil, completionHandler: ((_ result: CLDTagResult?, _ error: Error?) -> ())? = nil) -> CLDTagRequest {
        let addTagParams = CLDTagsRequestParams(tag: tag, publicIds: publicIds)
        addTagParams.merge(params)
        
        let request = networkCoordinator.callAction(.Tags, params: addTagParams.setCommand(.add))
        let tagRequest = CLDTagRequest(networkRequest: request)
        tagRequest.response(completionHandler)
        return tagRequest
    }
    
    /**
     Remove a tag to one or more assets in your cloud.
     Tags are used to categorize and organize your images, and can also be used to apply group actions to images,
     for example to delete images, create sprites, ZIP files, JSON lists, or animated GIFs.
     Each image can be assigned one or more tags, which is a short name that you can dynamically use (no need to predefine tags).
     
     - parameter tag:                   The tag to remove.
     - parameter publicIds:             An array of Public IDs of images uploaded to Cloudinary.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDTagRequest`,
     allowing the options to add response closure to be called once the request has finished,
     as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func removeTag(_ tag: String, publicIds: [String], params: CLDTagsRequestParams? = nil, completionHandler: ((_ result: CLDTagResult?, _ error: Error?) -> ())? = nil) -> CLDTagRequest {
        let removeTagParams = CLDTagsRequestParams(tag: tag, publicIds: publicIds)
        removeTagParams.merge(params)
        let request = networkCoordinator.callAction(.Tags, params: removeTagParams.setCommand(.remove))
        let tagRequest = CLDTagRequest(networkRequest: request)
        tagRequest.response(completionHandler)
        return tagRequest
    }
    
    /**
     Replaces a tag to one or more assets in your cloud.
     Tags are used to categorize and organize your images, and can also be used to apply group actions to images,
     for example to delete images, create sprites, ZIP files, JSON lists, or animated GIFs.
     Each image can be assigned one or more tags, which is a short name that you can dynamically use (no need to predefine tags).
     
     - parameter tag:                   The tag to replace.
     - parameter publicIds:             An array of Public IDs of images uploaded to Cloudinary.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDTagRequest`,
     allowing the options to add response closure to be called once the request has finished,
     as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func replaceTag(_ tag: String, publicIds: [String], params: CLDTagsRequestParams? = nil, completionHandler: ((_ result: CLDTagResult?, _ error: Error?) -> ())? = nil) -> CLDTagRequest {
        let replaceTagParams = CLDTagsRequestParams(tag: tag, publicIds: publicIds)
        replaceTagParams.merge(params)
        let request = networkCoordinator.callAction(.Tags, params: replaceTagParams.setCommand(.replace))
        let tagRequest = CLDTagRequest(networkRequest: request)
        tagRequest.response(completionHandler)
        return tagRequest
    }
    
    /**
     The explicit method is used to apply actions to already uploaded images, i.e., to update images that have already been uploaded.
     The most common usage of this method is to generate transformations for images that have already been uploaded, 
     either so that they do not need to be generated on the fly when first accessed by users, 
     or because Strict Transformations are enabled for your account and you cannot create transformed images on the fly (for more information, see [Access control to images](http://cloudinary.com/documentation/upload_images#control_access_to_images)).
     
     - parameter publicId:              The identifier of the uploaded asset.
     - parameter type:                  The specific type of the resource.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDExplicitRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    @objc(explicitPublicId:stringType:params:completionHandler:)
    open func explicit(_ publicId: String, type: String, params: CLDExplicitRequestParams? = nil, completionHandler: ((_ result: CLDExplicitResult?, _ error: Error?) -> ())? = nil) -> CLDExplicitRequest {
        let explicitParams = CLDExplicitRequestParams(publicId: publicId, type: type)
        explicitParams.merge(params)
        let request = networkCoordinator.callAction(.Explicit, params: explicitParams)
        let explicitRequest = CLDExplicitRequest(networkRequest: request)
        explicitRequest.response(completionHandler)
        return explicitRequest
    }
    
    /**
     The explicit method is used to apply actions to already uploaded images, i.e., to update images that have already been uploaded.
     The most common usage of this method is to generate transformations for images that have already been uploaded,
     either so that they do not need to be generated on the fly when first accessed by users,
     or because Strict Transformations are enabled for your account and you cannot create transformed images on the fly (for more information, see [Access control to images](http://cloudinary.com/documentation/upload_images#control_access_to_images)).
     
     - parameter publicId:              The identifier of the uploaded asset.
     - parameter type:                  The specific type of the resource.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDExplicitRequest`,
     allowing the options to add response closure to be called once the request has finished,
     as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func explicit(_ publicId: String, type: CLDType, params: CLDExplicitRequestParams? = nil, completionHandler: ((_ result: CLDExplicitResult?, _ error: Error?) -> ())? = nil) -> CLDExplicitRequest {
        return explicit(publicId, type: String(describing: type), params: params, completionHandler: completionHandler)
    }
    
    /**
     The explode method creates derived images for all the individual pages in a PDF file.
     Each derived image created is stored with the same Public ID as the PDF file, 
     and can be accessed using the page parameter for delivering an image of a specific PDF page. 
     This method is useful for pregenerating all the pages of the PDF as individual images so that they do not need to be generated on the fly when first accessed by your users.
     
     - parameter publicId:              The identifier of the uploaded asset.
     - parameter transformation:        A transformation to run on all the pages before storing them as derived images. This parameter is given as an array (using the SDKs) or comma-separated list          (for direct API calls) of transformations, and separated with a slash for chained transformations.
     At minimum, you must pass the page transformation with the value all. If you supply additional transformations, you must deliver the image using the same relative order of the page and the other transformations. If you use a different order when you deliver, then it is considered a different transformation, and will be generated on-the-fly as a new derived image.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDExplodeRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func explode(_ publicId: String, transformation: CLDTransformation, params: CLDExplodeRequestParams? = nil, completionHandler: ((_ result: CLDExplodeResult?, _ error: Error?) -> ())? = nil) -> CLDExplodeRequest {
        let explodeParams = CLDExplodeRequestParams(publicId: publicId, transformation: transformation)
        explodeParams.merge(params)
        let request = networkCoordinator.callAction(.Explode, params: explodeParams)
        let explodeRequest = CLDExplodeRequest(networkRequest: request)
        explodeRequest.response(completionHandler)
        return explodeRequest
    }
    
    /**
     Generate sprites by merging multiple images into a single large image for reducing network overhead and bypassing download limitations.
     This method creates a sprite from all images that have been assigned a specified tag.
     
     - parameter tag:                   The sprite is created from all images with this tag.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDSpriteRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func generateSprite(_ tag: String, params: CLDSpriteRequestParams? = nil, completionHandler: ((_ result: CLDSpriteResult?, _ error: Error?) -> ())? = nil) -> CLDSpriteRequest {
        let generateSpriteParams = CLDSpriteRequestParams(tag: tag)
        generateSpriteParams.merge(params)
        let request = networkCoordinator.callAction(.GenerateSprite, params: generateSpriteParams)
        let spriteRequest = CLDSpriteRequest(networkRequest: request)
        spriteRequest.response(completionHandler)
        return spriteRequest
    }
    
    /**
    Create a single animated GIF file from all images that have been assigned a specified tag, 
     where each image is included as a single frame of the resulting animating GIF (sorted alphabetically by their Public ID).
     For a detailed explanation on generating animated GIFs, see the [documentation on creating animated GIFs.](http://cloudinary.com/documentation/image_transformations#creating_animated_gifs)
     
     - parameter tag:                   The sprite is created from all images with this tag.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDMultiRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
    */
    @discardableResult
    open func multi(_ tag: String, params: CLDMultiRequestParams? = nil, completionHandler: ((_ result: CLDMultiResult?, _ error: Error?) -> ())? = nil) -> CLDMultiRequest {
        let multiParams = CLDMultiRequestParams(tag: tag)
        multiParams.merge(params)
        let request = networkCoordinator.callAction(.Multi, params: multiParams)
        let multiRequest = CLDMultiRequest(networkRequest: request)
        multiRequest.response(completionHandler)
        return multiRequest
    }
    
    /**
     Dynamically generate an image from a given textual string.
     You can then use this textual image as any other image, 
     for example, as an overlay for other images. Various font, 
     color and style parameters can be specified to customize the look & feel of the text before converting it to an image.
     
     - parameter text:                  The text string to generate an image for.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDTextRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func text(_ text: String, params: CLDTextRequestParams? = nil, completionHandler: ((_ result: CLDTextResult?, _ error: Error?) -> ())? = nil) -> CLDTextRequest {
        let textParams = CLDTextRequestParams(text: text)
        textParams.merge(params)
        let request = networkCoordinator.callAction(.GenerateText, params: textParams)
        let textRequest = CLDTextRequest(networkRequest: request)
        textRequest.response(completionHandler)
        return textRequest
    }
    
    /**
     The Cloudinary library supports using a delete token to delete images on the client-side for a limited time of 10 minutes after being uploaded. 
     After 10 minutes has passed, the image cannot be deleted from the client side, only via the Destroy method.
     In order to also receive a deletion token in the upload response, add the return_delete_token parameter to the upload method and set it to true.
     
     - parameter token:                 The delete token received in the upload response, after uploading the asset using `return_delete_token` set to true.
     - parameter params:                An object holding the available parameters for the request.
     - parameter completionHandler:     The closure to be called once the request has finished, holding either the response object or the error.
     
     - returns:             An instance of `CLDDeleteRequest`,
                            allowing the options to add response closure to be called once the request has finished,
                            as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func deleteByToken(_ token: String, params: CLDDeleteByTokenRequestParams? = nil, completionHandler: ((_ result: CLDDeleteResult?, _ error: Error?) -> ())? = nil) -> CLDDeleteRequest {
        let deleteByTokenParams = CLDDeleteByTokenRequestParams(token: token)
        deleteByTokenParams.merge(params)
        let request = networkCoordinator.callAction(.DeleteByToken, params: deleteByTokenParams)
        let deleteByTokenRequest = CLDDeleteRequest(networkRequest: request)
        deleteByTokenRequest.response(completionHandler)
        return deleteByTokenRequest
    }
}
