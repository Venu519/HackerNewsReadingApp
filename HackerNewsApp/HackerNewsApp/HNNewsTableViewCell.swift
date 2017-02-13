//
//  HNNewsTableViewCell.swift
//  HackerNewsApp
//
//  Created by Venugopal Reddy Devarapally on 12/02/17.
//  Copyright © 2017 Venugopal Reddy Devarapally. All rights reserved.
//

import UIKit

class HNNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
