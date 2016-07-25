//
//  FriendsTableViewCell.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/22/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Foundation

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet var imageView2: UIImageView!
    @IBOutlet weak var friendsNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
