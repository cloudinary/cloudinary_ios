//
//  AssetModel.swift
//  Cloudinary_Example
//
//  Created by Adi Mizrahi on 18/07/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
class AssetModel {
     private var deliveryType: String
     private var assetType: String
     private var transformation: String?
     private var publicId: String
    private var url: String

    init(deliveryType: String, assetType: String, transformation: String? = nil, publicId: String, url: String) {
        self.deliveryType = deliveryType
        self.assetType = assetType
        self.transformation = transformation
        self.publicId = publicId
        self.url = url
    }

    func setDeliveryType(_ type: String) {
        deliveryType = type
    }

    func setAssetType(_ type: String) {
        assetType = type
    }

    func setTransformation(_ trans: String) {
        transformation = trans
    }

    func setPublicId(_ id: String) {
        publicId = id
    }

    func setUrl(_ url: String) {
        self.url = url
    }

    func getDeliveryType() -> String {
        return deliveryType
    }

    func getAssetType() -> String {
        return assetType
    }

    func getTransformation() -> String? {
        return transformation
    }

    func getPublicId() -> String {
        return publicId
    }

    func getUrl() -> String {
        return url
    }
}
