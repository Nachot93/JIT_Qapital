//
//  MainTableViewCell.swift
//  JIT_Qapital
//
//  Created by Juan Ignacio Tarallo on 05/06/2019.
//  Copyright © 2019 Juan Ignacio Tarallo. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
//    var user: Users? {
//        didSet {
////            descriptionLabel.text = user?.displayName
////            imgView.image = user?.avatarUrl
//        }
//    }
//    var activity: Activity? {
//        didSet {
////            descriptionLabel.text = Activity?.message
////            imgView.image = user?.avatarUrl
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
