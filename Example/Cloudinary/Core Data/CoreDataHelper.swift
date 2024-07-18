//
//  CoreDataHelper.swift
//  Cloudinary_Example
//
//  Created by Adi Mizrahi on 18/07/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
class CoreDataHelper {

    static let shared = CoreDataHelper()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AssetModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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

    func insertData(_ item: AssetModel) {
        let context = CoreDataHelper.shared.persistentContainer.viewContext
        let newDelivery = AssetItems(context: context)
        newDelivery.deliveryType = item.getDeliveryType()
        newDelivery.assetType = item.getAssetType()
        newDelivery.transformation = item.getTransformation() ?? ""
        newDelivery.publicId = item.getPublicId()
        newDelivery.url = item.getUrl()

        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    func fetchSingleData(publicId: String) -> AssetModel? {
        let context = CoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<AssetItems> = AssetItems.fetchRequest()

        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                if item.publicId == publicId {
                    return AssetModel(deliveryType: item.deliveryType, assetType: item.assetType, transformation: item.transformation, publicId: item.publicId, url: item.url)
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        return nil
    }

    func fetchData() -> [AssetItems]? {
        let context = CoreDataHelper.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<AssetItems> = AssetItems.fetchRequest()

        do {
            let items = try context.fetch(fetchRequest)
            return items
        } catch {
            print("Error fetching data: \(error)")
        }
        return nil
    }

}
