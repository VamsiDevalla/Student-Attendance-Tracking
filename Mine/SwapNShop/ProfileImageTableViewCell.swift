//
//  ProfileImageTableViewCell.swift
//  SwapNShop
//
//  Created by Sangaraju,Sunil Kumar on 4/2/17.
//  Copyright © 2017 Devalla,Vamsi. All rights reserved.
//

import UIKit

// Class to handle the display of profile table view
class ProfileImageTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //outlet for the custom profile image cell
    @IBOutlet weak var profilepic: UIImageView!
}
