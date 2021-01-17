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
    
//    var history = [OrderDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAllOrders()
    }
    
    func getOrderHistory() {
        
       /* guard ApiManager.checkuser_online() else {
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
        
        ApiManager.getUserOrders(id: user.id) { (json, b, error) in
            self.hideActivityIndicator()
            
            if b, let array = json?.array {
                self.history = OrderDetails.getAllOrders(array: array)
                self.tblMenu.reloadData()
            }else {
                self.showNoRecordsViewWithLabel(self.tblMenu, message: "No orders found.")
                self.tblMenu.reloadData()
//                self.showError(message: "Order placing failed, please try again")
            }
            self.tblMenu.reloadData()
        }
        */
    }

    func getAllOrders() {
        /*
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
        
        ApiManager.getAllOrders(userid: user.user_id) { (json, b, error) in
            self.hideActivityIndicator()
            
            if b, let dict = json?.dictionary {
                if dict["status"]?.number == 200 {
                    if let array = dict["data"]?.array {
                        self.history = OrderDetails.getAllOrders(array: array)
                        self.tblMenu.reloadData()
                    }else {
                        self.showNoRecordsViewWithLabel(self.tblMenu, message: "No orders found.")
                        self.tblMenu.reloadData()
                        //                self.showError(message: "Order placing failed, please try again")
                    }
                }
            }
            self.tblMenu.reloadData()
        }
        */
    }


}

extension OrderHistoryVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.history.count == 0 {
//            if self.activityIndicator != nil && !self.activityIndicator.isAnimating {
                self.showNoRecordsViewWithLabel(self.tblMenu, message: "No orders found.")
//            }
//        }else {
//            tableView.backgroundView = nil
//        }
        return 0//self.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) //as! CartCell
        
        /*let order = self.history[indexPath.row]
//        if let res = order.restaurant {
//            cell.lblMenuName.text = res.name
//            if let urlstr = (Constants.baseDownloadURL + res.fileName).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlstr) {
//                cell.ivMenu.sd_setImage(with: url)
//            }
//        }
        cell.lblMenuName.text = order.restaurant_name
        cell.lblDate.text = order.transaction_date
        if let urlstr = order.restaurant_logo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlstr) {
            cell.ivMenu.sd_setImage(with: url)
        }
        cell.lblMenuCount.text = "Items - \(order.menus.count)"
        cell.lblPrice.text = "₹ \(String(format: "%.2f", order.totalall.toDouble() ?? 0.00))"
         */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = 80
//        let order = self.history[indexPath.row]
//        height += order.restaurant_name.heightWithConstrainedWidth(ScreenSize.SCREEN_WIDTH - 220, font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold))
        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        let order = self.history[indexPath.row]
//        let ordervc = mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
//        ordervc.orderDetails = order
//        self.navigationController?.pushViewController(ordervc, animated: true)

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
