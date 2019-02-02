//
//  FeelingsTableViewCell.swift
//  Feelings
//
//  Created by Lucas Wang on 2018-05-20.
//  Copyright © 2018 Lucas Wang. All rights reserved.
//

import UIKit
import os.log

class EventTableViewCell: UITableViewCell {


    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var DefaultEventPhoto: UIImageView!
    @IBOutlet weak var Cell_Happy_Sad_Emoji: UILabel!
    @IBOutlet weak var Cell_Anger_Fear_Emoji: UILabel!
    @IBOutlet weak var Cell_Interest_Bordem_Emoji: UILabel!
    @IBOutlet weak var Cell_Love_Hate_Emoji: UILabel!
    
    @IBOutlet weak var EditEventButton: UIButton!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
