//
//  NewsFeedTableViewCell.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/26/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
