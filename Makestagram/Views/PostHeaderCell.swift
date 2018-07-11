//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Robert Wais on 7/11/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    @IBOutlet weak var usernameLbl: UILabel!
    
    static let height: CGFloat = 54
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var optionsBtnTapped: UIButton!
    
}
