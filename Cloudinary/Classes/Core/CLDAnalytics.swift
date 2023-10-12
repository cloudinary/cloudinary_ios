//
//  CLDAnalytics.swift
//  Cloudinary
//
//  Created by Adi Mizrahi on 13/07/2022.
//

import Foundation
import UIKit
@objcMembers open class CLDAnalytics: NSObject {

    public static let shared = CLDAnalytics()

    private final let ALGO_VERSION = "C"
    private final let PRODUCT = "A"
    private final let SDK = "E"
    private final let OS_TYPE = "B"
    private final let ERROR_SIGNATURE = "E"
    private final let NO_FEATURE_CHAR = "0"

    private var sdkVersion: String? = nil
    private var techVersion: String? = nil


    public func generateAnalyticsSignature(sdkVersionString: String? = nil, techVersionString: String? = nil) -> String {
        if sdkVersion == nil {
            sdkVersion = sdkVersionString
            if sdkVersion == nil {
                sdkVersion = CLDNetworkCoordinator.getVersion()
            }
        }
        if techVersion == nil {
            techVersion = techVersionString
            if techVersion == nil {
                techVersion = getiOSVersion()
            }
        }
        let swiftVersionArray = techVersion!.split(usingRegex: "\\.|\\-")
        guard swiftVersionArray.count > 1, let swiftVersionString = generateVersionString(major: String(swiftVersionArray[0]), minor: String(swiftVersionArray[1]), patch: "") else {
            return ERROR_SIGNATURE
        }
        let sdkVersionArray = sdkVersion!.split(usingRegex: "\\.|\\-")
        guard sdkVersionArray.count > 1, let sdkVersionString = generateVersionString(major: String(sdkVersionArray[0]), minor: String(sdkVersionArray[1]), patch: String(sdkVersionArray[2])) else {
            return ERROR_SIGNATURE
        }
        return "\(ALGO_VERSION)\(PRODUCT)\(SDK)\(sdkVersionString)\(swiftVersionString)\(OS_TYPE)\(swiftVersionString)\(NO_FEATURE_CHAR)"
    }

    public func setSDKVersion(version: String) {
        sdkVersion = version;
    }

    public func setTechVersion(version: String) {
        techVersion = version;
    }

    private func generateVersionString(major: String, minor: String, patch: String) -> String? {
        let versionString = (patch.leftPadding(toLength: 2, withPad: "0") + minor.leftPadding(toLength: 2, withPad: "0") + major.leftPadding(toLength: 2, withPad: "0"))
        guard let doubleValue = Int(versionString) else {
            return nil
        }
        let hexString = String(doubleValue, radix: 2).leftPadding(toLength: 18, withPad: "0")


        var patchStr = ""
        if (!patch.isEmpty) {
            patchStr = String(hexString[hexString.startIndex..<hexString.index(hexString.startIndex, offsetBy: 6)]).toAnalyticsVersionStr()
        }
        let minorStr = String(hexString[hexString.index(hexString.startIndex, offsetBy: 6)..<hexString.index(hexString.startIndex, offsetBy: 12)]).toAnalyticsVersionStr()
        let majorStr = String(hexString[hexString.index(hexString.startIndex, offsetBy: 12)..<hexString.index(hexString.startIndex, offsetBy: 18)]).toAnalyticsVersionStr()

        return "\(patchStr)\(minorStr)\(majorStr)"
    }

    private func getiOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
}
extension String {
    func split(usingRegex pattern: String) -> [String] {
        //### Crashes when you pass invalid `pattern`
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self, range: NSRange(0..<utf16.count))
        let ranges = [startIndex..<startIndex] + matches.map{Range($0.range, in: self)!} + [endIndex..<endIndex]
        return (0...matches.count).map {String(self[ranges[$0].upperBound..<ranges[$0+1].lowerBound])}
    }
}
