//
//  TransformViewController.swift
//  iOS_Geekle_Conference
//
//  Created by Adi Mizrahi on 12/09/2023.
//

import Foundation
import UIKit
import Cloudinary

class TransformViewController: UIViewController {

    @IBOutlet weak var cvMain: UICollectionView!
    @IBOutlet weak var vwContainer: UIView!

    var currentController: UIViewController!

    var innerIndex: Int = 0

    var collectionController: TransformCollectionController!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCollectionView()
        setContainerView(innerIndexToType(innerIndex))
        EventsHandler.shared.logEvent(event: EventObject(name: "Inner Trasnform"))
    }

    private func innerIndexToType(_ index: Int) -> TransformContainerType {
        switch index {
        case 0:
            return .SmartCropping
        case 1:
            return .TextLayer
        case 2:
            return .BackgroundRemoval
        case 3:
            return .ReColor
        default:
            return .SmartCropping
        }
    }

    private func setContainerView(_ type: TransformContainerType) {
        removeCurrentController()
        switch type {
        case .SmartCropping:
            currentController = UIStoryboard(name: "SmartCropping", bundle: nil).instantiateViewController(identifier: "SmartCroppingController")
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            collectionController.selectedCellIndex = 0
        case .TextLayer:
            currentController = UIStoryboard(name: "RevealImage", bundle: nil).instantiateViewController(identifier: "RevealImageController")
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            (currentController as! RevealImageController).setMainImageView(rightImage: CloudinaryHelper.shared.cloudinary.createUrl().generate("Demo%20app%20content/layers-fashion-2_1_xsfbvm"), leftImage: CloudinaryHelper.shared.cloudinary.createUrl().setTransformation(CLDTransformation()
                .setOverlay("text:Arial_72:NEW%2520COLLECTION").setColor("white").chain()
                .setFlags("layer_apply").setGravity("center")).generate("Demo%20app%20content/layers-fashion-2_1_xsfbvm"))
            collectionController.selectedCellIndex = 1
        case .BackgroundRemoval:
            currentController = UIStoryboard(name: "RevealImage", bundle: nil).instantiateViewController(identifier: "RevealImageController") as! RevealImageController
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            (currentController as! RevealImageController).setMainImageView(rightImage: CloudinaryHelper.shared.cloudinary.createUrl().generate("Demo%20app%20content/bgr-furniture-1_isnptj"), leftImage: CloudinaryHelper.shared.cloudinary.createUrl().setTransformation(CLDTransformation().setEffect("background_removal")).generate("Demo%20app%20content/bgr-furniture-1_isnptj"))
            collectionController.selectedCellIndex = 2
        case .ReColor:
            currentController = UIStoryboard(name: "RevealImage", bundle: nil).instantiateViewController(identifier: "RevealImageController") as! RevealImageController
            currentController.view.frame = vwContainer.bounds
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
            (currentController as! RevealImageController).setMainImageView(rightImage: CloudinaryHelper.shared.cloudinary.createUrl().generate("Demo%20app%20content/recolor-tshirt-5_omapls"), leftImage: CloudinaryHelper.shared.cloudinary.createUrl().setTransformation(CLDTransformation().setEffect("gen_recolor:prompt_t-shirt;to-color_8fbc8f")).generate("Demo%20app%20content/recolor-tshirt-5_omapls"))
            collectionController.selectedCellIndex = 3
        }
    }

    private func setCollectionView() {
        collectionController = TransformCollectionController(self)
        cvMain.delegate = collectionController
        cvMain.dataSource = collectionController

        let flow = cvMain.collectionViewLayout as! UICollectionViewFlowLayout

            let itemSpacing: CGFloat = 10
            let itemsInOneLine: CGFloat = 10
            flow.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
            let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1)
            flow.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
            flow.minimumInteritemSpacing = 10
            flow.minimumLineSpacing = itemSpacing
    }

    private func removeCurrentController() {
        currentController?.willMove(toParent: nil)
        currentController?.view.removeFromSuperview()
        currentController?.removeFromParent()
    }
}
extension TransformViewController: TransformCollectionDelegate {
    func cellSelected(_ index: Int) {
        switch index {
        case 0:
            setContainerView(.SmartCropping)
        case 1:
            setContainerView(.TextLayer)
        case 2:
            setContainerView(.BackgroundRemoval)
        case 3:
            setContainerView(.ReColor)
        default:
            break
        }
    }
}


enum TransformContainerType {
    case SmartCropping
    case TextLayer
    case BackgroundRemoval
    case ReColor
}
