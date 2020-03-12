//
//  CloudinaryHelper.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 05/09/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import Cloudinary

class CloudinaryHelper {
    static let defaultImageFormat = "png"

    static func upload(cloudinary: CLDCloudinary, url: URL, resourceType: CLDUrlResourceType) -> CLDUploadRequest {
        let params = CLDUploadRequestParams()
        params.setResourceType(resourceType)

        if (resourceType == CLDUrlResourceType.image) {
            let chain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.limit(width: 1500, height: 1500))
                    .setEncoder(CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.JPEG, quality: 90))
            return cloudinary.createUploader().uploadLarge(url: url, uploadPreset: "ios_sample", params: params, preprocessChain: chain, chunkSize: 5 * 1024 * 1024)
        } else {
            return cloudinary.createUploader().uploadLarge(url: url, uploadPreset: "ios_sample", params: params, chunkSize: 5 * 1024 * 1024)
        }
    }

    static func getThumbUrl(cloudinary: CLDCloudinary, resource: CLDResource) -> String {
        let transformation = CLDTransformation().setCrop(CLDTransformation.CLDCrop.scale).setWidth(350)
        return cloudinary.createUrl().setTransformation(transformation).setFormat(defaultImageFormat).setResourceType(resource.resourceType!).generate(resource.publicId!)!
    }

    static func generateEffectList(cloudinary: CLDCloudinary, resource: CLDResource) -> [EffectMetadata] {
        var transformation: CLDTransformation!
        var result = [EffectMetadata]()

        transformation = CLDTransformation().setEffect(CLDTransformation.CLDEffect.sharpen, param: "250")
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_face_sharpen", comment: "")))

        transformation = CLDTransformation().setEffect(CLDTransformation.CLDEffect.oilPaint, param: "100")
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_face_oilpaint", comment: "")))

        transformation = CLDTransformation().setEffect(CLDTransformation.CLDEffect.sepia)
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_narrow_sepia", comment: "")))

        transformation = CLDTransformation().setEffect(CLDTransformation.CLDEffect.saturation, param: "100").setRadius(50);
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_face_sat_round", comment: "")))

        transformation = CLDTransformation().setEffect(CLDTransformation.CLDEffect.blue, param: "100")
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_wide_blue", comment: "")))

        return result
    }

    static func generateVideoEffectList(cloudinary: CLDCloudinary, resource: CLDResource) -> [EffectMetadata] {
        var transformation: CLDTransformation!
        var result = [EffectMetadata]()

        transformation = CLDTransformation().setEffect(CLDTransformation.CLDEffect.blur, param: "200")
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_video_blur", comment: "")))

        transformation = CLDTransformation().setOverlay("video:\(resource.publicId!)").setWidth(0.25)
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_video_overlay", comment: "")))

        transformation = CLDTransformation().setAngle(20)
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_video_rotate", comment: "")))

        transformation = CLDTransformation().setEffect("fade", param: "1000")
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_video_fade_in", comment: "")))

        transformation = CLDTransformation().setEffect("noise", param: "100")
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_video_noise", comment: "")))

        transformation = CLDTransformation().setEffect("reverse")
        result.append(EffectMetadata(transformation: transformation, name: resource.name, description: NSLocalizedString("effect_desc_video_reverse", comment: "")))


        return result
    }

    fileprivate static func getUrlForTransformation(_ cloudinary: CLDCloudinary, _ transformation: CLDTransformation, _ resource: CLDResource, format: String = defaultImageFormat) -> String {
        transformation.setDpr(Float(UIScreen.main.scale))
        return cloudinary.createUrl()
                .setResourceType(resource.resourceType!)
                .setTransformation(transformation)
                .setFormat(format)
                .generate(resource.publicId!)!
    }
}

class EffectMetadata {
    let transformation: CLDTransformation!
    let name: String!
    let description: String!

    init(transformation: CLDTransformation!, name: String!, description: String!) {
        self.transformation = transformation
        self.name = name
        self.description = description
    }
}

// NOTE: The following extension is to demonstrate Cloudinary internals and is NOT provided for production use:
extension CLDTransformation: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = CLDTransformation()
        let mirror = Mirror(reflecting: self)
        var lastParams: [String: String]?
        for child in mirror.children {
            if child.label == "currentTransformationParams" {
                lastParams = child.value as? [String: String]
            } else if child.label == "transformations" {
                if let transformations = child.value as? [[String: String]] {
                    for params in transformations {
                        copyParams(params: params, copy: copy)
                        copy.chain()
                    }
                }
            }
        }

        if let params = lastParams {
            copyParams(params: params, copy: copy)
        }

        return copy
    }

    fileprivate func copyParams(params: [String: String], copy: CLDTransformation) {
        for param in params {
            copy.setParam(param.key, value: param.value)
        }
    }
}
