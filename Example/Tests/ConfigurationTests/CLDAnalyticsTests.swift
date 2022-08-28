//
//  CLDAnalyticsTests.swift
//  Cloudinary_Tests
//
//  Created by Adi Mizrahi on 26/07/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Cloudinary
import XCTest
class CLDAnalyticsTests: BaseTestCase {

    func test_analyicsString() {
        let cldAnalytics = CLDAnalytics();
        var analyticsString = cldAnalytics.generateAnalyticsSignature(sdkVersion: "1.24.0",techVersion: "12.0")
        XCTAssertEqual(analyticsString, "AEAlhAM0")

        analyticsString = cldAnalytics.generateAnalyticsSignature(sdkVersion: "1.24.0-beta.6",techVersion: "12.0")
        XCTAssertEqual(analyticsString, "AEAlhAM0")

    }
}
