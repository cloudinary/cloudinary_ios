//
//  BaseGridViewController.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 29/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class BaseCollectionViewController: UIViewController {

    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    var resources = [CLDResource]()
    let collectionViewColor = UIColor(red: 0.894, green: 0.922, blue: 0.945, alpha: 1.0);

    // MARK: ViewController
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseCollectionViewController.reloadData), name: PersistenceHelper.resouceChangedNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCollectionView().dataSource = self
        getCollectionView().delegate = self
        getCollectionView().backgroundColor = collectionViewColor

        reloadData()
    }

    // NOP methods, concrete implementations in subclasses.
    @objc func reloadData() {
    }

    // NOP methods, concrete implementations in subclasses.
    func getCollectionView() -> UICollectionView! {
        return nil
    }

    // default items per row
    func getItemsPerRow() -> CGFloat {
        return CGFloat(3);
    }

    // default cell type for resource collections
    func getReuseIdentifier() -> String {
        return "ResourceCell"
    }
}

extension UIViewController {
    func getAppDelegate() -> AppDelegate? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate
        }

        return nil
    }
}

extension BaseCollectionViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return resources.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReuseIdentifier(), for: indexPath) as! ResourceCell

        let resource = resources[indexPath.row]
        if (resource.publicId != nil) {
            // remote image, smart fetch from Cloudinary:
            // first set placeholder
            cell.imageView.image = resource.resourceType!.contains("video") ? UIImage(named: "ic_movie_white") : UIImage(named: "ic_cloudinary")

            // configure params for image fetch:
            let resourceType = resource.resourceType == "video" ? CLDUrlResourceType.video : CLDUrlResourceType.image
            let params = CLDResponsiveParams.autoFill().setReloadOnSizeChange(true)
            cell.imageView.cldSetImage(publicId: resource.publicId!, cloudinary: getAppDelegate()!.cloudinary, resourceType: resourceType,
                    responsiveParams: params, transformation: CLDTransformation().setFetchFormat("jpg"))
        } else {
            setLocalImage(imageView: cell.imageView, resource: resource)
        }

        return cell
    }

    internal func setLocalImage(imageView: UIImageView, resource: CLDResource) {
        if let image = Utils.getImage(relativePath: resource.localPath!) {
            imageView.image = image
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
        } else {
            imageView.image = resource.resourceType!.contains("video") ? UIImage(named: "ic_movie_white") : UIImage(named: "ic_cloudinary")
            imageView.contentMode = UIView.ContentMode.center
        }
    }
}

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = getItemsPerRow()
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
