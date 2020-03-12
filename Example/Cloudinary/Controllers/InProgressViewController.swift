//
//  UploadedViewController.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 27/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit

class InProgressViewController: BaseCollectionViewController {
    static let progressChangedNotification = NSNotification.Name(rawValue: "com.cloudinary.sample.progress.notification")

    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var progressMap: [String: Progress] = [:]

    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(InProgressViewController.progressChanged(notification:)), name: InProgressViewController.progressChangedNotification, object: nil)
    }

    override func getReuseIdentifier() -> String {
        return "ResourceInProgressCell"
    }

    override func getItemsPerRow() -> CGFloat {
        return CGFloat(2);
    }

    override func getCollectionView() -> UICollectionView! {
        return collectionView
    }

    override func reloadData() {
        PersistenceHelper.fetch(statuses: [PersistenceHelper.UploadStatus.queued, PersistenceHelper.UploadStatus.uploading]) { fetchedResources in
            var oldResources = Set(self.resources)
            self.resources = fetchedResources as! [CLDResource]
            self.collectionView.reloadData()

            let newResources = Set(self.resources)

            oldResources.subtract(newResources)

            // if something was here before and it's gone now, clean it up from the progress map as well
            for res in oldResources {
                self.progressMap.removeValue(forKey: res.localPath!)
            }
        }
    }

    @objc func progressChanged(notification: NSNotification) {
        // update progress in map
        let name = notification.userInfo?["name"] as? String
        let progress = notification.userInfo?["progress"] as? Progress

        if (name != nil && progress != nil) {
            progressMap[name!] = progress!
        }

        // refresh views
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReuseIdentifier(), for: indexPath) as! ResourceInProgressCell
        let resource = resources[indexPath.row]
        setLocalImage(imageView: cell.imageView, resource: resource)
        cell.overlayView.isHidden = true
        if let progress = progressMap[resource.localPath!] {
            cell.overlayView.isHidden = false
            cell.progressView.isHidden = false
            cell.progressView.progress = Float(progress.fractionCompleted)
        } else {
            cell.overlayView.isHidden = true
            cell.progressView.isHidden = true
        }

        return cell
    }
}
