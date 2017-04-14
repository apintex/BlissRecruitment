//
//  QuestionsListScreenTableViewCell.swift
//  BlissRecruitment
//
//  Created by António Pinto on 14/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import UIKit

class QuestionsListScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var imgQuestion: UIImageView!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbPublishedAt: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
