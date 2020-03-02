//
//  CommentsVC.swift
//  Parstagram
//
//  Created by Brandon Elmore on 3/1/20.
//  Copyright © 2020 CodePath. All rights reserved.
//

import UIKit

class CommentsVC: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var CommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
