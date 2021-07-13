//
//  ProductListVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 21/01/21.
//

import UIKit

class ProductListVC: SuperViewController {

    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCart: BadgeButton!
    @IBOutlet weak var searchBar: UISearchBar!

    var allMenus = [Menu]()
    var menus = [Menu]()
    var categories = [Categories]()
    var subCategories = [SubCategories]()
    var addedMenus = [Menu]()
    var selectedCategory : Categories!
    var backDelegate : BackRefresh!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblMenu.tableFooterView = UIView(frame: CGRect.zero)
        if let cat = self.selectedCategory {
            self.lblCategoryTitle.text = cat.category_name
            self.refreshData(firstLoad: true)
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        if let del = self.backDelegate {
            del.updateData(self.addedMenus)
        }
        if self.addedMenus.count > 0 {
            Menu.saveCartItems(self.addedMenus)
        }else {
            Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartTapped(_ sender: UIButton) {
        let addedMenus = Menu.getSavedCartItems()
        if addedMenus.count > 0 {
            
            if let user = Utilities.getCurrentUser() {
                let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
                cartvc.addedMenus = addedMenus
                cartvc.backDelegate = self
                cartvc.user = user
                //            cartvc.currentAddress = self.currentAddress == nil ? self.currentLocation : self.currentAddress
                self.navigationController?.pushViewController(cartvc, animated: true)
                
            }else {
                let loginvc = mainStoryboard.instantiateViewController(withIdentifier: "PhoneVerificationVC") as! PhoneVerificationVC
                loginvc.addedMenus = self.addedMenus
                loginvc.isCartTap = true
                //        loginvc.delegate = self
                self.navigationController?.pushViewController(loginvc, animated: true)
            }
        }else {
            self.showAlert("No items in cart, please select category and add items.")
        }

    }


}

extension ProductListVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.subCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sub = self.subCategories[section]
        if !sub.isExpanded {
            return 0
        }
        return self.menus.filter({ $0.menu_categoryid == sub.id }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let sub = self.subCategories[indexPath.section]

        let filtered = self.menus.filter({ $0.menu_categoryid == sub.id })
        
        let m = filtered[indexPath.row]
        
        cell.lblTitle.text = m.menu_displayname
        
        if let url = URL(string: m.menu_logo) {
            cell.ivMenu.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground, completed: nil)
        }
        
        cell.lblStarRating.text = " ₹ " + "\(m.menu_price)" + " "
        cell.lblMenuCount.text = "\(m.menuCount)"
        
        if m.menu_status == "Available" {
            cell.lblDeliveryTime.text = " \(m.menu_status) "
            cell.lblDeliveryTime.backgroundColor = Constants.AppColors.bgGreen
            if m.addedToCart {
                cell.btnAdd.isHidden = true
                cell.viewBaseCounter.isHidden = false
            }else {
                cell.btnAdd.isHidden = false
                cell.viewBaseCounter.isHidden = true
            }
        }else {
            cell.lblDeliveryTime.text = " \(m.menu_status) "
            cell.lblDeliveryTime.backgroundColor = Constants.AppColors.bgRed
            cell.btnAdd.isHidden = true
            cell.viewBaseCounter.isHidden = true
        }
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.imageView!.tag = indexPath.section
        cell.btnAdd.addTarget(self, action: #selector(addToCartTapped(_:)), for: .touchUpInside)
        
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.imageView!.tag = indexPath.section
        cell.btnPlus.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.imageView!.tag = indexPath.section
        cell.btnMinus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        
        let sub = self.subCategories[section]
        let filtered = self.menus.filter({ $0.menu_categoryid == sub.id })

        let label = UILabel(frame: CGRect(x: 23, y: 0, width: frame.width - 43, height: frame.height))
        label.backgroundColor = Constants.AppColors.bgGreen.withAlphaComponent(0.1)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: Constants.APP_BOLD_FONT, size: 17)
        label.text =  " " + sub.category_olname + " (\(filtered.count))"
        
        let line = UILabel(frame: CGRect(x: 23, y: 39, width: frame.width - 43, height: 1))
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)

        let arrow = Arrow(origin: CGPoint(x: frame.width - 40, y: 12), size: 15)
        arrow.backgroundColor = .clear
        arrow.tintColor = .black
        if sub.isExpanded {
            arrow.position = .up
        }else {
            arrow.position = .down
        }
        
