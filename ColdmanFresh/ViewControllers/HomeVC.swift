//
//  ViewController.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//

import UIKit
import SDWebImage

class HomeVC: SuperViewController {

    @IBOutlet weak var cvSlider: UICollectionView!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var btnCart: BadgeButton!
    @IBOutlet weak var lblCartValue: UILabel!

    var sliderData = [SliderData]()
    var menus = [Menu]()
    var categories = [Categories]()
    var addedMenus = [Menu]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getSliderImages()
    }


}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sliderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        let data = self.sliderData[indexPath.item]
        
        cell.pageControl.numberOfPages = self.sliderData.count
        cell.pageControl.currentPage = indexPath.item
        
        if let url = URL(string: data.slider_image) {
            cell.ivSlider.sd_setImage(with: url, completed: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let m = self.menus[indexPath.row]
        
        cell.lblTitle.text = m.menu_displayname
        if let first = self.categories.filter({ $0.id == m.menu_categoryid }).first {
            cell.lblFoodType.text = first.category_olname.uppercased()
        }
        
        if let url = URL(string: m.menu_logo) {
            cell.ivMenu.sd_setImage(with: url, completed: nil)
        }
        
        cell.lblStarRating.text = " ₹ " + m.menu_price + " "
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
        cell.btnAdd.addTarget(self, action: #selector(addToCartTapped(_:)), for: .touchUpInside)
        
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        cell.btnMinus.tag = indexPath.row
        cell.btnMinus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func addToCartTapped(_ sender: UIButton) {
        let menu = self.menus[sender.tag]
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
    
    @objc func plusTapped(_ sender: UIButton) {
        let menu = self.menus[sender.tag]
        menu.menuCount += 1
        menu.displayPrice = menu.price * Double(menu.menuCount)
        refreshData()
    }

    @objc func minusTapped(_ sender: UIButton) {
        let menu = self.menus[sender.tag]
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
        menu.displayPrice = menu.price * Double(menu.menuCount)
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
        }
        if self.addedMenus.count == 0 {
//            self.viewBaseGoToCart.isHidden = true
//            self.constraintGoToCartHeight.constant = 0
            self.menus.forEach { (m) in
                m.menuCount = 0
                m.displayPrice = m.price
                m.addedToCart = false
            }
            self.btnCart.badge = nil
            self.lblCartValue.text = ""
        }else {
            self.btnCart.badge = "\(self.addedMenus.count)"
            let val = self.addedMenus.map { $0.displayPrice }
            self.lblCartValue.text = " ₹ \(val.reduce(0, +)) "

//            self.viewBaseGoToCart.isHidden = false
//            self.constraintGoToCartHeight.constant = 50
//            self.lblGoToCart.text = "Go To Cart (\(self.addedMenus.count) items added)"
//            var itemTotal = 0.0
//            for m in self.addedMenus {
//                itemTotal += m.displayPrice
//            }
//            self.lblItemsTotal.text = "Items Total \n ₹ \(itemTotal.roundTo(places: 2))"
        }
        self.tblMenu.reloadData()
    }

}


extension HomeVC {
    
    func getSliderImages() {
        
        self.showActivityIndicator()
        ApiManager.getSliderData { (json) in
            self.hideActivityIndicator()
            if let array = json?.array {
                self.sliderData = SliderData.getSliderData(array: array)
                self.cvSlider.reloadData()
                self.getMenus()
            }
        }
    }
    
    func getMenus() {
        
        self.showActivityIndicator()
        ApiManager.getMenusData { (json) in
            self.hideActivityIndicator()
            if let dict = json?.dictionary {
                if let array = dict["menus"]?.array {
                    self.menus = Menu.getMenuData(array: array)
                }
                if let array = dict["categories"]?.array {
                    self.categories = Categories.getCategoriesData(array: array)
                }
                self.refreshData(firstLoad: true)
            }
        }
    }
}
