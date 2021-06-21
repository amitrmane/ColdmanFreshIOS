//
//  Feedback.swift
//  ColdmanFresh
//
//  Created by Amit R Mane on 6/12/21.
//

import UIKit

class Feedback: SuperViewController, FloatRatingViewDelegate {

    @IBOutlet weak var floatRatingView1: FloatRatingView!
    @IBOutlet weak var floatRatingView2: FloatRatingView!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var floatRatingView4: FloatRatingView!
    @IBOutlet weak var floatRatingView3: FloatRatingView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        submitButton.layer.cornerRadius = 5
//        submitButton.layer.borderWidth = 1
//        submitButton.layer.borderColor = UIColor.blue.cgColor
//        skipButton.layer.cornerRadius = 5
//        skipButton.layer.borderWidth = 1
//        skipButton.layer.borderColor = UIColor.blue.cgColor
        
        // Do any additional setup after loading the view.
        floatRatingView.backgroundColor = UIColor.clear
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings
        
        floatRatingView1.backgroundColor = UIColor.clear
        floatRatingView1.delegate = self
        floatRatingView1.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView1.type = .wholeRatings
        
        floatRatingView2.backgroundColor = UIColor.clear
        floatRatingView2.delegate = self
        floatRatingView2.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView2.type = .wholeRatings
        
        floatRatingView3.backgroundColor = UIColor.clear
        floatRatingView3.delegate = self
        floatRatingView3.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView3.type = .wholeRatings
        
        floatRatingView4.backgroundColor = UIColor.clear
        floatRatingView4.delegate = self
        floatRatingView4.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView4.type = .wholeRatings
        }
    
    @IBAction func SkipView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func SubmitView(_ sender: Any) {
        
        var params = [String: Any]()
        if let user = Utilities.getCurrentUser() {
        params["user_id"] = "\(user.id)"
        params["app_user_interface_rating"] = self.floatRatingView.rating
        params["product_quality_rating"] = self.floatRatingView1.rating
        params["packing_quality_rating"] = self.floatRatingView2.rating
        params["delivery_condition_rating"] = self.floatRatingView3.rating
        params["delivery_boy_rating"] = self.floatRatingView4.rating
        }
        
        self.showActivityIndicator()
        
        ApiManager.feedackAdd(params: params) { (json) in
            self.hideActivityIndicator()
                if let dict = json?.dictionary, let status = dict["status"]?.number, (status == 200) {
                    self.ShowAlertOrActionSheet(preferredStyle: .alert, title: AlertMessages.ALERT_TITLE, message: "Feedback added successfully", buttons: ["OK"]) { (i) in
                        if i == 0 {
                            let addressvc = mainStoryboard.instantiateViewController(withIdentifier: "FeedbackRatingViewController") as! FeedbackRatingViewController
                            self.navigationController?.pushViewController(addressvc, animated: true)
                        }
                    }
                }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                    self.showAlert(message)
                }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}

//extension Feedback: FloatRatingViewDelegate {
//
//    // MARK: FloatRatingViewDelegate
//    
//    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//            print(String(format: "%.2f", self.floatRatingView.rating))
//        //        liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
//    }
//    
//    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
//        print(String(format: "%.2f", self.floatRatingView.rating))
//
////        updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
//    }
//}
