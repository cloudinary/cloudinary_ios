//
//  VideoFeedCollectionController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 31/01/2024.
//

import Foundation
import UIKit

protocol VideoFeedCollectionDelegate {
    func cellClicked(_ index: Int)
}

class VideoFeedCollectionController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var delegate: VideoFeedCollectionDelegate

    init(_ delegate: VideoFeedCollectionDelegate) {
        self.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoFeedCell", for: indexPath) as! VideoFeedCell
        cell.setImage(indexPath.row)
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = false
        cell.contentView.layer.cornerRadius = 4
        cell.contentView.layer.masksToBounds = false
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.cellClicked(indexPath.row)
    }


}
