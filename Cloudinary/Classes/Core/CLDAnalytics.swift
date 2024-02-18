//
//  CLDAnalytics.swift
//  Cloudinary
//
//  Created by Adi Mizrahi on 13/07/2022.
//

import Foundation
import UIKit
@objcMembers open class CLDAnalytics: NSObject {

    private final let ALGO_VERSION = "D"
    private final let PRODUCT = "A"
    private final let SDK = "E"
    private final let OS_TYPE = "B"
    private final let ERROR_SIGNATURE = "E"

    private var sdkVersion: String? = nil
    private var techVersion: String? = nil
    private var osVersion: String? = nil
    private var osType: String? = nil
    private var featureFlag = "0"

    public init(sdkVersion: String? = nil, techVersion: String? = nil, osType: String? = "B", osVersion: String? = nil, featureFlag: String? = nil) {
        super.init()
        self.sdkVersion = sdkVersion ?? CLDNetworkCoordinator.getVersion()
        self.techVersion = techVersion ?? getiOSVersion()
        self.osType = osType
        self.osVersion = osVersion ?? getiOSVersion()
        self.featureFlag = featureFlag ?? "0"
    }


    public func generateAnalyticsSignature(sdkVersion: String? = nil, techVersion: String? = nil, osType: String? = "B", osVersion: String? = nil, featureFlag: String? = nil) -> String {
        let sdkVersion = sdkVersion ?? self.sdkVersion
        let techVersion = techVersion ?? self.techVersion
        let osType = osType ?? self.osType
        let osVersion = osVersion ?? self.osVersion
        let featureFlag = featureFlag ?? self.featureFlag
        let swiftVersionArray = techVersion!.split(usingRegex: "\\.|\\-")
        guard swiftVersionArray.count > 1, let techVersionString = generateVersionString(major: String(swiftVersionArray[0]), minor: String(swiftVersionArray[1]), patch: "") else {
            return ERROR_SIGNATURE
        }
        let osVersionArray = osVersion!.split(usingRegex: "\\.|\\-")
        guard let osVersionString = generateOSVersionString(major: String(osVersionArray[0]), minor: String(osVersionArray[1])) else {
            return ERROR_SIGNATURE
        }
        let sdkVersionArray = sdkVersion!.split(usingRegex: "\\.|\\-")
        guard sdkVersionArray.count > 1, let sdkVersionString = generateVersionString(major: String(sdkVersionArray[0]), minor: String(sdkVersionArray[1]), patch: String(sdkVersionArray[2])) else {
            return ERROR_SIGNATURE
        }
        return "\(ALGO_VERSION)\(PRODUCT)\(SDK)\(sdkVersionString)\(techVersionString)\(osType ?? OS_TYPE)\(osVersionString)\(featureFlag)"
    }

    public func setSDKVersion(version: String) {
        sdkVersion = version
    }

    public func setTechVersion(version: String) {
        techVersion = version
    }

    public func setOsVersion(version: String) {
        osVersion = version
    }

    public func setFeatureFlag(flag: String? = nil) {
        guard let flag = flag else {
            featureFlag = "0"
            return
        }
        featureFlag = flag
    }

    private func generateOSVersionString(major: String, minor: String) -> String? {
        let majorVersionString = major.leftPadding(toLength: 2, withPad: "0")
        let minorVersionString = minor.leftPadding(toLength: 2, withPad: "0")
        guard let majorDoubleValue = Int(majorVersionString), let minorDoubleValue = Int(minorVersionString) else {
            return nil
        }
        let majorString = String(majorDoubleValue, radix: 2)
        let minorString = String(minorDoubleValue, radix: 2)
        let majorStr = majorString.toAnalyticsVersionStr()
        let minorStr = minorString.toAnalyticsVersionStr()
        
        return "\(majorStr)\(minorStr)"
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
