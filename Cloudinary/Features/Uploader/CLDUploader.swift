//
//  CLDUploader.swift
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
 The CLDUploader class is used to upload assets to your Cloudinary account's cloud.
*/
@objc open class CLDUploader: CLDBaseNetworkObject {
    static public let defaultChunkSize = 20 * 1024 * 1024
    
    // MARK: - Init

    fileprivate override init() {
        super.init()
    }

    internal override init(networkCoordinator: CLDNetworkCoordinator) {
        super.init(networkCoordinator: networkCoordinator)
    }

    // MARK: - Actions

    /**
   Uploads the given data to the configured cloud.

   - parameter data:              The data to upload.
   - parameter uploadPreset:      The upload preset to use for unsigned upload.
   - parameter params:            An object holding all the available parameters for uploading.
   - parameter progress:          The closure that is called periodically during the data transfer.
   - parameter completionHandler: The closure to be called once the request has finished, holding either the response object or the error.

   - returns:                     An instance implementing the protocol `CLDNetworkDataRequest`,
                                  allowing the options to add a progress closure that is called periodically during the upload
                                  and a response closure to be called once the upload is finished,
                                  as well as performing actions on the request, such as cancelling, suspending or resuming it.
   */
    @discardableResult
    open func upload(data: Data, uploadPreset: String, params: CLDUploadRequestParams? = nil, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(false)
        params.setUploadPreset(uploadPreset)
        return performUpload(data: data, params: params, preprocessChain: CLDPreprocessChain<Any>(), progress: progress, completionHandler: completionHandler)
    }

    /**
   Uploads the given data to the configured cloud.

   - parameter data:              The data to upload.
   - parameter uploadPreset:      The upload preset to use for unsigned upload.
   - parameter params:            An object holding all the available parameters for uploading.
   - parameter preprocessChain    A CLDPreprocessing chain containing processing steps and/or custom encoder to run on the resource before uploading
   - parameter progress:          The closure that is called periodically during the data transfer.
   - parameter completionHandler: The closure to be called once the request has finished, holding either the response object or the error.

   - returns:                     An instance implementing the protocol `CLDNetworkDataRequest`,
                                  allowing the options to add a progress closure that is called periodically during the upload
                                  and a response closure to be called once the upload is finished,
                                  as well as performing actions on the request, such as cancelling, suspending or resuming it.
   */
    @discardableResult
    open func upload<T>(data: Data, uploadPreset: String, params: CLDUploadRequestParams? = nil, preprocessChain:CLDPreprocessChain<T>, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(false)
        params.setUploadPreset(uploadPreset)
        return performUpload(data: data, params: params, preprocessChain: preprocessChain, progress: progress, completionHandler: completionHandler)
    }

    /**
 Uploads a file from the specified URL to the configured cloud.
 The URL can either be of a local file (i.e. from the bundle) or can point to a remote file.

 - parameter url:               The URL pointing to the file to upload.
 - parameter uploadPreset:      The upload preset to use for unsigned upload.
 - parameter params:            An object holding all the available parameters for uploading.
 - parameter progress:          The closure that is called periodically during the data transfer.
 - parameter completionHandler: The closure to be called once the request has finished, holding either the response object or the error.

 - returns:                     An instance implementing the protocol `CLDNetworkDataRequest`,
                                allowing the options to add a progress closure that is called periodically during the upload
                                and a response closure to be called once the upload is finished,
                                as well as performing actions on the request, such as cancelling, suspending or resuming it.
 */
    @discardableResult
    open func upload(url: URL, uploadPreset: String, params: CLDUploadRequestParams? = nil, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(false)
        params.setUploadPreset(uploadPreset)
        return performUpload(data: url, params: params, preprocessChain: CLDPreprocessChain<Any>(), progress: progress, completionHandler: completionHandler)
    }

