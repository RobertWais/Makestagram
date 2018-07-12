//
//  FindFriendsCell.swift
//  Makestagram
//
//  Created by Robert Wais on 7/12/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit

protocol FindFriendsCellDelegate: class {
    func didTapFollowButton(_ followButton: UIButton, on cell:FindFriendsCell)
}


class FindFriendsCell: UITableViewCell {

    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var followButton: UIButton!
    weak var delegate: FindFriendsCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //UPDATING UI
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 6
        followButton.clipsToBounds = true
        
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
        
        
        // Initialization code
    }
    
    @IBAction func followButtonTapped(sender: UIButton) {
        delegate?.didTapFollowButton(sender, on: self)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
