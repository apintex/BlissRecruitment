//
//  Questions.swift
//  BlissRecruitment
//
//  Created by António Pinto on 14/04/17.
//  Copyright © 2017 António Pinto. All rights reserved.
//

import Foundation

struct questions {
    
    var qId:Int = 0
    var qQuestion:String = ""
    var qImageUrl:String = ""
    var qThumbURL:String = ""
    var qPublishedAt:NSDate = NSDate()
    var qChoices:NSArray = []
    
    init(qId:Int,
         qQuestion:String,
         qImageUrl:String,
         qThumbURL:String,
         qPublishedAt:NSDate,
         qChoices:NSArray){
        
        self.qId = qId
        self.qQuestion = qQuestion
        self.qImageUrl = qImageUrl
        self.qThumbURL = qThumbURL
        self.qPublishedAt = qPublishedAt
        self.qChoices = qChoices
    }
}
