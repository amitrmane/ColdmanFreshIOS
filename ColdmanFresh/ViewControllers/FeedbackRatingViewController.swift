//
//  FeedbackRatingViewController.swift
//  ColdmanFresh
//
//  Created by Amit R Mane on 6/21/21.
//

import UIKit

class FeedbackRatingViewController: SuperViewController, FloatRatingViewDelegate {
    
    @IBOutlet weak var floatRatingView1: FloatRatingView!
    @IBOutlet weak var floatRatingView2: FloatRatingView!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var floatRatingView4: FloatRatingView!
    @IBOutlet weak var floatRatingView3: FloatRatingView!
    @IBOutlet weak var floatRatingView21: FloatRatingView!
    @IBOutlet weak var floatRatingView22: FloatRatingView!
    @IBOutlet weak var floatRatingView20: FloatRatingView!
    @IBOutlet weak var floatRatingView24: FloatRatingView!
    @IBOutlet weak var floatRatingView23: FloatRatingView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var params = [String: Any]()
        if let user = Utilities.getCurrentUser() {
        params["user_id"] = "\(user.id)"
        }
        
        self.showActivityIndicator()
        
        ApiManager.feedackView(params: params) { [self] (json) in
            self.hideActivityIndicator()
                if let dict = json?.dictionary, let status = dict["status"]?.number, (status == 200) {
                    if let address = dict["average_rating"]?.dictionary {
                        if let value = address["app_user_interface_rating"]?.string {
                            floatRatingView.rating = value.toDouble()!
                        }
                        if let value = address["product_quality_rating"]?.string {
                            floatRatingView1.rating = value.toDouble()!
                        }
                        if let value = address["packing_quality_rating"]?.string {
                            floatRatingView2.rating = value.toDouble()!
                        }
                        if let value = address["delivery_condition_rating"]?.string {
                            floatRatingView3.rating = value.toDouble()!
                        }
                        if let value = address["delivery_boy_rating"]?.string {
                            floatRatingView4.rating = value.toDouble()!
                        }
                    }
                    if let address = dict["user_rating"]?.dictionary {
                        if let value = address["app_user_interface_rating"]?.string {
                            floatRatingView20.rating = value.toDouble()!
                        }
                        if let value = address["product_quality_rating"]?.string {
                            floatRatingView21.rating = value.toDouble()!
                        }
                        if let value = address["packing_quality_rating"]?.string {
                            floatRatingView22.rating = value.toDouble()!
                        }
                        if let value = address["delivery_condition_rating"]?.string {
                            floatRatingView23.rating = value.toDouble()!
                        }
                        if let value = address["delivery_boy_rating"]?.string {
                            floatRatingView24.rating = value.toDouble()!
                        }
                    }
                }else if let dict = json?.dictionary, let message = dict["message"]?.string {
                    self.showAlert(message)
                }
        }
    }
    
    @IBAction func SkipView(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true);
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
