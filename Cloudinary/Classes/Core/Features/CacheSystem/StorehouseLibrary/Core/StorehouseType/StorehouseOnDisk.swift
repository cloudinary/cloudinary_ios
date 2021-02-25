//
//  StorehouseOnDisk.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
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
///
///
///
typealias ResourceObject = (url: Foundation.URL, resourceValues: URLResourceValues)
///
/// Save objects to file on disk
///
final internal class StorehouseOnDisk<StoredItem>: StorehouseAnyFileSystem<StoredItem>
{
    /// MARK: - Types
    enum Error : Swift.Error {
        case fileEnumeratorFailed
    }
    
    /// MARK: - Properties
    
    ///
    /// Caches Directory URL
    ///
    fileprivate class var cachesDirectoryURL : URL {
        
        let urls = FileManager.init().urls(for: .cachesDirectory, in: .userDomainMask)
        let directory = urls[urls.endIndex - 1]
        return directory
    }
    
    ///
    /// The name of the application container
    ///
    internal var applicationName    : String {
        return Bundle.main.bundleIdentifier!
    }
    
    ///
    /// The name of the cache container
    ///
    internal var cacheContainerName : String {
        return configuration.name
    }
    
    ///
    /// The on-disk capacity of the receiver.
    ///
    /// The on-disk capacity, measured in bytes, for the receiver.
    /// On mutation the on-disk cache will truncate its contents to the size given, if necessary.
    ///
    internal override var diskCapacity     : Int {
        return configuration.maximumSize
    }
    
    ///
    /// Returns the current amount of space consumed by the on-disk storage of the receiver.
    ///
    /// This size, measured in bytes, indicates the current usage of the on-disk storage.
    ///
    internal override var currentDiskUsage : Int {

        var diskUsage : Int = 0
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: diskFilesFolderURL.path)
            
            let basePath = diskFilesFolderURL.path
            
