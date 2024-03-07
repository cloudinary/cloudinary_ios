//
//  FileUtils.swift
//  iOS_Geekle_Conference
//
//  Created by Adi Mizrahi on 18/09/2023.
//

import Foundation
import UIKit
class FileUtils {
    static func getFileSizeForImage(_ image: UIImage) -> String {
        guard let imgData = image.jpegData(compressionQuality: 1.0) else {
            return ""
        }
        let imageSize: Int = imgData.count
        let size = Double(imageSize) / 1024.0 / 1024.0
        return "\(size.rounded(toPlaces: 2))"
    }

    static func getImageInfo(_ url: URL, completion: @escaping (_ format: String, _ size: String, _ dimensions: (width: CGFloat, height: CGFloat)) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                // Handle error case
                return
            }

            DispatchQueue.main.async {
                guard data.count > 0 else {
                    return
                }
                let format = ImageFormat.get(from: data).rawValue

                let imageSize: Int = data.count
                let size = Double(imageSize) / 1024.0 / 1024.0

                let image = UIImage(data: data)
                let dimensions = image.map { ($0.size.width, $0.size.height) }

                completion(format, "\(size.rounded(toPlaces: 2))", dimensions!)
            }
        }
    }

    private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
}

enum ImageFormat: String {
    case png, jpg, gif, tiff, webp, heic, unknown
}

extension ImageFormat {
    static func get(from data: Data) -> ImageFormat {
        switch data[0] {
        case 0x89:
            return .png
        case 0xFF:
            return .jpg
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        case 0x52 where data.count >= 12:
            let subdata = data[0...11]

            if let dataString = String(data: subdata, encoding: .ascii),
               dataString.hasPrefix("RIFF"),
               dataString.hasSuffix("WEBP")
            {
                return .webp
            }

        case 0x00 where data.count >= 12 :
            let subdata = data[8...11]

            if let dataString = String(data: subdata, encoding: .ascii),
               Set(["heic", "heix", "hevc", "hevx"]).contains(dataString)
            ///OLD: "ftypheic", "ftypheix", "ftyphevc", "ftyphevx"
            {
                return .heic
            }
        default:
            break
        }
        return .unknown
    }

    var contentType: String {
        return "image/\(rawValue)"
    }
}

