//
//  GoalModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 08/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

class Goal : Codable{
    var name : String
    var user : User?
    var time : Date?
    
    init(name : String) {
        self.name = name
    }
    
}
