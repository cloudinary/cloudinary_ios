//
//  CloudinaryHelper.swift
//  iOS_Geekle_Conference
//
//  Created by Adi Mizrahi on 12/09/2023.
//

import Foundation
import Cloudinary

class CloudinaryHelper {
    static let shared = CloudinaryHelper()

    var cloudinary: CLDCloudinary

    init() {
        cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "mobiledemoapp", secure: true))
    }

    func setUploadCloud(_ cloudName: String?) {
        guard let cloudName = cloudName else {
            return
        }
        UserDefaults.standard.set(cloudName, forKey: "uploadCloudName")
    }

    func getUploadCloud() -> String? {
        guard let cloudName = UserDefaults.standard.value(forKey: "uploadCloudName") as? String else {
            return nil
        }
        return cloudName
    }
}
