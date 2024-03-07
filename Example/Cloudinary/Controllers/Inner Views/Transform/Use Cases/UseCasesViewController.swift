//
//  UseCasesViewController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 21/02/2024.
//

import Foundation
import UIKit

class UseCasesViewController: UIViewController {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var cvMain: UICollectionView!

    var innerIndex: Int = 0

    var currentController: UIViewController!

    var collectionController: UseCasesCollectionController!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCollectionView()
        setContainerView(innerIndexToType(innerIndex))
        EventsHandler.shared.logEvent(event: EventObject(name: "Use Cases"))
    }

    private func innerIndexToType(_ index: Int) -> UseCaseContainerType {
        switch index {
        case 0:
            return .NormalizingProductAssets
        case 1:
            return .ConditionalProduct
        case 2:
            return .AdaptVideo
        case 3:
            return .IntegrateAI
        default:
            return .NormalizingProductAssets
        }
    }

    private func setCollectionView() {
        collectionController = UseCasesCollectionController(self)
        cvMain.delegate = collectionController
        cvMain.dataSource = collectionController

        let flow = cvMain.collectionViewLayout as! UICollectionViewFlowLayout

            let itemSpacing: CGFloat = 10
            let itemsInOneLine: CGFloat = 10
            flow.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 0, right: 16)
            let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1)
            flow.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
            flow.minimumInteritemSpacing = 10
            flow.minimumLineSpacing = itemSpacing
    }

    private func setContainerView(_ type: UseCaseContainerType) {
        removeCurrentController()
        switch type {
        case .NormalizingProductAssets:
            currentController = UIStoryboard(name: "NormalizingProductAssets", bundle: nil).instantiateViewController(identifier: "NormalizingProductAssetsViewController")
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            collectionController.selectedCellIndex = 0
        case .ConditionalProduct:
            currentController = UIStoryboard(name: "ConditionalProduct", bundle: nil).instantiateViewController(identifier: "ConditionalProductViewController")
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            collectionController.selectedCellIndex = 1
            break
        case .AdaptVideo:
            currentController = UIStoryboard(name: "IntegrateAI", bundle: nil).instantiateViewController(identifier: "IntegrateAIViewController")
            (currentController as! IntegrateAIViewController).videoPublicId = "DevApp_Adapt_Video_02_diett8"
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            collectionController.selectedCellIndex = 2
        case .IntegrateAI:
            currentController = UIStoryboard(name: "IntegrateAI", bundle: nil).instantiateViewController(identifier: "IntegrateAIViewController")
            (currentController as! IntegrateAIViewController).videoPublicId = "DevApp_Generative_Fill_01_fneqxw"
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            collectionController.selectedCellIndex = 3
        }
    }

    private func removeCurrentController() {
        currentController?.willMove(toParent: nil)
        currentController?.view.removeFromSuperview()
        currentController?.removeFromParent()
    }
}
extension UseCasesViewController: UseCasesCollectionDelegate {
    func cellSelected(_ index: Int) {
        switch index {
        case 0:
            setContainerView(.NormalizingProductAssets)
        case 1:
            setContainerView(.ConditionalProduct)
        case 2:
            setContainerView(.AdaptVideo)
        case 3:
            setContainerView(.IntegrateAI)
        default:
            break
        }
    }
}

enum UseCaseContainerType {
    case NormalizingProductAssets
    case ConditionalProduct
    case AdaptVideo
    case IntegrateAI

}
