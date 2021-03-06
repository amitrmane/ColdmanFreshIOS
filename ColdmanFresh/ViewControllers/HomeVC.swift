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
    var subCategories = [SubCategories]()
    var addedMenus = [Menu]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

        if let _ = Utilities.getValueForKeyFromUserDefaults("isAlertConfirmed") {
            AppUpdater.shared.showUpdate(withConfirmation: false)
            self.getSliderImages()
        }else {
            self.getSliderImages()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let messageVC = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeAlertVC") as! WelcomeAlertVC
                messageVC.closeCallBack = {
                    AppUpdater.shared.showUpdate(withConfirmation: false)
                    self.getSliderImages()
                }
                self.present(messageVC, animated: true, completion: nil)
            }
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.cvCategories.addSubview(refreshControl)
        NotificationCenter.default.addObserver(self, selector: #selector(orderSuccess), name: NSNotification.Name.init("orderSuccess"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshData()
        }
    }
    
    @objc func refreshPage() {
        self.getSliderImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshData(firstLoad: true)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        DispatchQueue.global(qos: .userInitiated).async {
        ApiManager.getMenusData { (json) in
            if let dict = json?.dictionary {
                if let array = dict["menus"]?.array {
                    self.menus = Menu.getMenuData(array: array)
                }
                if let array = dict["main_categories"]?.array {
                    self.categories = Categories.getCategoriesData(array: array)
                }
                if let array = dict["sub_categories"]?.array {
                    self.subCategories = SubCategories.getCategoriesData(array: array)
                }
//                DispatchQueue.main.async {
                self.refreshData(firstLoad: true)
//                }
            }else {
                self.showNoRecordsViewWithLabel(self.cvCategories, message: "Failed to fetch categories, please try again later. \n To reload just tap again on home button")
            }
        }
    }
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
                //        loginvc.delegate = self
                self.navigationController?.pushViewController(loginvc, animated: true)
            }
        }else {
            self.showAlert("No items in cart, please select category and add items.")
        }

    }
    
}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvSlider {
            if self.sliderData.count > 0 {
                collectionView.backgroundView = nil
            }
            return self.sliderData.count
        }
        if self.categories.count > 0 {
            collectionView.backgroundView = nil
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
//                    cell.ivSlider.contentMode = .scaleToFill
                }
            }
            return cell
        }
        let data = self.categories[indexPath.item]
        
        cell.lblName.text = data.category_name
                
        if let url = URL(string: Constants.baseDownloadURL + "maincategory/\(data.category_img)") {
            cell.ivSlider.sd_setImage(with: url, placeholderImage: UIImage(named: "image-placeholder"), options: .continueInBackground) { (i, e, t, u) in
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if self.cvCategories == collectionView {
            let cat = self.categories[indexPath.item]
            let listvc = mainStoryboard.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
            listvc.addedMenus = addedMenus
            listvc.backDelegate = self
            listvc.menus = self.menus
            listvc.allMenus = self.menus
            listvc.categories = self.categories
            listvc.subCategories = self.subCategories.filter({ $0.maincategory == cat.id && $0.category_on_off == "1" })
            listvc.selectedCategory = cat
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
        if Menu.getSavedCartItems().count == 0 {
            self.menus.forEach { (m) in
                m.menuCount = 0
                m.displayPrice = m.price
                m.addedToCart = false
            }
            self.btnCart.badge = nil
            self.lblCartValue.text = ""
        }else {
            self.addedMenus = Menu.getSavedCartItems()
            self.btnCart.badge = "\(self.addedMenus.count)"
            let val = self.addedMenus.map { $0.displayPrice }
            self.lblCartValue.text = " ??? \(val.reduce(0, +)) "

        }
        self.cvCategories.reloadData()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }

    func showNoRecordsViewWithLabel(_ tableView: UICollectionView, message: String) {
        let v1 = UIView(frame: tableView.frame)
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: v1.frame.width, height: v1.frame.height))
        noDataLbl.text = message
        noDataLbl.numberOfLines = 0
        noDataLbl.textAlignment = .center
        noDataLbl.lineBreakMode = .byWordWrapping
//        noDataLbl.center = v1.center
        v1.addSubview(noDataLbl)
        tableView.backgroundView  = v1
    }
       
}


extension HomeVC : BackRefresh {

    func updateData(_ data: Any) {
        self.refreshData(firstLoad: true)
    }
    
    @objc func orderSuccess() {
        if let tabbar = self.tabBarController {
            tabbar.selectedIndex = 1
        }
    }
    
    func getSliderImages() {
        
        self.showActivityIndicator()
        ApiManager.getSliderData { (json) in
            self.hideActivityIndicator()
            if let array = json?.array {
                self.sliderData = SliderData.getSliderData(array: array)
                self.cvSlider.reloadData()
            }else {
                self.showNoRecordsViewWithLabel(self.cvSlider, message: "Failed to fetch data, please try again later.")
            }
            self.getMenus()
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
                if let array = dict["main_categories"]?.array {
                    self.categories = Categories.getCategoriesData(array: array)
                }
                if let array = dict["sub_categories"]?.array {
                    self.subCategories = SubCategories.getCategoriesData(array: array)
                }
                self.refreshData(firstLoad: true)
            }else {
                self.showNoRecordsViewWithLabel(self.cvCategories, message: "Failed to fetch categories, please try again later. \n To reload just tap again on home button")
            }
        }
    }
}