            for pathComponent in contents {
            
                let filePath    = NSString(string: basePath).appendingPathComponent(pathComponent)
                let attributes  = try fileManager.attributesOfItem(atPath: filePath)
                if let fileSize = attributes[.size] as? Int {
                    diskUsage += fileSize
                }
            }
        }
        catch {
            diskUsage = NSNotFound
        }
        return diskUsage
    }
    
    ///
    /// The name of the cache folder on disk, containg the different files
    ///
    internal var diskFolderName : String {
        return "CLDURLCache.Cache"
    }
    
    ///
    ///
    ///
    internal lazy var diskFilesFolderURL : URL = {
        
        let cacheDirectoryURL = StorehouseOnDisk<StoredItem>.cachesDirectoryURL
        let cacheBaseURL      = cacheDirectoryURL.appendingPathComponent(applicationName)
        let cacheContainerURL = cacheBaseURL.appendingPathComponent(cacheContainerName)
        let finalDirectoryURL = cacheContainerURL.appendingPathComponent(diskFolderName)
        return finalDirectoryURL
    }()
    
    /// File manager to read/write to the disk
    internal let fileManager : FileManager
    
    /// Configuration
    fileprivate let configuration : StorehouseConfigurationDisk
    
    /// Transformer used by the system to archive the StoredItem
    fileprivate let transformer   : StorehouseTransformer<Item>
    
    /// MARK: - Initializers
    
    ///
    ///
    ///
    internal init(configuration: StorehouseConfigurationDisk, fileManager: FileManager = FileManager.default, transformer: StorehouseTransformer<Item>) throws
    {
        self.configuration = configuration
        self.fileManager   = fileManager
        self.transformer   = transformer
        
        super.init()
        
        try createDirectoryIfNeeded(at: diskFilesFolderURL, using: fileManager)
        
        // protection
        guard let protectionType = configuration.protectionType else { return }
        try setDirectory([.protectionKey:protectionType], using: fileManager, atPath: diskFilesFolderURL.path)
    }
    
    ///
    /// Creates a directory at a given url, if it doesnt exists
    ///
    /// - Parameters:
    ///     - url        : The target directory url
    ///     - fileManager: File manager to be used by this method
    ///
    fileprivate func createDirectoryIfNeeded(at url: URL?, using fileManager: FileManager) throws
    {
        guard let URLObject = url , !fileManager.fileExists(atPath: URLObject.path, isDirectory: nil) else { return }
     
        do {
            try fileManager.createDirectory(atPath: URLObject.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError {
            printLog(.error, text: "Error unable to create directory \(URLObject.path)")
            printLog(.error, text: "Error \(error.debugDescription)")
            throw error
        }
    }
    
    ///
    /// Sets attributes on a directory.
    ///
    /// - Parameters:
    ///     - attributes : File attributes dictionary to set
    ///     - fileManager: File manager to be used by this method
    ///     - path       : The file we set the attributes for
    ///
    fileprivate func setDirectory(_ attributes: [FileAttributeKey: Any], using fileManager: FileManager, atPath path: String) throws {
        try fileManager.setAttributes(attributes, ofItemAtPath: path)
    }
    
    ///
    /// Builds file name from the key.
    ///
    /// - Parameter key: Unique key to identify the object in the cache
    /// - Returns: A md5 encoded file name
    ///
    internal func makeFileName(for key: String) -> String
    {
        let fileName      = key.cld_md5()
        let fileExtension = URL(fileURLWithPath: key).pathExtension
        
        switch fileExtension.isEmpty
        {
        case true : return "\(fileName)"
        case false: return "\(fileName).\(fileExtension)"
        }
    }
    
    ///
    /// Builds file path from the key.
    /// - Parameter key: Unique key to identify the object in the cache
    /// - Returns: A string path based on key
    ///
    internal func makeFilePath(for key: String) -> String
    {
        return diskFilesFolderURL.appendingPathComponent(makeFileName(for: key)).path
    }
    
    ///
    /// Extract items information closure from a givent items url array
    ///
    /// - Parameters:
    ///     - itemURLs: An array of urls to extract the information
    ///     - baseDate: The base date used to decide if we need to delete an item
    ///
    fileprivate func extractItemsInformation(from itemURLs: [URL], comperAgainst baseDate: Date) throws -> (filesToDelete: [URL], resourceObjects: [ResourceObject], totalItemsSize: Int)
    {
        let resourceKeys: [URLResourceKey] = [
            .isDirectoryKey,
            .contentModificationDateKey,
            .totalFileAllocatedSizeKey
        ]
        
        var toDelete   = [URL]()
        var resources = [ResourceObject]()
        var totalSize  = Int(0)
        
        for url in itemURLs {
            
            let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
            
            guard resourceValues.isDirectory != true else { continue }
            
            if let expiryDate = resourceValues.contentModificationDate, expiryDate.timeIntervalSince1970 - baseDate.timeIntervalSince1970 < 0 {
                toDelete.append(url)
                continue
            }
            
            if let fileSize = resourceValues.totalFileAllocatedSize {
                totalSize += Int(fileSize)
                resources.append( (url: url, resourceValues: resourceValues) )
            }
        }
        return (filesToDelete: toDelete, resourceObjects: resources, totalItemsSize: totalSize)
    }
    
    ///
    /// Removes objects if storage size exceeds max size.
    /// - Parameters:
    ///     - objects  : Resource objects to remove
    ///     - totalSize: Total size
    ///
    fileprivate func removeResourceObjects(_ objects: [ResourceObject], currentSize: Int) throws {
        
        guard diskCapacity > 0 && currentSize > diskCapacity else { return }
        
        var  totalSize = currentSize
        let targetSize = diskCapacity / 2
        
        let sortedFiles = objects.sorted {
            
            guard let time1 = $0.resourceValues.contentModificationDate?.timeIntervalSinceReferenceDate else { return false }
            guard let time2 = $1.resourceValues.contentModificationDate?.timeIntervalSinceReferenceDate else { return false }
            return time1 > time2
        }
        
        clearOverflow: for file in sortedFiles {
            
            try fileManager.removeItem(at: file.url)
            
            if let fileSize = file.resourceValues.totalFileAllocatedSize {
                totalSize -= Int(fileSize)
            }
            
            guard totalSize >= targetSize else { continue }
            break clearOverflow
        }
    }
    
    // MARK: - StorehouseProtocol
    
    @discardableResult
    internal override func entry(forKey key: String) throws -> StorehouseEntry<Item>
    {
        let filePath   = makeFilePath(for: key)
        let data       = try Data(contentsOf: URL(fileURLWithPath: filePath))
        let attributes = try fileManager.attributesOfItem(atPath: filePath)
        let object     = try transformer.fromData(data)
        
        guard let date = attributes[.modificationDate] as? Date else { throw StorehouseError.malformedFileAttributes }
        
        return StorehouseEntry(object: object, expiry: .date(date), filePath: filePath)
    }

    internal override func removeObject(forKey key: String) throws
    {
        let filePath = makeFilePath(for: key)
        try fileManager.removeItem(atPath: filePath)
    }
    
    internal override func setObject(_ object: Item, forKey key: String, expiry: StorehouseExpiry? = nil) throws
    {
        let expiry   = expiry ?? configuration.expiry
        let data     = try transformer.toData(object)
        let filePath = makeFilePath(for: key)
        
        _ = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
        try fileManager.setAttributes([.modificationDate: expiry.date], ofItemAtPath: filePath)
    }
    
    internal override func removeAll() throws
    {
        let fileEnumerator = fileManager.enumerator(at: diskFilesFolderURL, includingPropertiesForKeys: nil)
        
        guard let storageURLs = fileEnumerator?.allObjects as? [URL] else {
            throw Error.fileEnumeratorFailed
        }
        
        var isDirectory = ObjCBool(false)
        try storageURLs.forEach {
            
            guard fileManager.fileExists(atPath: $0.path, isDirectory: &isDirectory) , !isDirectory.boolValue else { return }
            try   fileManager.removeItem(atPath: $0.path)
        }
    }
    
    internal override func removeExpiredObjects() throws
    {
        try removeStoredObjects(since: Date())
    }
    
    internal override func removeStoredObjects(since date: Date) throws
    {
        let resourceKeys: [URLResourceKey] = [
            .isDirectoryKey,
            .contentModificationDateKey,
            .totalFileAllocatedSizeKey
        ]
        
        let fileEnumerator = fileManager.enumerator(
            at: diskFilesFolderURL,
            includingPropertiesForKeys: resourceKeys,
            options: .skipsHiddenFiles,
            errorHandler: nil
        )
        
        guard let urlArray = fileEnumerator?.allObjects as? [URL] else {
            throw Error.fileEnumeratorFailed
        }
        
        let closure = try extractItemsInformation(from: urlArray, comperAgainst: date)
        
        // Remove expired objects
        for url in closure.filesToDelete {
            try fileManager.removeItem(at: url)
        }
        
        // Remove objects if storage size exceeds max size
        try removeResourceObjects(closure.resourceObjects, currentSize: closure.totalItemsSize)
    }
    
    internal override func removeObjectIfExpired(forKey key: String) throws
    {
        let filePath   = makeFilePath(for: key)
     
        let attributes = try fileManager.attributesOfItem(atPath: filePath)
        
        if let expiryDate = attributes[.modificationDate] as? Date, expiryDate.cld_inThePast {
            try fileManager.removeItem(atPath: filePath)
        }
    }
}
