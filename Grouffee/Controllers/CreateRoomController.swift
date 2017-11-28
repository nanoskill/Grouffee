//
//  CreateRoomController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CreateRoomController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func newPlanDidTap(_ sender: Any)
    {
        appDelegate.myPeerId = MCPeerID(displayName: roomNameField.text!)
        appDelegate.connection = ConnectionModel(peerId: appDelegate.myPeerId)
        appDelegate.connection?.serviceAdvertiser.startAdvertisingPeer()
    }
    @IBOutlet weak var roomNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
