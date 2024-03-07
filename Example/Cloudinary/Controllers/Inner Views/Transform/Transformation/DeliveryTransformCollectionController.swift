//
//  DeliveryTransformCollectionController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 30/01/2024.
//

import Foundation
import UIKit

protocol DeliveryTransformCollectionDelegate {
    func transformCellSelected(_ index: Int)
}

class DeliveryTransformCollectionController: NSObject,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var delegate: DeliveryTransformCollectionDelegate

    init(_ delegate: DeliveryTransformCollectionDelegate) {
        self.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transfromationCell", for: indexPath) as! TransformationCell
        cell.setCellContent(indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 224, height: 135)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.transformCellSelected(indexPath.row)
    }


}
