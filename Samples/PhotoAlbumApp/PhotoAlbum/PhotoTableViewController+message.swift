import Foundation
import UIKit
extension PhotoTableViewController {

    func showMessage(_ text: String) {
        message.text = text
        message.isHidden = false

    }

    func hideMessage() {
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.dismissMessage), userInfo: nil, repeats: false)
    }

    @objc fileprivate func dismissMessage(){
        if message != nil { // Dismiss the view from here
            message.text = ""
            message.isHidden = true
        }
    }
}
