//
//  Photo.swift
//  PhotoAlbum
//

import UIKit
import os.log


class Photo: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var image: UIImage? // holds an image until it is uploaded to Cloudinary, then it is set to nil
    var publicId: String?

    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let image = "image"
        static let publicId = "publicId"
    }
    
    //MARK: Initialization
    
    init?(name: String, image: UIImage? = nil, publicId: String? = nil) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.image = image
        self.publicId = publicId

    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(publicId, forKey: PropertyKey.publicId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because image is an optional property of Photo, just use conditional cast.
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        let publicId = aDecoder.decodeObject(forKey: PropertyKey.publicId) as? String

        // Must call designated initializer.
        self.init(name: name, image: image, publicId: publicId)
        
    }
}
