//
//  WelcomeAlertVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/03/21.
//

import UIKit

class WelcomeAlertVC: UIViewController {
    
    @IBOutlet weak var ivInfo : UIImageView!
    @IBOutlet weak var scrollV : UIScrollView!

    var closeCallBack : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollV.minimumZoomScale = 1.0
        self.scrollV.maximumZoomScale = 2.0
    }
    
    @IBAction func dontShowAgainTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            Utilities.addValueForKeyToUserDefauls("isAlertConfirmed", value: 1 as AnyObject)
        }else {
            Utilities.removeValueForKeyFromDefaults("isAlertConfirmed")
        }
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        if let callback = self.closeCallBack {
            callback()
        }
        self.dismiss(animated: true, completion: nil)
    }


}

extension WelcomeAlertVC : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ivInfo
    }
}
