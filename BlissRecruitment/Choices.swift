//
//  Choices.swift
//  BlissRecruitment
//
//  Created by António Pinto on 16/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import Foundation

struct choices {
    
    var cChoice:String = ""
    var cVotes:Int = 0
    
    init(cChoice:String,
         cVotes:Int){
        
        self.cChoice = cChoice
        self.cVotes = cVotes
    }
}
