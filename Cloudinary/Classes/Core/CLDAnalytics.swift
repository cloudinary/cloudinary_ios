//
//  CLDAnalytics.swift
//  Cloudinary
//
//  Created by Adi Mizrahi on 13/07/2022.
//

import Foundation
@objcMembers open class CLDAnalytics: NSObject {
    private final let ALGO_VERSION = "A"
    private final let SDK = "E"
    private final let ERROR_SIGNATURE = "E"
    private final let NO_FEATURE_CHAR = "0"

    public func generateAnalyticsSignature() -> String {
        let sdkVersion = CLDNetworkCoordinator.DEFAULT_VERSION
        let swiftVersion = getSwiftVersion()
        let swiftVersionArray = swiftVersion.split(separator: ".")
        guard let swiftVersionString = generateVersionString(major: String(swiftVersionArray[0]), minor: String(swiftVersionArray[1]), patch: "0") else {
            return ERROR_SIGNATURE
        }
        let sdkVersionArray = sdkVersion.split(separator: ".")
        guard let sdkVersionString = generateVersionString(major: String(sdkVersionArray[0]), minor: String(sdkVersionArray[1]), patch: String(sdkVersion[2])) else {
            return ERROR_SIGNATURE
        }
        return "\(ALGO_VERSION)\(sdkVersionString)\(swiftVersionString)\(NO_FEATURE_CHAR)"
    }

    private func generateVersionString(major: String, minor: String, patch: String) -> String? {
        let versionString = (patch.padding(toLength: 2, withPad: "0", startingAt: 0) + minor.padding(toLength: 2, withPad: "0", startingAt: 0) + major.padding(toLength: 2, withPad: "0", startingAt: 0))
        guard let doubleValue = Int(versionString) else {
            return nil
        }
        let hexString = String(doubleValue, radix: 2).leftPadding(toLength: 18, withPad: "0")


        var patchStr = ""
        if (!patch.isEmpty) {
            patchStr = String(hexString[hexString.startIndex..<hexString.index(hexString.startIndex, offsetBy: 5)]).toAnalyticsVersionStr()
        }
        let minorStr = String(hexString[hexString.index(hexString.startIndex, offsetBy: 6)..<hexString.index(hexString.startIndex, offsetBy: 11)]).toAnalyticsVersionStr()
        let majorStr = String(hexString[hexString.index(hexString.startIndex, offsetBy: 12)..<hexString.index(hexString.startIndex, offsetBy: 18)]).toAnalyticsVersionStr()

        return "\(patchStr)\(minorStr)\(majorStr)"
    }

    private func getSwiftVersion() -> String {
        #if swift(>=5.0)
            return "5.0"
        #elseif swift(>=4.0)
            return 4.0
        #elseif swift(>=3.0)
            return 3.0
        #elseif swift(>=2.2)
            return 2.2
        #elseif swift(>=2.1)
            return 2.1
        #endif
    }
}
