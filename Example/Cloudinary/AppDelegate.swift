//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 27/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import UIKit
import CoreData
import Cloudinary
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var handler: (() -> Swift.Void)?

    open var cloudinary: CLDCloudinary!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        CLDCloudinary.logLevel = CLDLogLevel.debug
        initCloudinary()
        return true
    }

    func initCloudinary() {
        // init cloudinary if there's a cloud name present (Otherwise the first load will require the user to type in his cloud name).
        if let cloudName = UserDefaults.standard.object(forKey: "cloud_name") {
            cloudinary = CLDCloudinary(configuration: CLDConfiguration(options: ["cloud_name": cloudName as AnyObject])!)
        }
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CldModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    func clearAllResources() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "CLDResource"))
        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

