//
//  TableViewCells.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 11/01/21.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var ivMenu: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblFoodType: UILabel!
    @IBOutlet weak var lblStarRating: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblOrderValue: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblMenuCount: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var viewBaseCounter: CustomView!

    @IBOutlet weak var lblGate: UILabel!
    @IBOutlet weak var lblTimeSlot: UILabel!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
