//
//  CLDAnalyticsTests.swift
//  Cloudinary_Tests
//
//  Created by Adi Mizrahi on 26/07/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Cloudinary
class CLDAnalyticsTests: BaseTestCase {

    func test_analyicsString() {
        let cldAnalytics = CLDAnalytics();
        let analyticsString = cldAnalytics.generateAnalyticsSignature()
        print(analyticsString)
    }
}
