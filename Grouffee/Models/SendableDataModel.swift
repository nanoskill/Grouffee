//
//  SendableDataModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 08/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public struct JoinData : Codable
{
    let data_type = "join_data"
    let targetBoard : Int
    let user : String
}

public struct ExitData : Codable
{
    let data_type = "exit_data"
    let user : String
}

public struct QuitData : Codable
{
    let data_type = "quit_data"
    var user : String
}

public struct InitialData : Codable
{
    let data_type = "init_data"
    var room : Room
}

public struct GoalCheckData : Codable
{
    let data_type = "goalcheck_data"
    var board : Board
}

public struct RequestUpdateData : Codable{
    let data_type = "request_data"
}
