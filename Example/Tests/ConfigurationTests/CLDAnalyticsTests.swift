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
        var analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "1.24.0",techVersionString: "12.0")
        XCTAssertEqual(analyticsString, "DAEAlhAMBMA0")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "1.24.0-beta.6",techVersionString: "12.0")
        XCTAssertEqual(analyticsString, "DAEAlhAMBMA0")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "1.24.0",techVersionString: "16.3")
        XCTAssertEqual(analyticsString, "DAEAlhE8BQD0")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "1.24.0",techVersionString: "17.1")
        XCTAssertEqual(analyticsString, "DAEAlhB1BRB0")
    }

    func test_errorAnalytics() {
        var analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "1.24.0",techVersionString: "0")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "0",techVersionString: "12.0")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "",techVersionString: "12.0")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "1.24.0",techVersionString: "")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersionString: "43.21.26",techVersionString: "5.0")
        XCTAssertEqual(analyticsString, "DAE;;;AFBFA0")
    }
}
