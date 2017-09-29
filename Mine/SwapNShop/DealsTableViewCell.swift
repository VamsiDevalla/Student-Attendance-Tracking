//
//  DealsTableViewCell.swift
//  SwapNShop
//
//  Created by Devalla,Vamsi on 4/14/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit

// Class to handle the display of deal/post/pins table view
class DealsTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //outlets for the custom post cell
    @IBOutlet weak var gameImageIMGV: UIImageView!
    @IBOutlet weak var gameTitleLBL: UILabel!
    @IBOutlet weak var dealTypeCostLBL: UILabel!
    @IBOutlet weak var gameDescriptionTXTV: UITextView!
    
}
