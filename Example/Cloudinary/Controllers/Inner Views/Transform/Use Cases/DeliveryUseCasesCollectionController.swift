//
//  DeliveryUseCasesCollectionController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 30/01/2024.
//

import Foundation
import UIKit

protocol DeliverUseCaseCollectionDelegate {
    func useCaseCellSelected(_ index: Int)
}

class DeliveryUseCasesCollectionController: NSObject,  UICollectionViewDelegate, UICollectionViewDataSource {

    var delegate: DeliverUseCaseCollectionDelegate

    init(_ delegate: DeliverUseCaseCollectionDelegate) {
        self.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "useCaseCell", for: indexPath) as! UseCaseCell
        cell.setCellBy(index: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.useCaseCellSelected(indexPath.row)
    }
}