    /**
Uploads a file from the specified URL to the configured cloud.
The URL can either be of a local file (i.e. from the bundle) or can point to a remote file.

- parameter url:               The URL pointing to the file to upload.
- parameter uploadPreset:      The upload preset to use for unsigned upload.
- parameter params:            An object holding all the available parameters for uploading.
- parameter preprocessChain    A CLDPreprocessing chain containing processing steps and/or custom encoder to run on the resource before uploading
- parameter progress:          The closure that is called periodically during the data transfer.
- parameter completionHandler: The closure to be called once the request has finished, holding either the response object or the error.

- returns:                     An instance implementing the protocol `CLDNetworkDataRequest`,
                               allowing the options to add a progress closure that is called periodically during the upload
                               and a response closure to be called once the upload is finished,
                               as well as performing actions on the request, such as cancelling, suspending or resuming it.
*/
    @discardableResult
    open func upload<T>(url: URL, uploadPreset: String, params: CLDUploadRequestParams? = nil, preprocessChain: CLDPreprocessChain<T>, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(false)
        params.setUploadPreset(uploadPreset)
        return performUpload(data: url, params: params, preprocessChain: preprocessChain, progress: progress, completionHandler: completionHandler)
    }

    /**
    Uploads the given data to the configured cloud.

    - parameter data:               The data to upload.
    - parameter params:             An object holding all the available parameters for uploading.
    - parameter progress:      The closure that is called periodically during the data transfer.
    - parameter completionHandler:  The closure to be called once the request has finished, holding either the response object or the error.

    - returns:                      An instance implementing the protocol `CLDNetworkDataRequest`,
                                    allowing the options to add a progress closure that is called periodically during the upload
                                    and a response closure to be called once the upload is finished,
                                    as well as performing actions on the request, such as cancelling, suspending or resuming it.
    */
    @discardableResult
    open func signedUpload(data: Data, params: CLDUploadRequestParams? = nil, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(true)
        return performUpload(data: data, params: params, preprocessChain: CLDPreprocessChain<Any>(), progress: progress, completionHandler: completionHandler)
    }

    /**
    Uploads the given data to the configured cloud.

    - parameter data:               The data to upload.
    - parameter params:             An object holding all the available parameters for uploading.
    - parameter preprocessChain     A CLDPreprocessing chain containing processing steps and/or custom encoder to run on the resource before uploading
    - parameter progress:           The closure that is called periodically during the data transfer.
    - parameter completionHandler:  The closure to be called once the request has finished, holding either the response object or the error.

    - returns:                      An instance implementing the protocol `CLDNetworkDataRequest`,
                                    allowing the options to add a progress closure that is called periodically during the upload
                                    and a response closure to be called once the upload is finished,
                                    as well as performing actions on the request, such as cancelling, suspending or resuming it.
    */
    @discardableResult
    open func signedUpload<T>(data: Data, params: CLDUploadRequestParams? = nil, preprocessChain:CLDPreprocessChain<T>, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(true)
        return performUpload(data: data, params: params, preprocessChain:preprocessChain, progress: progress, completionHandler: completionHandler)
    }

    /**
     Uploads a file from the specified URL to the configured cloud.
     The URL can either be of a local file (i.e. from the bundle) or can point to a remote file.
     - parameter url:              The URL pointing to the file to upload.
     - parameter params:            An object holding all the available parameters for uploading.
     - parameter progress:     The closure that is called periodically during the data transfer.
     - parameter completionHandler: The closure to be called once the request has finished, holding either the response object or the error.
     - returns:                     An instance implementing the protocol `CLDNetworkDataRequest`,
                                    allowing the options to add a progress closure that is called periodically during the upload
                                    and a response closure to be called once the upload is finished,
                                    as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func signedUpload(url: URL, params: CLDUploadRequestParams? = nil, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(true)
        return performUpload(data: url, params: params, preprocessChain: CLDPreprocessChain<Any>(), progress: progress, completionHandler: completionHandler)
    }

    /**
     Uploads a file from the specified URL to the configured cloud.
     The URL can either be of a local file (i.e. from the bundle) or can point to a remote file.
     - parameter url:               The URL pointing to the file to upload.
     - parameter params:            An object holding all the available parameters for uploading.
     - parameter preprocessChain    A CLDPreprocessing chain containing processing steps and/or custom encoder to run on the resource before uploading
     - parameter progress:          The closure that is called periodically during the data transfer.
     - parameter completionHandler: The closure to be called once the request has finished, holding either the response object or the error.
     - returns:                     An instance implementing the protocol `CLDNetworkDataRequest`,
                                    allowing the options to add a progress closure that is called periodically during the upload
                                    and a response closure to be called once the upload is finished,
                                    as well as performing actions on the request, such as cancelling, suspending or resuming it.
     */
    @discardableResult
    open func signedUpload<T>(url: URL, params: CLDUploadRequestParams? = nil, preprocessChain: CLDPreprocessChain<T>, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        let params = params ?? CLDUploadRequestParams()
        params.setSigned(true)
        return performUpload(data: url, params: params, preprocessChain: preprocessChain, progress: progress, completionHandler: completionHandler)
    }

