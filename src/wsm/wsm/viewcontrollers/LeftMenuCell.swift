//
//  LeftMenuCell.swift
//  wsm
//
//  Created by framgia on 9/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!

    func updateCell(item: MenuItem) {
        menuTitle.text = item.title
        menuTitle.textColor = UIColor.darkGray
        menuTitle.highlightedTextColor = UIColor.appBarTintColor

        if let image = UIImage(named: item.image) {
            menuImage.setImage(image: image, withColor: UIColor.darkGray)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

        if selected {
            menuImage.tintColor = UIColor.appBarTintColor
        } else {
            menuImage.tintColor = UIColor.darkGray
        }
    }
}
