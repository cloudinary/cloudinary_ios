//
//  CLDImageCache.swift
//
//  Copyright (c) 2016 Cloudinary (http://cloudinary.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation


@objc public enum CLDImageCachePolicy: Int {
    case none, memory, disk
}

private struct Defines {
    static let cacheDefaultName = "defaultImageCache"
    static let cacheBaseName = "com.cloudinary.sdk.imageCache"
    static let readWriteQueueName = "com.cloudinary.sdk.imageCache.readWriteQueue"
    static let defaultMemoryTotalCostLimit = 30 * 1024 * 1024  // 30 MB
    static let defaultMaxDiskCapacity = 150 * 1024 * 1024  // 150 MB
    static let thresholdPercentSize = UInt64(0.8)
    static let defaultBytesPerPixel = 4
}


internal class CLDImageCache {
    
    internal var cachePolicy = CLDImageCachePolicy.disk
    
    fileprivate let memoryCache = NSCache<NSString, UIImage>()
    internal var maxMemoryTotalCost: Int = Defines.defaultMemoryTotalCostLimit {
        didSet{
            memoryCache.totalCostLimit = maxMemoryTotalCost
            self.clearMemoryCache()
        }
    }
    
    fileprivate let diskCacheDir: String
    
    
    // Disk Size Control
    internal var maxDiskCapacity: UInt64 = UInt64(Defines.defaultMaxDiskCapacity) {
        didSet {
            clearDiskToMatchCapacityIfNeeded()
        }
    }
    fileprivate var usedCacheSize: UInt64 = 0
    
    fileprivate let readWriteQueue: DispatchQueue
    
    internal static let defaultImageCache: CLDImageCache = CLDImageCache(name: Defines.cacheDefaultName)
    
    //MARK: - Lifecycle
    
