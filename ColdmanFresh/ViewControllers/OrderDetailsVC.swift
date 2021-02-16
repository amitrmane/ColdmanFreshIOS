//
//  OrderDetailsVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 15/02/21.
//

import UIKit

class OrderDetailsVC: SuperViewController {

    @IBOutlet weak var lblToken: UILabel!

    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var lblCartTotal: UILabel!
    @IBOutlet weak var lblPromoDiscount: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var viewBaseTax: UIView!

    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var lblAddress: UILabel!

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblGate: UILabel!
    @IBOutlet weak var lblPickupDate: UILabel!
    @IBOutlet weak var lblTimeslot: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    
    @IBOutlet weak var ivPlaced: UIImageView!
    @IBOutlet weak var lblPlaced: UILabel!
    @IBOutlet weak var ivConfirmed: UIImageView!
    @IBOutlet weak var lblConfirmed: UILabel!
    @IBOutlet weak var ivPicked: UIImageView!

    var addedMenus = [Menu]()
    var user : UserProfile!
    var orderDetails : OrderDetails!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prefillData()
        self.getOrderDetails()
    }
    

    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func prefillData() {
        if let order = orderDetails {
            self.lblToken.text = "Token - \(order.order_id)"
            self.lblGate.text = " \(order.gate) "
            self.lblTimeslot.text = " \(order.timeslot) "
            self.lblPickupDate.text = " \(order.pickup_date) "
            self.lblOrderDate.text = "Ordered on: " + order.date_time
            self.lblAddress.text = order.ordered_user_address
            self.lblSubTotal.text = order.cost
            self.lblPromoDiscount.text = order.discount_amount
            if let cost = order.cost.toDouble(), let disc = order.discount_amount.toDouble() {
                self.lblCartTotal.text = "\(cost + disc)"
            }
            self.addedMenus = order.menus
            self.tblMenu.reloadData()
            
            if order.order_status.lowercased().contains("placed") {
                self.ivPlaced.backgroundColor = Constants.AppColors.bgGreen
                self.lblPlaced.backgroundColor = UIColor.darkGray
                self.ivConfirmed.backgroundColor = UIColor.darkGray
                self.lblPlaced.backgroundColor = UIColor.darkGray
                self.ivPicked.backgroundColor = UIColor.darkGray
            }else if order.order_status.lowercased().contains("confirm") {
                self.ivPlaced.backgroundColor = Constants.AppColors.bgGreen
                self.lblPlaced.backgroundColor = Constants.AppColors.bgGreen
                self.ivConfirmed.backgroundColor = Constants.AppColors.bgGreen
                self.lblPlaced.backgroundColor = UIColor.darkGray
                self.ivPicked.backgroundColor = UIColor.darkGray
            }else if order.order_status.lowercased().contains("pick") {
                self.ivPlaced.backgroundColor = Constants.AppColors.bgGreen
                self.lblPlaced.backgroundColor = Constants.AppColors.bgGreen
                self.ivConfirmed.backgroundColor = Constants.AppColors.bgGreen
                self.lblPlaced.backgroundColor = Constants.AppColors.bgGreen
                self.ivPicked.backgroundColor = Constants.AppColors.bgGreen
            }
       }

    }
}

extension OrderDetailsVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.addedMenus.count == 0 {
            self.showNoRecordsView(tableView)
        }else {
            tableView.backgroundView = nil
        }
        return self.addedMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! MenuCell
        
        let menu = self.addedMenus[indexPath.row]
        cell.lblTitle.text = menu.menu_name + " x (\(menu.qty))"
        cell.lblOrderValue.text = "₹ \(menu.menu_price)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func showNoRecordsView(_ tableView: UITableView) {
        let v1 = UIView(frame: tableView.frame)
        let noDataIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        noDataIV.contentMode = .scaleAspectFit
        noDataIV.center = self.viewBaseTax.center
        noDataIV.image = UIImage(named: "no-food")
        v1.addSubview(noDataIV)
        tableView.backgroundView  = v1
        self.viewBaseTax.isHidden = true
    }
    
    func getOrderDetails() {
        
        guard ApiManager.checkuser_online() else {
            self.showNoRecordsViewWithLabel(self.tblMenu, message: "No internet connection.")
            return
        }
        
        self.showActivityIndicator()
        
        ApiManager.getOrderDetails(order_id: self.orderDetails.order_id) { (json) in
            self.hideActivityIndicator()
            
            if let dict = json?.dictionary, let details = dict["order_details"]?.dictionary {
                self.orderDetails = OrderDetails.getOrderDetails(dict: details)
                self.prefillData()
            }else {
                self.showNoRecordsViewWithLabel(self.tblMenu, message: "No orders found.")
                self.tblMenu.reloadData()
                //                self.showError(message: "Order placing failed, please try again")
            }
            self.tblMenu.reloadData()
        }
        
    }

}

