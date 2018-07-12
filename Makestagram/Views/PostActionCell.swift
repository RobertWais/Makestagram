//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Robert Wais on 7/11/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit


protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell:PostActionCell)
}

class PostActionCell: UITableViewCell {

    weak var delegate: PostActionCellDelegate?
    static let height: CGFloat = 46
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func likesButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
