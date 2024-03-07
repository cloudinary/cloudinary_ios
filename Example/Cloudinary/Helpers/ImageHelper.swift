//
//  ImageHelper.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 09/01/2024.
//

import Foundation
import UIKit
class ImageHelper {
    static func getImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
