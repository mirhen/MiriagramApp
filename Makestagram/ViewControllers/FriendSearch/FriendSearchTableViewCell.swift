//
//  FriendSearchTableViewCell.swift
//  Makestagram
//
//  Created by Miriam Hendler on 6/28/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

protocol FriendSearchTableViewCellDelegate: class {
    func cell(cell: FriendSearchTableViewCell, didSelectFollowUser user: PFUser)
    func cell(cell: FriendSearchTableViewCell, didSelectUnfollowUser user: PFUser)
}



class FriendSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var followButton: UIButton!
    
    weak var delegate: FriendSearchTableViewCellDelegate?
    
    var user: PFUser? {
        didSet {
            usernameLabel.text = user?.username
            
        }
    }
    
    var canFollow: Bool? = true {
        didSet {
            if let canFollow = canFollow {
                followButton.selected = !canFollow
            }
        }
    }
   
    @IBAction func followbuttonTapped(sender: AnyObject) {
        if let canFollow = canFollow where canFollow == true {
            delegate?.cell(self, didSelectFollowUser: user!)
            self.canFollow = false
        } else {
            delegate?.cell(self, didSelectUnfollowUser: user!)
            self.canFollow = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
