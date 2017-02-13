//
//  HNNavigationBarTitleView.swift
//  HackerNewsApp
//
//  Created by Venugopal Reddy Devarapally on 12/02/17.
//  Copyright © 2017 Venugopal Reddy Devarapally. All rights reserved.
//

import UIKit

class HNNavigationBarTitleView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "HNNavigationBarTitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
