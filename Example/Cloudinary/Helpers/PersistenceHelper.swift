//
//  PersistenceHelper.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 28/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PersistenceHelper {
    static let resouceChangedNotification = NSNotification.Name(rawValue: "com.cloudinary.sample.persistence.notification")

    static func addResource(localUri uri: String, type: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        fetch(byLocalId: uri) { result in
            let newResource: CLDResource

            if (result != nil && (result?.count)! > 0) {
                newResource = result![0] as! CLDResource
            } else {
                newResource = NSEntityDescription.insertNewObject(forEntityName: "CLDResource", into: managedContext) as! CLDResource
                newResource.localPath = uri
            }

            newResource.status = UploadStatus.queued.rawValue
            newResource.statusTimestamp = Date()
            newResource.lastErrorCode = 0
            newResource.lastErrorText = nil
            newResource.deleteToken = nil
            newResource.publicId = nil
            newResource.resourceType = type

            saveAndNotify()
        }
    }

    static func clearAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        appDelegate.clearAllResources()

        saveAndNotify()
    }

    static func resourceUploaded(localPath: String, publicId: String) {
        fetch(byLocalId: localPath) { result in
            let resources = result as? [CLDResource]
            if let resource = resources?[0] {
                resource.publicId = publicId
                resource.status = UploadStatus.uploaded.rawValue
                resource.statusTimestamp = Date()
                resource.lastErrorCode = 0
                resource.lastErrorText = nil

                saveAndNotify()
            }
        }
    }

    fileprivate static func saveAndNotify() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        appDelegate.saveContext()
        NotificationCenter.default.post(name: resouceChangedNotification, object: nil)
    }

    static func resourceError(localPath: String, code: Int, description: String?) {
        fetch(byLocalId: localPath) { result in
            let resources = result as? [CLDResource]
            if let resource = resources?[0] {
                resource.publicId = nil
                resource.status = UploadStatus.failed.rawValue
                resource.statusTimestamp = Date()
                resource.lastErrorCode = Int16(code)
                resource.lastErrorText = description

                saveAndNotify()
            }
        }
    }

    static func fetch(byLocalId localPath: String, completionHandler: @escaping ([NSManagedObject]?) -> ()) {
        fetch(predicate: NSPredicate(format: "localPath = %@", localPath), completionHandler: completionHandler)
    }

    static func fetch(statuses: [UploadStatus], completionHandler: @escaping ([NSManagedObject]?) -> ()) {
        fetch(predicate: NSPredicate(format: "status IN %@", statuses.map {
            $0.rawValue
        }), completionHandler: completionHandler)
    }

    static func fetch(predicate: NSPredicate, completionHandler: @escaping ([NSManagedObject]?) -> ()) {
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Failed to retrieve app delegate")
            }

            let managedContext = appDelegate.persistentContainer.viewContext

            let resourcesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CLDResource")
            resourcesFetch.predicate = predicate

            DispatchQueue.global().async {
                do {
                    let result = try managedContext.fetch(resourcesFetch) as! [CLDResource]
                    DispatchQueue.main.async {
                        completionHandler(result)
                    }
                } catch {
                    fatalError("Failed to fetch resources: \(error)")
                }
            }
        }
        
    }

    enum UploadStatus: String {
        case queued, uploading, uploaded, rescheduled, failed
    }
}
