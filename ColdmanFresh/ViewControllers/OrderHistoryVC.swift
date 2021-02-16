//
//  OrderHistoryVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2020 Prasad Patil. All rights reserved.
//

import UIKit

class OrderHistoryVC: SuperViewController {

    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var history = [OrderDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAllOrders()
    }
    
    func getAllOrders() {
        
        guard ApiManager.checkuser_online() else {
            self.showNoRecordsViewWithLabel(self.tblMenu, message: "No internet connection.")
            return
        }
        
        let defaults = UserDefaults.standard
        guard let userData = defaults.object(forKey: "User") as? Data else {
            self.showNoRecordsViewWithLabel(self.tblMenu, message: "Login to order food.")
            return
        }
        
        guard let user = try? PropertyListDecoder().decode(UserProfile.self, from: userData), user.id != 0 else {
            self.showNoRecordsViewWithLabel(self.tblMenu, message: "Login to order food.")
            return
        }
        self.showActivityIndicator()
        
        ApiManager.getAllOrders(userid: user.user_id) { (json) in
            self.hideActivityIndicator()
            
            if let array = json?.array {
                self.history = OrderDetails.getAllOrders(array: array)
                self.tblMenu.reloadData()
            }else {
                self.showNoRecordsViewWithLabel(self.tblMenu, message: "No orders found.")
                self.tblMenu.reloadData()
                //                self.showError(message: "Order placing failed, please try again")
            }
            self.tblMenu.reloadData()
        }
        
    }


}

extension OrderHistoryVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.history.count == 0 {
            if self.activityIndicator != nil && !self.activityIndicator.isAnimating {
                self.showNoRecordsViewWithLabel(self.tblMenu, message: "No orders found.")
            }
        }else {
            tableView.backgroundView = nil
        }
        return self.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let order = self.history[indexPath.row]
        cell.lblTitle.text = "Token ID: \(order.order_id)"
        cell.lblDeliveryTime.text = order.transaction_date
        
        let items = "Items count: \(order.menus.count) "
                
        cell.lblMenuCount.text = items
        cell.lblOrderValue.text = " ₹ \(String(format: "%.2f", order.totalall.toDouble() ?? 0.00)) "
        cell.lblGate.text = "  \(order.gate) "
        cell.lblTimeSlot.text = "  \(order.timeslot) "
        cell.lblPickupTime.text = "  \(order.pickup_date) "

        cell.lblFoodType.text = "  \(order.order_status) "
        if order.order_status == "Cancelled" {
            cell.lblFoodType.backgroundColor = Constants.AppColors.bgRed
        }else if order.order_status.lowercased().contains("picked") || order.order_status.lowercased().contains("deliver")  {
            cell.lblFoodType.backgroundColor = Constants.AppColors.bgGreen
        }else {
            cell.lblFoodType.backgroundColor = UIColor.darkGray
        }
        
        cell.btnViewMore.tag = indexPath.row
        cell.btnViewMore.addTarget(self, action: #selector(viewMoreTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    @objc func viewMoreTapped(_ sender: UIButton) {
        
        let order = self.history[sender.tag]
        let ordervc = mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        ordervc.orderDetails = order
        self.navigationController?.pushViewController(ordervc, animated: true)

    }

    func showNoRecordsView(_ tableView: UITableView) {
        let v1 = UIView(frame: tableView.frame)
        let noDataIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        noDataIV.contentMode = .scaleAspectFit
        noDataIV.center = v1.center
        noDataIV.image = UIImage(named: "nofood")
        v1.addSubview(noDataIV)
        tableView.backgroundView  = v1
    }
    
}
