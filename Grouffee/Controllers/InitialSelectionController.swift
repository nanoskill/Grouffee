//
//  InitialSelectionController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InitialSelectionController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBAction func newPlanDidTap(_ sender: Any) {
        performSegue(withIdentifier: "CreateRoomSegue", sender: sender)
    }
    @IBAction func joinPlanDidTap(_ sender: Any) {
        appDelegate.myPeerId = MCPeerID(displayName: appDelegate.displayName)
        appDelegate.connection = ConnectionModel(peerId: appDelegate.myPeerId)
        appDelegate.connection?.serviceBrowser.startBrowsingForPeers()
        performSegue(withIdentifier: "RoomListSegue", sender: sender)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
