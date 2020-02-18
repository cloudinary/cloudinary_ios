//
//  UploadedViewController.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 27/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit

class ErrorsViewController: BaseCollectionViewController {
    // MARK: Properties
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    @IBOutlet weak var collectionView: UICollectionView!

    override func getReuseIdentifier() -> String {
        return "ResourceErrorCell"
    }

    override func getItemsPerRow() -> CGFloat {
        return CGFloat(1);
    }

    override func reloadData() {
        PersistenceHelper.fetch(statuses: [PersistenceHelper.UploadStatus.failed, PersistenceHelper.UploadStatus.rescheduled]) { fetchedResources in
            self.resources = fetchedResources as! [CLDResource]
            self.collectionView.reloadData()
        }
    }

    override func getCollectionView() -> UICollectionView! {
        return collectionView
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReuseIdentifier(), for: indexPath) as! ResourceErrorCell
        let resource = resources[indexPath.row]

        setLocalImage(imageView: cell.imageView, resource: resource)

        cell.name.text = resource.localPath
        cell.name.adjustsFontSizeToFitWidth = false;
        cell.name.lineBreakMode = .byTruncatingTail

        cell.errorDescription.text = resource.lastErrorText

        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = getItemsPerRow()
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: 200)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}
