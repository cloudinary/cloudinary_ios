//
//  VideoHelper.swift
//  ios-video-testing
//
//  Created by Adi Mizrahi on 16/11/2023.
//

import Foundation
class VideoHelper {
    static func parsePlist() -> [String]? {
        if let path = Bundle.main.path(forResource: "video_links", ofType: "plist") {
            let videoDictonary = NSDictionary(contentsOfFile: path)
            if let videoLinks = videoDictonary?.allValues as? [String] {
                return videoLinks
            }

        }
        return nil
    }
}
