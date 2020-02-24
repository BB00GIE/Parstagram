//
//  CellVC.swift
//  Parstagram
//
//  Created by Brandon Elmore on 2/23/20.
//  Copyright © 2020 CodePath. All rights reserved.
//

import UIKit

class CellVC: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var photoVIew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
