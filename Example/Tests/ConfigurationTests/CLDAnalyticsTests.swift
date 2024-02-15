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
        var analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "1.24.0",techVersion: "12.0", osType: "B", osVersion: "12.0")
        XCTAssertEqual(analyticsString, "DAEAlhAMBMA0")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "1.24.0-beta.6",techVersion: "12.0", osType: "B", osVersion: "12.0")
        XCTAssertEqual(analyticsString, "DAEAlhAMBMA0")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "1.24.0",techVersion: "16.3", osType: "B", osVersion: "16.3")
        XCTAssertEqual(analyticsString, "DAEAlhE8BQD0")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "1.24.0",techVersion: "17.1", osType: "B", osVersion: "17.1")
        XCTAssertEqual(analyticsString, "DAEAlhB1BRB0")
    }

    func test_errorAnalytics() {
        var analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "1.24.0",techVersion: "0")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "0",techVersion: "12.0")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "",techVersion: "12.0")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "1.24.0",techVersion: "")
        XCTAssertEqual(analyticsString, "E")

        analyticsString = CLDAnalytics().generateAnalyticsSignature(sdkVersion: "43.21.26",techVersion: "5.0", osVersion: "17.1")
        XCTAssertEqual(analyticsString, "DAE;;;AFBRB0")
    }

    func test_analyticsInitialized() {
        let analytics = CLDAnalytics(sdkVersion: "1.24.0",techVersion: "12.0", osType: "B", osVersion: "12.0")
        XCTAssertEqual(analytics.generateAnalyticsSignature(), "DAEAlhAMBMA0")

        analytics.setSDKVersion(version: "1.25.0")
        XCTAssertEqual(analytics.generateAnalyticsSignature(), "DAEAnFAMBMA0")

        analytics.setTechVersion(version: "13.0")
        XCTAssertEqual(analytics.generateAnalyticsSignature(), "DAEAnFANBMA0")

        analytics.setOsVersion(version: "17.1")
        XCTAssertEqual(analytics.generateAnalyticsSignature(), "DAEAnFANBRB0")
    }

    func test_analyticsFeatureFlag() {
        let analytics = CLDAnalytics(sdkVersion: "1.24.0",techVersion: "12.0", osType: "B", osVersion: "12.0", featureFlag: "E")
        XCTAssertEqual(analytics.generateAnalyticsSignature(), "DAEAlhAMBMAE")
    }
}
