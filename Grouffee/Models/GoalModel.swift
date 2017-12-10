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
    
    func checked(user: User) {
        self.user = user
        time = Date()
    }
    /*
    enum CodingKeys : String, CodingKey
    {
        case name
        case user
        case time
    }
    
    required init(from decoder: Decoder) throws
    {
        try let values = decoder.container(keyedBy: CodingKeys)
        
        name = try values.decode(String.self, forKey: .name)
        let user = 
    }
    */
    func unchecked() {
        self.user = nil
        time = nil
    }
    
    func isChecked() -> Bool
    {
        return user == nil
    }
}
