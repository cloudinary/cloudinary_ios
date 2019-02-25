//
//  CLDUploadRequestParams.swift
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
 This class represents the different parameters that can be passed when performing an upload request.
 For more information see the [documentation](http://cloudinary.com/documentation/image_upload_api_reference#upload).
*/
@objcMembers open class CLDUploadRequestParams: CLDRequestParams {

    /**
     A boolean variable representing whether or not the request should be signed.
    */
    internal var signed: Bool = false
    
    // MARK: Init
    
    public override init() {        
        super.init()
    }
    
    /**
     Initializes a CLDUploadRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDUploadRequestParams.
     */
    public init(params: [String : AnyObject]) {
        super.init()
        self.params = params
    }
    
    internal override func merge(_ other: CLDRequestParams?){
        super.merge(other)
       
        if let uploadRequest = other as? CLDUploadRequestParams {
            self.signed = uploadRequest.signed
        }
    }
    
    // MARK: - Get Values
    
    open var publicId: String? {
        return getParam(.PublicId) as? String
    }
    
    open var format: String? {
        return getParam(.Format) as? String
    }
    
    open var type: String? {
        return getParam(.FileType) as? String
    }
    
    open var notificationUrl: String? {
        return getParam(.NotificationUrl) as? String
    }
    
    open var eagerNotificationUrl: String? {
        return getParam(.EagerNotificationUrl) as? String
    }
    
    open var proxy: String? {
        return getParam(.Proxy) as? String
    }
    
    open var folder: String? {
        return getParam(.Folder) as? String
    }
    
    open var moderation: String? {
        return getParam(.Moderation) as? String
    }
    
    open var accessControl: String? {
        return getParam(.AccessControl) as? String
    }
    
    open var rawConvert: String? {
        return getParam(.RawConvert) as? String
    }
    
    open var detection: String? {
        return getParam(.Detection) as? String
    }
    
    open var categorization: String? {
        return getParam(.Categorization) as? String
    }
    
    open var similaritySearch: String? {
        return getParam(.SimilaritySearch) as? String
    }
    
    open var autoTagging: String? {
        return getParam(.AutoTagging) as? String
    }
    
    open var backup: Bool? {
        return getParam(.Backup) as? Bool
    }
    
    open var useFilename: Bool? {
        return getParam(.UseFilename) as? Bool
    }
    
    open var uniqueFilename: Bool? {
        return getParam(.UniqueFilename) as? Bool
    }
    
    open var discardOriginalFilename: Bool? {
        return getParam(.DiscardOriginalFilename) as? Bool
    }

    open var async: Bool? {
        return getParam(.Async) as? Bool
    }

    open var eagerAsync: Bool? {
        return getParam(.EagerAsync) as? Bool
    }
    
    open var invalidate: Bool? {
        return getParam(.Invalidate) as? Bool
    }
    
    open var overwrite: Bool? {
        return getParam(.Overwrite) as? Bool
    }
    
    open var imageMetadata: Bool? {
        return getParam(.ImageMetadata) as? Bool
    }
    
    open var colors: Bool? {
        return getParam(.Colors) as? Bool
    }
    
    open var phash: Bool? {
        return getParam(.Phash) as? Bool
    }
    
    open var faces: Bool? {
        return getParam(.Faces) as? Bool
    }
    
    open var returnDeleteToken: Bool? {
        return getParam(.ReturnDeleteToken) as? Bool
    }
    
    open var transformation: String? {
        return getParam(.Transformation) as? String
    }
    
    open var tags: String? {
        return getParam(.Tags) as? String
    }
    
    open var allowedFormats: String? {
        return getParam(.AllowedFormats) as? String
    }
    
    open var context: String? {
        return getParam(.Context) as? String
    }
    
    open var faceCoordinates: String? {
        return getParam(.FaceCoordinates) as? String
    }
    
    open var customCoordinates: String? {
        return getParam(.CustomCoordinates) as? String
    }
    
    open var eager: String? {
        return getParam(.Eager) as? String
    }
    
    open var headers: String? {
        return getParam(.Headers) as? String
    }
    
    open var qualityAnalysis: Bool? {
        return getParam(.QualityAnalysis) as? Bool
    }
    
    fileprivate func getParam(_ param: UploadRequestParams) -> AnyObject? {
        return params[param.rawValue] as AnyObject
    }
    
    
    // MARK: Set Simple Params
    
    /**
     Set the identifier that is used for accessing the uploaded resource. 
     A randomly generated ID is assigned if not specified. The Public ID may contain a full path including folders separated by a slash (/).
     
     - parameter publicId:          The identifier to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setPublicId(_ publicId: String) -> Self {
        setParam(UploadRequestParams.PublicId.rawValue, value: publicId)
        return self
    }
    
    /**
     Set an optional format to convert the uploaded resource to before saving in the cloud. For example: jpg.
     
     - parameter format:            The format to convert to.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    open func setFormat(_ format: String) -> Self {
        setParam(UploadRequestParams.Format.rawValue, value: format)
        return self
    }
    
    /**
     Allows uploading resources as 'private' or 'authenticated' instead of the default public mode.
     
     - parameter type:              The type to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @objc(setTypeFromType:)
    open func setType(_ type: CLDType) -> Self {        
        return setType(String(describing: type))
    }
    
    /**
     Allows uploading resources as 'private' or 'authenticated' instead of the default public mode.
     
     - parameter type:              The type to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setType(_ type: String) -> Self {
        setParam(UploadRequestParams.FileType.rawValue, value: type)
        return self
    }
    
    /**
     Set an HTTP URL to send notification to (a webhook) when the upload is completed.
     
     - parameter notificationUrl:   The URL to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    open func setNotificationUrl(_ notificationUrl: String) -> Self {
        setParam(UploadRequestParams.NotificationUrl.rawValue, value: notificationUrl)
        return self
    }
    
    /**
     Set an HTTP URL to send notification to (a webhook) when the generation of eager transformations is completed.
     
     - parameter eagerNotificationUrl:      The URL to set.
     
     - returns:                             The same instance of CLDUploadRequestParams.
     */
    open func setEagerNotificationUrl(_ eagerNotificationUrl: String) -> Self {
        setParam(UploadRequestParams.EagerNotificationUrl.rawValue, value: eagerNotificationUrl)
        return self
    }
    
    /**
     Tells Cloudinary to upload resources from remote URLs through the given proxy. Format: http://hostname:port.
     
     - parameter proxy:     The proxy URL.
     
     - returns:             The same instance of CLDUploadRequestParams.
     */
    open func setProxy(_ proxy: String) -> Self {
        setParam(UploadRequestParams.Proxy.rawValue, value: proxy)
        return self
    }
    
    /**
     Set an optional folder name where the uploaded resource will be stored. The Public ID contains the full path of the uploaded resource, including the folder name.
     
     - parameter folder:    The folder URL.
     
     - returns:             The same instance of CLDUploadRequestParams.
     */
    open func setFolder(_ folder: String) -> Self {
        setParam(UploadRequestParams.Folder.rawValue, value: folder)
        return self
    }
    
    /**
     Set to manual to add the uploaded image to a queue of pending moderation images that can be moderated using the Admin API or the Cloudinary Management Console. 
     Set to webpurify to automatically moderate the uploaded image using the WebPurify Image Moderation add-on.
     
     - parameter moderation:        The moderation to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @objc(setModerationFromModeration:)
    @discardableResult
    open func setModeration(_ moderation: CLDModeration) -> Self {
        return setModeration(String(describing: moderation))
    }
    
    /**
     Set to manual to add the uploaded image to a queue of pending moderation images that can be moderated using the [Cloudinary Management Console](https://cloudinary.com/console/media_library).
     Set to webpurify to automatically moderate the uploaded image using the [WebPurify Image Moderation add-on](http://dev.cloudinary.com:3002/documentation/webpurify_image_moderation_addon).
     
     - parameter moderation:        The moderation to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    open func setModeration(_ moderation: String) -> Self {
        setParam(UploadRequestParams.Moderation.rawValue, value: moderation)
        return self
    }
    
    /**
     Set to aspose to automatically convert Office documents to PDF files and other image formats using the [Aspose Document Conversion add-on](http://dev.cloudinary.com:3002/documentation/aspose_document_conversion_addon).
     
     - parameter rawConvert:        The rawConvert to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setRawConvert(_ rawConvert: String) -> Self {
        setParam(UploadRequestParams.RawConvert.rawValue, value: rawConvert)
        return self
    }
    
    /**
     Set to adv_face to extract an extensive list of face attributes from a image using the [Advanced Facial Attribute Detection add-on](http://cloudinary.com/documentation/advanced_facial_attributes_detection_addon).
     
     - parameter detection:     The detection to set.
     
     - returns:                 The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setDetection(_ detection: String) -> Self {
        setParam(UploadRequestParams.Detection.rawValue, value: detection)
        return self
    }
    
    /**
     By setting the categorization parameter to imagga_tagging, Imagga is used to automatically classify the scenes of the uploaded image.
     
     - parameter categorization:    The categorization to set.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setCategorization(_ categorization: String) -> Self {
        setParam(UploadRequestParams.Categorization.rawValue, value: categorization)
        return self
    }
    
    /**
     
     - parameter similaritySearch:      The similarity search to set.
     
     - returns:                         The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setSimilaritySearch(_ similaritySearch: String) -> Self {
        setParam(UploadRequestParams.SimilaritySearch.rawValue, value: similaritySearch)
        return self
    }
    
    /**
     - parameter accessControl:     A list of access control rules for the upload request
     
     - returns:                     The same instance CLDUploadRequestParams
     */
    @discardableResult
    open func setAccessControl(_ accessControl: [CLDAccessControlRule]) -> Self {
        setParam(UploadRequestParams.AccessControl.rawValue, value:  asJsonArray(arr: accessControl))
        return self
    }
    
    /**
     - parameter accessControl:     A json string representing a list of access control rules for upload
     
     - returns:                     The same instance CLDUploadRequestParams
     */
    @objc(setAccessControlWithString:)
    @discardableResult
    open func setAccessControl(_ accessControl: String) -> Self {
        setParam(UploadRequestParams.AccessControl.rawValue, value: accessControl)
        return self
    }
    
    /**
     Set whether to assign tags to an image according to detected scene categories with a confidence score higher than the given value (between 0.0 and 1.0).
     See [Imagga Auto Tagging](http://dev.cloudinary.com:3002/documentation/imagga_auto_tagging_addon) for more details.
     
     - parameter autoTagging:       The auto tagging parameter to use.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @objc(setAutoTaggingWithDouble:)
    @discardableResult
    open func setAutoTagging(_ autoTagging: Double) -> Self {
        setAutoTagging(autoTagging.cldFormat(f: ".1"))
        return self
    }
    
    /**
     Set whether to assign tags to an image according to detected scene categories with a confidence score higher than the given value (between 0.0 and 1.0).
     See [Imagga Auto Tagging](http://dev.cloudinary.com:3002/documentation/imagga_auto_tagging_addon) for more details.
     
     - parameter autoTagging:       The auto tagging parameter to use.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setAutoTagging(_ autoTagging: String) -> Self {
        setParam(UploadRequestParams.AutoTagging.rawValue, value: autoTagging)
        return self
    }
    
    
    // MARK: Set Boolean Params
    
    /**
     Set A boolean parameter that determines whether to backup the uploaded resource. Overrides the default backup settings of your account.
     
     - parameter backup:        The boolean parameter.
     
     - returns:                 The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setBackup(_ backup: Bool) -> Self {
        setBoolParam(.Backup, value: backup)
        return self
    }
    
    /**
     Set A boolean parameter that determines whether to use the original file name of the uploaded resource if available for the Public ID. 
     The file name is normalized and random characters are appended to ensure uniqueness. Default: false.
     
     - parameter useFilename:   The boolean parameter.
     
     - returns:                 The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setUseFilename(_ useFilename: Bool) -> Self {
        setBoolParam(.UseFilename, value: useFilename)
        return self
    }
    
    /**
     When set to false, should not add random characters at the end of the filename that guarantee its uniqueness. Only relevant if use_filename is also set to true. Default: true.
     
     - parameter uniqueFilename:    The boolean parameter.
     
     - returns:                     The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setUniqueFilename(_ uniqueFilename: Bool) -> Self {
        setBoolParam(.UniqueFilename, value: uniqueFilename)
        return self
    }
    
    /**
     Set A boolean parameter that determines whether to discard the name of the original uploaded file. 
     Relevant when delivering resources as attachments (setting the flag transformation parameter to attachment). 
     Default: false.
     
     - parameter discardOriginalFilename:   The boolean parameter.
     
     - returns:                             The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setDiscardOriginalFilename(_ discardOriginalFilename: Bool) -> Self {
        setBoolParam(.DiscardOriginalFilename, value: discardOriginalFilename)
        return self
    }

    /**
    Set a boolean parameter indicating whether to perform the image generation asynchronously. default is false.

    - parameter async:      The boolean parameter.

    - returns:              The same instance of CLDUploadRequestParams.
    */
    @discardableResult
    open func setAsync(_ async: Bool) -> Self {
        setBoolParam(UploadRequestParams.Async, value: async)
        return self
    }

    /**
     Set A boolean parameter that determines whether to generate the eager transformations asynchronously in the background. default is false.
     
     - parameter eagerAsync:    The boolean parameter.
     
     - returns:                 The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setEagerAsync(_ eagerAsync: Bool) -> Self {
        setBoolParam(.EagerAsync, value: eagerAsync)
        return self
    }
    
    /**
     Set boolean parameter indicating whether or not the asset should be invalidated through the CDN. default is false.
     
     - parameter invalidate:    The boolean parameter.
     
     - returns:             The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setInvalidate(_ invalidate: Bool) -> Self {
        setBoolParam(.Invalidate, value: invalidate)
        return self
    }
    
    /**
     Set boolean parameter indicating whether to overwrite existing resources with the same Public ID. When set to false, return immediately if a resource with the same Public ID was found. 
     Default: true (when using unsigned upload, the default is false and cannot be changed to true).
     
     - parameter overwrite:     The boolean parameter.
     
     - returns:                 The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setOverwrite(_ overwrite: Bool) -> Self {
        setBoolParam(.Overwrite, value: overwrite)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to retrieve IPTC and detailed Exif metadata of the uploaded asset. default is false.
     
     - parameter imageMetadata:     The boolean parameter.
     
     - returns:                     The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setImageMetadata(_ imageMetadata: Bool) -> Self {
        setBoolParam(.ImageMetadata, value: imageMetadata)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to retrieve predominant colors & color histogram of the uploaded asset. default is false.
     
     - parameter colors:            The boolean parameter.
     
     - returns:                     The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setColors(_ colors: Bool) -> Self {
        setBoolParam(.Colors, value: colors)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to return the perceptual hash (pHash) on the uploaded asset.
     The pHash acts as a fingerprint that allows checking image similarity. default is false.
     
     - parameter phash:             The boolean parameter.
     
     - returns:                     The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setPhash(_ phash: Bool) -> Self {
        setBoolParam(.Phash, value: phash)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to return the coordinates of faces contained in an uploaded asset (automatically detected or manually defined).
     Each face is specified by the X & Y coordinates of the top left corner and the width & height of the face. default is false.
     
     - parameter faces:             The boolean parameter.
     
     - returns:                     The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setFaces(_ faces: Bool) -> Self {
        setBoolParam(.Faces, value: faces)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to return a deletion token in the upload response. 
     The token can be used to delete the uploaded resource within 10 minutes using an unauthenticated API request. 
     Default: false.
     
     - parameter returnDeleteToken:     The boolean parameter.
     
     - returns:                         The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setReturnDeleteToken(_ returnDeleteToken: Bool) -> Self {
        setBoolParam(.ReturnDeleteToken, value: returnDeleteToken)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to return quality analysis of the image.
     Default: false.
     
     - parameter qualityAnalysis:     The boolean parameter.
     
     - returns:                       The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setQualityAnalysis(_ qualityAnalysis: Bool) -> Self {
        setBoolParam(.QualityAnalysis, value: qualityAnalysis)
        return self
    }
    
    /**
    A setter for any one of the simple boolean parameters. This is used to normalize boolean values in requests
    to be consistent across different platforms.
    
    - parameter value:              The parameter value.
    - parameter param:              The boolean parameter to set.
    
    - returns:                       The same instance of CLDUploadRequestParams.
    */
    @discardableResult
    fileprivate func setBoolParam(_ param: UploadRequestParams, value: Bool) -> Self {
        let boolNumber = NSNumber(value: value as Bool)
        setParam(param.rawValue, value: boolNumber)
        return self
    }
    
    // MARK: Set Params
    
    /**
    Set the upload preset.
    For more information see the [documentation](http://cloudinary.com/documentation/upload_images#unsigned_upload).
    
    - parameter uploadPreset:       The upload preset from your account settings.
    
    - returns:                       The same instance of CLDUploadRequestParams.
    */
    @discardableResult
    open func setUploadPreset(_ uploadPreset: String) -> Self {
        setParam(UploadRequestParams.UploadPreset.rawValue, value: uploadPreset)
        return self
    }
    
    /**
    Set the request to be an unsigned request, using an upload preset that can be set in the Cloudinary account dashboard.
    For more information see the [documentation](http://cloudinary.com/documentation/upload_images#unsigned_upload).

    - parameter uploadPreset:       The upload preset from your account settings.

    - returns:                       The same instance of CLDUploadRequestParams.
    */
    @discardableResult
    @objc(setSignedWithBool:)
    internal func setSigned(_ signed: Bool) -> Self {
        self.signed = signed
        return self
    }

    /**
     Apply an incoming transformation as part of the upload request. 
     Any image transformation parameter can be specified as an option in the upload call and these transformations are applied before saving the image in the cloud.
     For more information see the [documentation](http://cloudinary.com/documentation/upload_images#incoming_transformations).
     
     - parameter transformation:     The transformation to apply on the uploaded asset.
     
     - returns:                       The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    @objc(setTransformationFromTransformation:)
    open func setTransformation(_ transformation: CLDTransformation) -> Self {
        if let stringRep = transformation.asString() {
            setTransformation(stringRep)
        }
        return self
    }
    
    /**
     Apply an incoming transformation as part of the upload request.
     Any image transformation parameter can be specified as an option in the upload call and these transformations are applied before saving the image in the cloud.
     For more information see the [documentation](http://cloudinary.com/documentation/upload_images#incoming_transformations).
     
     - parameter transformation:     The transformation to apply on the uploaded asset.
     
     - returns:                       The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setTransformation(_ transformation: String) -> Self {
        setParam(UploadRequestParams.Transformation.rawValue, value: transformation)
        return self
    }
    
    /**
     Assign tags to the uploaded files.
     For more information see the [documentation](http://cloudinary.com/documentation/upload_images#tagging_images).
     
     - parameter tags:              The tags to aggign to the uploaded asset.
     
     - returns:                      The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    @objc(setTagsWithArray:)
    open func setTags(_ tags: [String]) -> Self {
        return setTags(tags.joined(separator: ","))
    }
    
    /**
     Assign tags to the uploaded files.
     For more information see the [documentation](http://cloudinary.com/documentation/upload_images#tagging_images).
     
     - parameter tags:              The tags to aggign to the uploaded asset.
     
     - returns:                      The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setTags(_ tags: String) -> Self {
        setParam(UploadRequestParams.Tags.rawValue, value: tags)
        return self
    }
    
    /**
     Set An array of file formats that are allowed for uploading.
     The default is any supported image format for images, and any kind of raw file.
     Files of other types will be rejected.
     The formats can be any combination of image types, video formats or raw file extensions.
     For example: `mp4,ogv,jpg,png,pdf`
     
     - parameter allowedFormats:    The array of allowed formats.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    @objc(setAllowedFormatsWithArray:)
    open func setAllowedFormats(_ allowedFormats: [String]) -> Self {
        return setAllowedFormats(allowedFormats.joined(separator: ","))
    }
    
    /**
     Set An array of file formats that are allowed for uploading.
     The default is any supported image format for images, and any kind of raw file.
     Files of other types will be rejected.
     The formats can be any combination of image types, video formats or raw file extensions.
     For example: `mp4,ogv,jpg,png,pdf`
     
     - parameter allowedFormats:    The array of allowed formats.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     */
    @discardableResult
    open func setAllowedFormats(_ allowedFormats: String) -> Self {
        setParam(UploadRequestParams.AllowedFormats.rawValue, value: allowedFormats)
        return self
    }
    
    /**
     Set a dictionary of the key-value pairs of general textual context metadata to attach to an uploaded resource.
     The context values of uploaded files are available for fetching using the Admin API.
     For example: `alt=My image❘caption=Profile image`.
     
     - parameter context:       The context dictionary.
     
     - returns:                 The same instance of CLDUploadRequestParams.
     
     */
    @objc(setContextFromDictionary:)
    @discardableResult
    open func setContext(_ context: [String : String]) -> Self {
        return setContext(buildContextString(context))
    }
    
    /**
     Set a dictionary of the key-value pairs of general textual context metadata to attach to an uploaded resource.
     The context values of uploaded files are available for fetching using the Admin API.
     For example: `alt=My image❘caption=Profile image`.
     
     - parameter context:       The context dictionary.
     
     - returns:                 The same instance of CLDUploadRequestParams.
     
     */
    @discardableResult
    open func setContext(_ context: String) -> Self {
        setParam(UploadRequestParams.Context.rawValue, value: context)
        return self
    }
    
    /**
     Sets the coordinates of faces contained in an uploaded image and overrides the automatically detected faces. 
     Each face is specified by the X & Y coordinates of the top left corner and the width & height of the face.
     
     - parameter faceCoordinates:   The array of `CLDCoodinate` objects, each object holds a CGRect for a single face coordinate.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @objc(setFaceCoordinatesFromCoordinates:)
    @discardableResult
    open func setFaceCoordinates(_ faceCoordinates: [CLDCoordinate]) -> Self {
        return setFaceCoordinates(buildCoordinatesString(faceCoordinates))
    }
    
    /**
     Sets the coordinates of faces contained in an uploaded image and overrides the automatically detected faces.
     Each face is specified by the X & Y coordinates of the top left corner and the width & height of the face.
     
     - parameter faceCoordinates:   The array of `CLDCoodinate` objects, each object holds a CGRect for a single face coordinate.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @discardableResult
    open func setFaceCoordinates(_ faceCoordinates: String) -> Self {
        setParam(UploadRequestParams.FaceCoordinates.rawValue, value: faceCoordinates)
        return self
    }
    
    /**
     Sets the coordinates of a region contained in an uploaded image that is subsequently used for cropping uploaded images using the custom gravity mode. 
     The region is specified by the X & Y coordinates of the top left corner and the width & height of the region.
     
     - parameter customCoordinates: The array of `CLDCoodinate` objects, each object holds a CGRect for a single custom coordinate.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @objc(setCustomCoordinatesFromCoordinates:)
    @discardableResult
    open func setCustomCoordinates(_ customCoordinates: [CLDCoordinate]) -> Self {
        return setCustomCoordinates(buildCoordinatesString(customCoordinates))
    }
    
    /**
     Sets the coordinates of a region contained in an uploaded image that is subsequently used for cropping uploaded images using the custom gravity mode.
     The region is specified by the X & Y coordinates of the top left corner and the width & height of the region.
     
     - parameter customCoordinates: The array of `CLDCoodinate` objects, each object holds a CGRect for a single custom coordinate.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @discardableResult
    open func setCustomCoordinates(_ customCoordinates: String) -> Self {
        setParam(UploadRequestParams.CustomCoordinates.rawValue, value: customCoordinates)
        return self
    }
    
    /**
     Set an array of transformations to create for the uploaded resource during the upload process, instead of lazily creating each of them when first accessed by your site's visitors.
     
     - parameter eager:             The array of transformations (CLDTransformation|CLDEagerTransformation)

     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @objc(setEagerFromTransformationArray:)
    @discardableResult
    open func setEager(_ eager: [CLDTransformation]) -> Self {
        return setEager(buildEagerString(eager))
    }

    /**
     Set an array of transformations to create for the uploaded resource during the upload process, instead of lazily creating each of them when first accessed by your site's visitors.
     
     - parameter eager:             The array of transformations.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @discardableResult
    open func setEager(_ eager: String) -> Self {
        setParam(UploadRequestParams.Eager.rawValue, value: eager)
        return self
    }
    
    /**
     Override quality settings for the resource
     
     - parameter quality:           The quality configuration instance, see CLDQuality.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @objc(setQualityOverrideFromQuality:)
    @discardableResult
    open func setQualityOverride(_ quality: CLDTransformation.CLDQuality) -> Self {
        setParam(UploadRequestParams.QualityOverride.rawValue, value: quality.description)
        return self
    }
    
    /**
     Override quality settings for the resource

     - parameter quality:           The quality as a string.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @objc(setQualityOverrideFromString:)
    @discardableResult
    open func setQualityOverride(_ quality: String) -> Self {
        setParam(UploadRequestParams.QualityOverride.rawValue, value: quality)
        return self
    }
    
    /**
     Set an array of headers lines for returning as response HTTP headers when delivering the uploaded resource to your users.
     Supported headers: `Link, X-Robots-Tag`. 
     For example: `X-Robots-Tag: noindex`.
     
     - parameter headers:           The array of headers.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @objc(setHeadersWithDictionary:)
    @discardableResult
    open func setHeaders(_ headers: [String : String]) -> Self {
        return setHeaders(buildHeadersString(headers))
    }
    
    /**
     Set an array of headers lines for returning as response HTTP headers when delivering the uploaded resource to your users.
     Supported headers: `Link, X-Robots-Tag`.
     For example: `X-Robots-Tag: noindex`.
     
     - parameter headers:           The array of headers.
     
     - returns:                     The same instance of CLDUploadRequestParams.
     
     */
    @discardableResult
    open func setHeaders(_ headers: String) -> Self {
        setParam(UploadRequestParams.Headers.rawValue, value: headers)
        return self
    }
    
    /**
     Requests that Cloudinary automatically find the best breakpoints, using an array of CLDResponsiveBreakpoints objects.
     
     - parameter responsiveBreakpoints:         The array of responsive breakpoints setting.
     
     - returns:                                 The same instance of CLDExplicitRequestParams.
     */
    @discardableResult
    open func setResponsiveBreakpoints(_ responsiveBreakpoints: [CLDResponsiveBreakpoints]) -> Self {
        var responsiveBreakpointsJSON: [String] = []

        for rb in responsiveBreakpoints {
            responsiveBreakpointsJSON.append(rb.description)
        }

        super.setParam(UploadRequestParams.ResponsiveBreakpoints.rawValue, value: "[\(responsiveBreakpointsJSON.joined(separator: ","))]")

        return self
    }
    
    // MARK: - Helpers
    
    fileprivate enum UploadRequestParams: String {
        case PublicId =                             "public_id"
        case Callback =                             "callback"
        case Format =                               "format"
        case FileType =                             "type"
        case NotificationUrl =                      "notification_url"
        case EagerNotificationUrl =                 "eager_notification_url"
        case Proxy =                                "proxy"
        case Folder =                               "folder"
        case Moderation =                           "moderation"
        case RawConvert =                           "raw_convert"
        case Categorization =                       "categorization"
        case Detection =                            "detection"
        case SimilaritySearch =                     "similarity_search"
        case AutoTagging =                          "auto_tagging"
        case UploadPreset =                         "upload_preset"
        case AccessControl =                        "access_control"
        case QualityOverride =                      "quality_override"
        
        // Boolean params
        case Backup =                               "backup"
        case Exif =                                 "exif"
        case Faces =                                "faces"
        case Colors =                               "colors"
        case ImageMetadata =                        "image_metadata"
        case UseFilename =                          "use_filename"
        case UniqueFilename =                       "unique_filename"
        case DiscardOriginalFilename =              "discard_original_filename"
        case Async =                                "async"
        case EagerAsync =                           "eager_async"
        case Invalidate =                           "invalidate"
        case Overwrite =                            "overwrite"
        case Phash =                                "phash"
        case ReturnDeleteToken =                    "return_delete_token"
        case QualityAnalysis =                      "quality_analysis"
        
        case Transformation =                       "transformation"
        case Tags =                                 "tags"
        case AllowedFormats =                       "allowed_formats"
        case Context =                              "context"
        case FaceCoordinates =                      "face_coordinates"
        case CustomCoordinates =                    "custom_coordinates"
        case Eager =                                "eager"
        case Headers =                              "headers"
        case ResponsiveBreakpoints =                "responsive_breakpoints"
    }
}
