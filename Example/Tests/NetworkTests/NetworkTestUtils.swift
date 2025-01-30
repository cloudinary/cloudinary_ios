//
//  NetworkTestUtils.swift
//  Cloudinary_Tests
//
//  Created by Adi Mizrahi on 29/01/2025.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
class NetworkTestUtils {

    private static let environmentFolderDecoupling = "CLD_FOLDER_DECOUPLING"

    static func skipFolderDecouplingTest() -> Bool {
        guard let _ = ProcessInfo.processInfo.environment[environmentFolderDecoupling] else {
            return false
        }
        return true
    }
}