        let button = UIButton(frame: frame)
        button.backgroundColor = .clear
        button.tag = section
        button.addTarget(self, action: #selector(headerTapped(_:)), for: .touchUpInside)
        
        headerView.addSubview(label)
        headerView.addSubview(arrow)
        headerView.addSubview(line)
        headerView.addSubview(button)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    @objc func headerTapped(_ sender: UIButton) {
        let sub = self.subCategories[sender.tag]
        sub.isExpanded = !sub.isExpanded
        self.tblMenu.reloadData()
    }
    
    @objc func addToCartTapped(_ sender: UIButton) {
        let sub = self.subCategories[sender.imageView!.tag]

        let filtered = self.menus.filter({ $0.menu_categoryid == sub.id })

        let menu = filtered[sender.tag]
        
        let variations = menu.variation.filter({ $0.variation_status == "active" })
        
        if variations.count > 0 {
            
            let variationvc = mainStoryboard.instantiateViewController(withIdentifier: "VariationPopupVC") as! VariationPopupVC
            variationvc.selectedMenu = menu
            variationvc.variations = variations
            variationvc.selectedVariation = { (vr) in
                
                menu.addedToCart = !menu.addedToCart
                menu.selectedVariation = vr
                if menu.addedToCart {
                    menu.menuCount = 1
                    if let vari = vr, let rate = vari.rate.toDouble() {
                        menu.displayPrice = rate * Double(menu.menuCount)
                    }else {
                        menu.displayPrice = menu.price * Double(menu.menuCount)
                    }
                    self.addedMenus.append(menu)
                }
                if self.addedMenus.count > 0 {
                    Menu.saveCartItems(self.addedMenus)
                }else {
                    Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
                }
                self.refreshData()
            }
            self.navigationController?.present(variationvc, animated: false, completion: nil)
        }else {
            menu.addedToCart = !menu.addedToCart
            if menu.addedToCart {
                menu.menuCount = 1
                menu.displayPrice = menu.price * Double(menu.menuCount)
                self.addedMenus.append(menu)
            }
            if self.addedMenus.count > 0 {
                Menu.saveCartItems(self.addedMenus)
            }else {
                Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
            }
            self.refreshData()

        }
       
    }
    
    @objc func plusTapped(_ sender: UIButton) {
        let sub = self.subCategories[sender.imageView!.tag]

        let filtered = self.menus.filter({ $0.menu_categoryid == sub.id })

        let menu = filtered[sender.tag]
        menu.menuCount += 1
        if let vari = menu.selectedVariation, let rate = vari.rate.toDouble() {
            menu.displayPrice = rate * Double(menu.menuCount)
        }else {
            menu.displayPrice = menu.price * Double(menu.menuCount)
        }
        for m in self.addedMenus {
            if m.menu_id == menu.menu_id {
                m.displayPrice = menu.displayPrice
                m.menuCount = menu.menuCount
            }
        }
        if self.addedMenus.count > 0 {
            Menu.saveCartItems(self.addedMenus)
        }else {
            Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
        }
        refreshData()
    }

    @objc func minusTapped(_ sender: UIButton) {
        let sub = self.subCategories[sender.imageView!.tag]

        let filtered = self.menus.filter({ $0.menu_categoryid == sub.id })
        let menu = filtered[sender.tag]
        if menu.menuCount == 1 && menu.addedToCart {
            var idx : Int!
            for (i, m) in self.addedMenus.enumerated() {
                if m.menu_id == menu.menu_id {
                    idx = i
                }
            }
            if let i = idx {
                menu.addedToCart = false
                self.addedMenus.remove(at: i)
            }
        }
        menu.menuCount -= menu.menuCount > 1 ? 1 : 0
        if let vari = menu.selectedVariation, let rate = vari.rate.toDouble() {
            menu.displayPrice = rate * Double(menu.menuCount)
        }else {
            menu.displayPrice = menu.price * Double(menu.menuCount)
        }
        for m in self.addedMenus {
            if m.menu_id == menu.menu_id {
                m.displayPrice = menu.displayPrice
                m.menuCount = menu.menuCount
            }
        }
        if self.addedMenus.count > 0 {
            Menu.saveCartItems(self.addedMenus)
        }else {
            Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
        }
        refreshData()
    }

    func refreshData(firstLoad: Bool = false) {
        if firstLoad {
            self.addedMenus = Menu.getSavedCartItems()
            for m in self.menus {
                if let menu = self.addedMenus.filter({ $0.menu_id == m.menu_id }).first {
                    m.addedToCart = menu.addedToCart
                    m.displayPrice = menu.displayPrice
                    m.menuCount = menu.menuCount
                }
            }
            if self.addedMenus.count > 0 {
                Menu.saveCartItems(self.addedMenus)
            }else {
                Utilities.removeValueForKeyFromDefaults(Constants.Keys.cart)
            }
        }
        if self.addedMenus.count == 0 {
            self.menus.forEach { (m) in
                m.menuCount = 0
                m.displayPrice = m.price
                m.addedToCart = false
            }
            self.btnCart.badge = nil
        }else {
            self.btnCart.badge = "\(self.addedMenus.count)"
//            let val = self.addedMenus.map { $0.displayPrice }

        }
        self.tblMenu.reloadData()
    }
    
    func reloadOnSearch(searchText: String) {
        if searchText != "" {
            self.menus = self.allMenus.filter({ (m) -> Bool in
                return m.menu_displayname.lowercased().hasPrefix(searchText.lowercased())
            })
        }else {
            self.menus = self.allMenus
        }
        self.tblMenu.reloadData()
    }

}

extension ProductListVC : BackRefresh, UISearchBarDelegate {

    func updateData(_ data: Any) {
        self.refreshData(firstLoad: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.reloadOnSearch(searchText: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.reloadOnSearch(searchText: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadOnSearch(searchText: searchBar.text ?? "")
    }
}
