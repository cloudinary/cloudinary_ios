//
//  TestableCloudinary.swift
//  Cloudinary_Tests
//
//  Created by Adi Mizrahi on 30/01/2025.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Cloudinary

class TestableCloudinary {
    static func getNetworkCoordinator(from cloudinary: CLDCloudinary) -> AnyObject? {
        let mirror = Mirror(reflecting: cloudinary)
        for child in mirror.children {
            if String(describing: type(of: child.value)).contains("CLDNetworkCoordinator") {
                return child.value as AnyObject
            }
        }
        return nil
    }
}
