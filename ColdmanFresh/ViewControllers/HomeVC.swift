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
    @IBOutlet weak var cvCategories: UICollectionView!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshData()
    }


    @IBAction func cartTapped(_ sender: UIButton) {
        let addedMenus = Menu.getSavedCartItems()
        if addedMenus.count > 0 {
            let cartvc = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
            cartvc.addedMenus = addedMenus
            cartvc.backDelegate = self
//            cartvc.currentAddress = self.currentAddress == nil ? self.currentLocation : self.currentAddress
            self.navigationController?.pushViewController(cartvc, animated: true)
        }else {
            self.showAlert("No items in cart, please select restaurant and add items.")
        }
    }
    
}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvSlider {
            return self.sliderData.count
        }
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        if collectionView == self.cvSlider {
            let data = self.sliderData[indexPath.item]
            
            cell.pageControl.numberOfPages = self.sliderData.count
            cell.pageControl.currentPage = indexPath.item
            
            cell.ivSlider.contentMode = .scaleAspectFit
            if let url = URL(string: data.slider_image) {
                cell.ivSlider.sd_setImage(with: url, placeholderImage: UIImage(named: "image-placeholder"), options: .continueInBackground) { (i, e, t, u) in
                    cell.ivSlider.contentMode = .scaleToFill
                }
            }
            return cell
        }
        let data = self.categories[indexPath.item]
        
        cell.lblName.text = data.category_name
                
        if let url = URL(string: Constants.baseDownloadURL + data.category_img) {
            cell.ivSlider.sd_setImage(with: url, placeholderImage: UIImage(named: "image-placeholder"), options: .continueInBackground) { (i, e, t, u) in
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if self.cvCategories == collectionView {
            let listvc = mainStoryboard.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
            listvc.addedMenus = addedMenus
            listvc.backDelegate = self
            listvc.allMenus = self.menus
            listvc.categories = self.categories
            listvc.selectedCategory = self.categories[indexPath.item]
            self.navigationController?.pushViewController(listvc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvSlider {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return CGSize(width: (collectionView.frame.width / 2 - 10), height: (collectionView.frame.width / 2 - 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cvCategories {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeVC {

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
            self.lblCartValue.text = ""
        }else {
            self.btnCart.badge = "\(self.addedMenus.count)"
            let val = self.addedMenus.map { $0.displayPrice }
            self.lblCartValue.text = " ₹ \(val.reduce(0, +)) "

        }
        self.cvCategories.reloadData()
    }

}


extension HomeVC : BackRefresh {

    func updateData(_ data: Any) {
        self.refreshData(firstLoad: true)
    }
    
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
