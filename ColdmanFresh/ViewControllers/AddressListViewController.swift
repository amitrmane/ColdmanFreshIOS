//
//  AddressListViewController.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 27/01/21.
//  Copyright © 2021 Prasad Patil. All rights reserved.
//

import UIKit

class AddressListViewController: SuperViewController {

    @IBOutlet weak var tblAddresses: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    var user: UserProfile!
    var allAddress = [Address]()
    var selectedAddr : Address!
    var delegate : AddressSelectionProtocol!
    var isFromHome = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblAddresses.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserAdresses()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addTapped(_ sender: UIButton) {
        let addVC = mainStoryboard.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        addVC.user = user
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    func getUserAdresses() {
        
        guard ApiManager.checkuser_online() else {
            return
        }
        
        self.showActivityIndicator()
                
        ApiManager.getUserAddresses(userid: user.user_id) { (json) in
            self.hideActivityIndicator()
            
            if let dict = json?.dictionary,
               let array = dict["address"]?.array {
                self.allAddress = Address.getAllAddresses(array: array)
                if self.allAddress.count == 0 {
                    self.showNoRecordsViewWithLabel(self.tblAddresses, message: "No address found, please add new address.")
                }else {
                    self.tblAddresses.backgroundView = nil
                }
                self.tblAddresses.reloadData()
            }else {
                self.showError(message: "Failed, please try again")
            }
        }
        
    }
    

}

extension AddressListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let address = self.allAddress[indexPath.row]
        cell.lblTitle.text = address.title
        let fulladdr = address.address + " \(address.landmark)"
        cell.lblDesc.text = fulladdr
        if isFromHome {
            if let addr = self.selectedAddr, addr.id == address.id {
                cell.accessoryType = .checkmark
            }else if address.primaryAddress == "1" && self.selectedAddr == nil {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
        }else {
            if let addr = self.selectedAddr, addr.id == address.id {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let del = self.delegate {
            del.selectedAddress(addr: self.allAddress[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let address = self.allAddress[indexPath.row]
        let fulladdr = address.address + " \(address.landmark)"
        let height = fulladdr.heightWithConstrainedWidth(ScreenSize.SCREEN_WIDTH - 100, font: .boldSystemFont(ofSize: 13))
        return 70 + height
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let address = self.allAddress[indexPath.row]
            let addVC = mainStoryboard.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
            addVC.user = self.user
            addVC.selectedAddress = address
            self.navigationController?.pushViewController(addVC, animated: true)
        }
        return [action]
    }
}