    /**
   Uploads a file in chunks from the specified local-file URL to the configured cloud

   - parameter url:               The URL pointing to the file to upload.
   - parameter uploadPreset:      The upload preset to use for unsigned upload.
   - parameter params:            An object holding all the available parameters for uploading.
   - parameter progress:          The closure that is called periodically during the data transfer.
   - parameter completionHandler: The closure to be called once the request is prepared, holding either the request object or an error
   */
    open func uploadLarge(url: URL, uploadPreset: String, params: CLDUploadRequestParams = CLDUploadRequestParams(), chunkSize: Int = defaultChunkSize, progress: ((Progress) -> Void)? = nil,
                          completionHandler: CLDUploadCompletionHandler? = nil) -> CLDUploadRequest{
        params.setSigned(false)
        params.setUploadPreset(uploadPreset)
        return performUploadLarge(url: url, params: params, preprocessChain: CLDPreprocessChain<Any>(), chunkSize: chunkSize, progress: progress, completionHandler: completionHandler)
    }

    /**
   Uploads a file in chunks from the specified local-file URL to the configured cloud

   - parameter url:               The URL pointing to the file to upload.
   - parameter uploadPreset:      The upload preset to use for unsigned upload.
   - parameter params:            An object holding all the available parameters for uploading.
   - parameter preprocessChain    A CLDPreprocessing chain containing processing steps and/or custom encoder to run on the resource before uploading
   - parameter progress:          The closure that is called periodically during the data transfer.
   - parameter completionHandler: The closure to be called once the request is prepared, holding either the request object or an error
   */
    open func uploadLarge<T>(url: URL, uploadPreset: String, params: CLDUploadRequestParams = CLDUploadRequestParams(), preprocessChain: CLDPreprocessChain<T>, chunkSize: Int = defaultChunkSize, progress: ((Progress) -> Void)? = nil,
                          completionHandler: CLDUploadCompletionHandler? = nil) -> CLDUploadRequest{
        params.setSigned(false)
        params.setUploadPreset(uploadPreset)
        return performUploadLarge(url: url, params: params, preprocessChain: preprocessChain, chunkSize: chunkSize, progress: progress, completionHandler: completionHandler)
    }

    /**
     Uploads a file in chunks from the specified local-file URL to the configured cloud

     - parameter url:               The URL pointing to the local file to upload.
     - parameter params:            An object holding all the available parameters for uploading.
     - parameter progress:          The closure that is called periodically during the data transfer.
     - parameter completionHandler: The closure to be called once the request is prepared, holding either the request object or an error
     */
    open func signedUploadLarge(url: URL, params: CLDUploadRequestParams = CLDUploadRequestParams(), chunkSize: Int = defaultChunkSize, progress: ((Progress) -> Void)? = nil,
                                completionHandler: CLDUploadCompletionHandler? = nil) -> CLDUploadRequest{
        params.setSigned(true)
        return performUploadLarge(url: url, params: params, preprocessChain: CLDPreprocessChain<Any>(), chunkSize: chunkSize, progress: progress, completionHandler: completionHandler)
    }

    /**
    Uploads a file in chunks from the specified local-file URL to the configured cloud

    - parameter url:               The URL pointing to the local file to upload.
    - parameter params:            An object holding all the available parameters for uploading.
    - parameter preprocessChain    A CLDPreprocessing chain containing processing steps and/or custom encoder to run on the resource before uploading
    - parameter progress:          The closure that is called periodically during the data transfer.
    - parameter completionHandler: The closure to be called once the request is prepared, holding either the request object or an error
    */
    open func signedUploadLarge<T>(url: URL, params: CLDUploadRequestParams = CLDUploadRequestParams(), preprocessChain: CLDPreprocessChain<T>, chunkSize: Int = defaultChunkSize, progress: ((Progress) -> Void)? = nil,
                                completionHandler: CLDUploadCompletionHandler? = nil) -> CLDUploadRequest{
        params.setSigned(true)
        return performUploadLarge(url: url, params: params, preprocessChain: preprocessChain, chunkSize: chunkSize, progress: progress, completionHandler: completionHandler)
    }

