//
//  VariationPopupVC.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 19/01/21.
//

import UIKit

class VariationPopupVC: SuperViewController {

    @IBOutlet weak var tblVariation: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!

    var variations = [Variation]()
    var selectedVariation : ((_ variation: Variation) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblHeight.constant = CGFloat(self.variations.count * 50)
    }
    

    @IBAction func addTapped(_ sender: UIButton) {
        if let selected = self.selectedVariation, let first = self.variations.filter({$0.selected }).first {
            selected(first)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

}

extension VariationPopupVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let v = self.variations[indexPath.row]
        
        cell.lblTitle.text = v.name + ": ₹ \(v.rate)"
        
        if v.selected {
            cell.ivMenu.image = UIImage(named: "radio-checked")
        }else {
            cell.ivMenu.image = UIImage(named: "radio-unchecked")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let v = self.variations[indexPath.row]
        v.selected = true
        
        for vr in self.variations {
            if vr.variation_id != v.variation_id {
                vr.selected = false
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
