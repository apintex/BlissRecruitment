//
//  DetailsScreenTableViewCell.swift
//  BlissRecruitment
//
//  Created by António Pinto on 15/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import UIKit

class DetailsScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var lbChoice: UILabel!
    @IBOutlet weak var lbVotes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
