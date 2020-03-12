//
//  UploadedViewController.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 27/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Cloudinary

class UploadedViewController: BaseCollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!

    override func reloadData() {
        PersistenceHelper.fetch(statuses: [PersistenceHelper.UploadStatus.uploaded]) { fetchedResources in
            self.resources = fetchedResources as! [CLDResource]
            self.collectionView.reloadData()
        }
    }

    override func getCollectionView() -> UICollectionView! {
        return collectionView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextScene = segue.destination as? UploadedResourceDetails {
            if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell) {
                nextScene.setResource(resource: self.resources[indexPath.row])
            }
        }
    }
}

protocol UploadedResourceDetails {
    func setResource(resource: CLDResource)
}

