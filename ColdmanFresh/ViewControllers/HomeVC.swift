//
//  ViewController.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//

import UIKit
import SDWebImage

class HomeVC: UIViewController {

    @IBOutlet weak var cvSlider: UICollectionView!
    @IBOutlet weak var tblMenu: UITableView!
    
    var sliderData = [SliderData]()
    var menus = [Menu]()

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
        cell.lblFoodType.text = m.menu_foodtype
        
        if let url = URL(string: m.menu_logo) {
            cell.ivMenu.sd_setImage(with: url, completed: nil)
        }
        
        cell.lblStarRating.text = "₹ " + m.menu_price
        
        
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
//        cell.btnAdd.addTarget(self, action: #selector(addToCartTapped(_:)), for: .touchUpInside)
        
        cell.btnPlus.tag = indexPath.row
//        cell.btnPlus.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        cell.btnMinus.tag = indexPath.row
//        cell.btnMinus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)

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
}


extension HomeVC {
    
    func getSliderImages() {
        
        ApiManager.getSliderData { (json) in
            if let array = json?.array {
                self.sliderData = SliderData.getSliderData(array: array)
                self.cvSlider.reloadData()
                self.getMenus()
            }
        }
    }
    
    func getMenus() {
        
        ApiManager.getMenusData { (json) in
            if let array = json?.array {
                self.menus = Menu.getMenuData(array: array)
                self.tblMenu.reloadData()
            }
        }
    }
}
