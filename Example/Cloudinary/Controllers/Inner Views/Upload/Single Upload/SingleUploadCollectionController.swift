//
//  SingleUploadCollectionController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 12/05/2024.
//

import Foundation
import UIKit
import Cloudinary

protocol SingleUploadCollectionDelegate {
    func presentController(_ controller: UIViewController)
}

class SingleUploadCollectionController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var delegate: SingleUploadCollectionDelegate

    var data: [AssetItems]
    let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryHelper.shared.getUploadCloud()!, secure: true))
    weak var collectionView: UICollectionView? // Weak reference to collection view

    init(delegate: SingleUploadCollectionDelegate, collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.data = CoreDataHelper.shared.fetchData() ?? []
        self.delegate = delegate
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadCell", for: indexPath) as! SingleUploadCell
        cell.setImage(data[indexPath.row].url, cloudinary)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "SingleUploadPreview", bundle: nil).instantiateViewController(withIdentifier: "SingleUploadPreview") as! SingleUploadPreview
        controller.url = data[indexPath.row].url
        delegate.presentController(controller)
    }

    func refreshData() {
        let newData = CoreDataHelper.shared.fetchData() ?? []
        let oldData = data
        data = newData // Update data

        // Compute changes
        var insertions: [IndexPath] = []
        var deletions: [IndexPath] = []
        var moves: [(from: IndexPath, to: IndexPath)] = []

        // Find insertions and deletions
        for (index, newItem) in newData.enumerated() {
            if let oldIndex = oldData.firstIndex(where: { $0.id == newItem.id }) {
                if index != oldIndex {
                    moves.append((from: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: index, section: 0)))
                }
            } else {
                insertions.append(IndexPath(item: index, section: 0))
            }
        }

        for (index, oldItem) in oldData.enumerated() {
            if !newData.contains(where: { $0.id == oldItem.id }) {
                deletions.append(IndexPath(item: index, section: 0))
            }
        }

        // Apply changes to collection view
        collectionView?.performBatchUpdates({
            if !insertions.isEmpty {
                collectionView?.insertItems(at: insertions)
            }
            if !deletions.isEmpty {
                collectionView?.deleteItems(at: deletions)
            }
            for move in moves {
                collectionView?.moveItem(at: move.from, to: move.to)
            }
        }, completion: nil)
    }
}
