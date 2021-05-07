//
//  ExtensionCLDCloudinary.swift
//  
//
//  Created by Arkadi Yoskovitz on 5/7/21.
//

#if SWIFT_PACKAGE
    import Cloudinary_Core
#endif

#if os(iOS)
import UIKit
import Foundation

extension CLDCloudinary
{
    // MARK: Image Cache
    /**
     Sets Cloudinary SDK's caching policy for images that are downloaded via the SDK's CLDDownloader.
     The options are: **None**, **Memory** and **Disk**. default is Disk
     */
    open var cachePolicy: CLDImageCachePolicy {
        get {
            return downloadCoordinator.imageCache.cachePolicy
        }
        set {
            downloadCoordinator.imageCache.cachePolicy = newValue
        }
    }
    
    /**
     Sets Cloudinary SDK's image cache maximum disk capacity.
     default is 150 MB.
     */
    open var cacheMaxDiskCapacity: UInt64 {
        get {
            return downloadCoordinator.imageCache.maxDiskCapacity
        }
        set {
            downloadCoordinator.imageCache.maxDiskCapacity = newValue
        }
    }
    
    /**
     Sets Cloudinary SDK's image cache maximum memory total cost.
     default is 30 MB.
     */
    open var cacheMaxMemoryTotalCost: Int {
        get {
            return downloadCoordinator.imageCache.maxMemoryTotalCost
        }
        set {
            downloadCoordinator.imageCache.maxMemoryTotalCost = newValue
        }
    }
    
    /**
     Removes an image from the downloaded images cache, both disk and memory.
     
     - parameter key:    The full url of the image to remove.
     
     */
    open func removeFromCache(key: String) {
        downloadCoordinator.imageCache.removeCacheImageForKey(key)
    }
}
extension CLDDownloadCoordinator {
    /**
     Static var used to generate a unique address for the associated object
     */
    private struct AssociatedKeys {
        static var cldImageCache = "cldImageCache"
    }
    
    /**
     Add an associated object to UIImageView so we can track the current url 'attached' to the image view.
     This is important in case the view is used in an collection adapter where views are recycled, to verify
     that when the async download finishes the associated url hasn't changed
     */
    internal var imageCache : CLDImageCache {
        get {
            if let storedValue = objc_getAssociatedObject(self, &AssociatedKeys.cldImageCache) as? CLDImageCache {
                return storedValue
            } else {
                let cache = CLDImageCache(name: iOSDefines.cacheDefaultName)
                self.imageCache = cache
                return cache
            }
        }
        set {
            objc_setAssociatedObject(self,  &AssociatedKeys.cldImageCache, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

#endif
