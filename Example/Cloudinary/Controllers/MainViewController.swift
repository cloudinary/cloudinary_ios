//
//  ViewController.swift
//  iOS_Geekle_Conference
//
//  Created by Adi Mizrahi on 11/09/2023.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var vwToolbar: UIView!
    @IBOutlet weak var vwContainer: UIView!

    var selectedOption: ToolbarOptions = .Delivery

    var currentViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
        setContainerView(option: .Delivery)
    }

    private func setToolbar() {
        let bottomToolbar = Toolbar(frame: vwToolbar.bounds, delegate: self)
        vwToolbar.addSubview(bottomToolbar)
    }

    private func setContainerView(option: ToolbarOptions) {
        var controller: UIViewController?
        switch option {
        case .Delivery:
            controller = UIStoryboard(name: "Delivery", bundle: nil).instantiateViewController(identifier: "DeliveryViewController")
            break
        case .Upload:
            controller = UIStoryboard(name: "Upload", bundle: nil).instantiateViewController(identifier: "UploadViewController")
            break
        case .Widgets:
            controller = UIStoryboard(name: "Widgets", bundle: nil).instantiateViewController(identifier: "WidgetsViewController")
            break
        case .Video:
            controller = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(identifier: "VideoViewController")
            break
        }
        guard let newController = controller else {
            return
        }
        addChild(newController)
        AnimationHelper.animateTabController(vwContainer, newController, currentViewController: currentViewController, completion: {
            self.currentViewController?.removeFromParent()

            self.currentViewController = newController
            newController.didMove(toParent: self)
        })
    }
}

    extension MainViewController: ToolbarDelegate {
        func deliverySelected() {
            if(selectedOption != .Delivery) {
                selectedOption = .Delivery
                setContainerView(option: .Delivery)
            }
        }

        func uploadSelected() {
            if(selectedOption != .Upload) {
                selectedOption = .Upload
                setContainerView(option: .Upload)
            }
        }

        func widgetsSelected() {
            if(selectedOption != .Widgets) {
                selectedOption = .Widgets
                setContainerView(option: .Widgets)
            }
        }

        func videoSelected() {
            if(selectedOption != .Video) {
                selectedOption = .Video
                setContainerView(option: .Video)
            }
        }
    }

