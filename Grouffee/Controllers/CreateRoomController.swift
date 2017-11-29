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
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    @IBAction func newPlanDidTap(_ sender: Any)
    {
        appDelegate.myPeerId = MCPeerID(displayName: roomNameField.text!)
        appDelegate.connection = ConnectionModel(peerId: appDelegate.myPeerId)
        appDelegate.connection?.serviceAdvertiser.startAdvertisingPeer()
        appDelegate.connection?.delegate = self
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

extension CreateRoomController : ConnectionModelDelegate
{
    func invitationWasReceived(fromPeer: String)
    {
        let popup = UIAlertController.createAcceptDeclinePopup(title: "Join Request", message: "Invitation from \(fromPeer). Do you want to accept this invitation?", handlerAccept:
        { (UIAlertAction) in
            self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
        }, handlerDecline:
        { (UIAlertAction) in
            self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
        })
        
        self.present(popup, animated: true, completion: nil)
    }
}