    init(name: String, diskCachePath: String? = nil) {
        
        let cacheName = "\(Defines.cacheBaseName).\(name)"
        memoryCache.name = cacheName
        
        let diskPath = diskCachePath ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        diskCacheDir = diskPath.cldStringByAppendingPathComponent(str: cacheName)
        
        readWriteQueue = DispatchQueue(label: Defines.readWriteQueueName + name, attributes: [])
        
        calculateCurrentDiskCacheSize()
        clearDiskToMatchCapacityIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CLDImageCache.clearMemoryCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Get Object
    
    internal func getImageForKey(_ key: String, completion: @escaping (_ image: UIImage?) -> ()) {
        
        let callCompletionClosureOnMain = { (image: UIImage?) in
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        if let memoryImage = memoryCache.object(forKey: key as NSString) {
            let path = getFilePathFromKey(key)
            readWriteQueue.async {
                self.updateDiskImageModifiedDate(path)
            }
            callCompletionClosureOnMain(memoryImage)
        }
        else {
            readWriteQueue.async {
                if let diskImage = self.getImageFromDiskForKey(key) {
                    callCompletionClosureOnMain(diskImage)
                    self.cacheImage(diskImage, data: nil, key: key, includingDisk: false, completion: nil)
                }
                else {
                    callCompletionClosureOnMain(nil)
                }
            }
        }
    }
    
    // MARK: - Set Object
    
    internal func cacheImage(_ image: UIImage, data: Data?, key: String, completion: (() -> ())?) {
        cacheImage(image, data: data, key: key, includingDisk: true, completion: completion)
    }

    func costFor(image: UIImage) -> Int {
        if let imageRef = image.cgImage {
            return imageRef.bytesPerRow * imageRef.height
        }

        // Without the underlying cgImage we can only estimate, assuming 4 bytes per pixel (RGBA):
        return Int(image.size.height * image.scale * image.size.width * image.scale) * Defines.defaultBytesPerPixel
    }

    fileprivate func cacheImage(_ image: UIImage, data: Data?, key: String, includingDisk: Bool, completion: (() -> ())?) {

        if cachePolicy == .memory || cachePolicy == .disk {
            let cost = costFor(image: image)
            memoryCache.setObject(image, forKey: key as NSString, cost: cost)
        }

        if cachePolicy == .disk && includingDisk {
            let path = getFilePathFromKey(key)
            readWriteQueue.async {
                // If the original data was passed, save the data to the disk, otherwise default to UIImagePNGRepresentation to create the data from the image
                if let data = data ?? image.pngData() {
                    // create the cach directory if it doesn't exist
                    if !FileManager.default.fileExists(atPath: self.diskCacheDir) {
                        do {
                            try FileManager.default.createDirectory(atPath: self.diskCacheDir, withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            printLog(.warning, text: "Failed while attempting to create the image cache directory.")
                        }
                    }

                    FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
                    self.usedCacheSize += UInt64(data.count)
                    self.clearDiskToMatchCapacityIfNeeded()
                }
                else {
                    printLog(.warning, text: "Couldn't convert image to data for key: \(key)")
                }
                completion?()
            }
        }
        else {
            completion?()
        }
    }
    
    // MARK: - Remove Object
    
    internal func removeCacheImageForKey(_ key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        let path = getFilePathFromKey(key)
        removeFileAtPath(path)
    }
    
    fileprivate func removeFileAtPath(_ path: String) {
        readWriteQueue.async {
            if let fileAttr = self.getFileAttributes(path) {
                let fileSize = fileAttr.fileSize()
                do {
                    try FileManager.default.removeItem(atPath: path)
                    self.usedCacheSize = self.usedCacheSize > fileSize ? self.usedCacheSize - fileSize : 0
                } catch {
                    printLog(.warning, text: "Failed while attempting to remove a cached file")
                }
            }
        }
    }
    
    // MARK: - Clear
    
    fileprivate func clearDiskToMatchCapacityIfNeeded() {
        if usedCacheSize < maxDiskCapacity {
            return
        }
        
        if let sortedUrls = sortedDiskImagesByModifiedDate() {
            for url in sortedUrls {
                removeFileAtPath(url.path)
                if usedCacheSize <= UInt64(maxDiskCapacity * Defines.thresholdPercentSize) {
                    break
                }
            }
        }
    }
    
    @objc fileprivate func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
    // MARK: - State
    
    internal func hasCachedImageForKey(_ key: String) -> Bool {
        var hasCachedImage = false
        if memoryCache.object(forKey: key as NSString) != nil {
            hasCachedImage = true
        }
        else {
            let imagePath = getFilePathFromKey(key)
            hasCachedImage = hasCachedDiskImageAtPath(imagePath)
        }
        
        return hasCachedImage
    }
    
    fileprivate func hasCachedDiskImageAtPath(_ path: String) -> Bool {
        var hasCachedImage = false
        readWriteQueue.sync {
            hasCachedImage = FileManager.default.fileExists(atPath: path)
        }
        return hasCachedImage
    }

    // MARK: - Disk Image Helpers
    
    fileprivate func getImageFromDiskForKey(_ key: String) -> UIImage? {
        if let data = getDataFromDiskForKey(key) {
            return data.cldToUIImageThreadSafe()
        }
        return nil
    }
    
    fileprivate func getDataFromDiskForKey(_ key: String) -> Data? {
        let imagePath = getFilePathFromKey(key)
        updateDiskImageModifiedDate(imagePath)
        return (try? Data(contentsOf: URL(fileURLWithPath: imagePath)))
    }
    
    fileprivate func getFilePathFromKey(_ key: String) -> String {
        let fileName = getFileNameFromKey(key)
        return diskCacheDir.cldStringByAppendingPathComponent(str: fileName)
    }
    
    fileprivate func getFileNameFromKey(_ key: String) -> String {
        return key.cld_md5()
    }
    
    fileprivate func updateDiskImageModifiedDate(_ path: String) {
        do {
            try FileManager.default.setAttributes([FileAttributeKey.modificationDate : Date()], ofItemAtPath: path)
        } catch {
            printLog(.warning, text: "Failed attempting to update cached file modified date.")
        }
    }
    
    // MARK: - Disk Capacity Helpers
    
    fileprivate func calculateCurrentDiskCacheSize() {
        let fileManager = FileManager.default
        usedCacheSize = 0
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: diskCacheDir)
            for pathComponent in contents {
                let filePath = diskCacheDir.cldStringByAppendingPathComponent(str: pathComponent)
                if let fileAttr = getFileAttributes(filePath) {
                    usedCacheSize += fileAttr.fileSize()
                }
            }
            
        } catch {
            printLog(.warning, text: "Failed listing cache directiry")
        }
    }
    
    fileprivate func sortedDiskImagesByModifiedDate() -> [URL]? {
        let dirUrl = URL(fileURLWithPath: diskCacheDir)
        do {
            let urlArray = try FileManager.default.contentsOfDirectory(at: dirUrl, includingPropertiesForKeys: [URLResourceKey.contentModificationDateKey], options:.skipsHiddenFiles)
            
            return urlArray.map { url -> (URL, TimeInterval) in
                var lastModified : AnyObject?
                _ = try? (url as NSURL).getResourceValue(&lastModified, forKey: URLResourceKey.contentModificationDateKey)
                return (url, lastModified?.timeIntervalSinceReferenceDate ?? 0)
                }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 }
        } catch {
            printLog(.warning, text: "Failed listing cache directiry")
            return nil
        }
    }
    
    fileprivate func getFileAttributes(_ path: String) -> NSDictionary? {
        var fileAttr: NSDictionary?
        do {
            fileAttr = try FileManager.default.attributesOfItem(atPath: path) as NSDictionary
        } catch {
            printLog(.warning, text: "Failed while attempting to retrive a cached file attributes for filr at path: \(path)")
        }
        return fileAttr
    }

}