    fileprivate func performUploadLarge<T>(url: URL, params: CLDUploadRequestParams, preprocessChain: CLDPreprocessChain<T>, chunkSize: Int, progress: ((Progress) -> Void)? = nil,
                                        completionHandler: CLDUploadCompletionHandler? = nil) -> CLDUploadRequest {

        let uploadRequest = CLDUploadRequestWrapper()
        
        if let handler = completionHandler {
            uploadRequest.response(handler)
        }
        
        if let progress = progress {
            uploadRequest.progress(progress)
        }
        
        guard chunkSize >= 5 * 1024 * 1024 else {
            uploadRequest.setRequestError(CLDError.error(code: CLDError.CloudinaryErrorCode.generalErrorCode, message: "Chunk size must be greater than 5[MB]"))
            return uploadRequest
        }
        
        DispatchQueue.global().async {
            let newUrl:URL
            
            if (preprocessChain.isEmpty()){
                newUrl = url
            } else {
                do {
                    newUrl = try preprocessChain.execute(resourceData: url)
                } catch let error as NSError {
                    uploadRequest.setRequestError(error)
                    return
                } catch {
                    uploadRequest.setRequestError(CLDError.generalError())
                    return
                }
            }
            
            let totalLength = CLDFileUtils.getFileSize(url: newUrl)
            
            guard totalLength != nil else {
                uploadRequest.setRequestError (CLDError.error(code: CLDError.CloudinaryErrorCode.failedRetrievingFileInfo, message: "zero file length"))
                return
            }
            
            let randomId = NSUUID().uuidString
            if let parts = CLDFileUtils.splitFile(url: newUrl, name: randomId, chunkSize: chunkSize) {
                uploadRequest.setRequestsData(count: parts.count, totalLength: totalLength)
                uploadRequest.cleanupHandler { success in
                    DispatchQueue.global().async {
                        CLDFileUtils.removeFiles(files: parts)
                    }
                }
                
                for part in parts {
                    let range = "bytes \(part.offset)-\(part.offset + Int64(part.length - 1))/\(totalLength!)"
                    uploadRequest.addRequest(self.performUpload(data: part.url, params: params, extraHeaders: ["X-Unique-Upload-Id": randomId, "Content-Range": range], preprocessChain: CLDPreprocessChain<Any>()))
                }
            } else {
                uploadRequest.setRequestError (CLDError.error(code: CLDError.CloudinaryErrorCode.failedRetrievingFileInfo, message: "Could not process file."))
            }
        }

        return uploadRequest
    }

    fileprivate func performUpload<T>(data: Any, params: CLDUploadRequestParams, extraHeaders: [String:String]? = [:], preprocessChain:CLDPreprocessChain<T>, progress: ((Progress) -> Void)? = nil, completionHandler:((_ response: CLDUploadResult?, _ error: NSError?) -> ())? = nil) -> CLDUploadRequest {
        
        let uploadRequest:CLDUploadRequest
        
        // if preprocess or validations are required, we'll need to offload the work to a background queue
        if preprocessChain.isEmpty(){
            let request = networkCoordinator.upload(data, params: params, extraHeaders: extraHeaders)
            uploadRequest = CLDDefaultUploadRequest(networkDataRequest: request)
        } else {
            let newRequest = CLDUploadRequestWrapper()
            uploadRequest = newRequest
            DispatchQueue.global().async {
                do {
                    let newUrl = try preprocessChain.execute(resourceData: data)
                    let length = CLDFileUtils.getFileSize(url: newUrl)
                    newRequest.setRequestsData(count: 1, totalLength: length)
                    // perform upload with the newly created file url, and empty preprocessing (it's done already)
                    newRequest.addRequest(self.performUpload(data: newUrl, params: params, extraHeaders: extraHeaders, preprocessChain: CLDPreprocessChain<Any>(), progress: progress, completionHandler: completionHandler))
                } catch let error as NSError {
                    newRequest.setRequestError(error)
                } catch {
                    newRequest.setRequestError(CLDError.generalError())
                }
            }
        }
        
        if let completionHandler = completionHandler {
            uploadRequest.response(completionHandler)
        }
        
        if let progress = progress {
            uploadRequest.progress(progress)
        }
        
        return uploadRequest
    }
}
