//
//  InitialSelectionViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InitialSelectionViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var newPlanBtn: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newPlanBtn.isEnabled = false
        errorMessage.text = ""
        nameField.delegate = self
        addKeyboardViewAdjustment()
    }
    
    @IBAction func newPlanDidTap(_ sender: Any) {
        if validateName()
        {
            performSegue(withIdentifier: "CreateRoomSegue", sender: sender)
        }
    }
    @IBAction func joinPlanDidTap(_ sender: Any) {
        if validateName()
        {
            appDelegate.myPeerId = MCPeerID(displayName: appDelegate.user.name)
            appDelegate.connection = ConnectionModel(peerId: appDelegate.myPeerId)
            appDelegate.connection?.serviceBrowser.startBrowsingForPeers()
            performSegue(withIdentifier: "RoomListSegue", sender: sender)
        }
    }

    func validateName() -> Bool {
        if nameField.text != ""
        {
            do
            {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: nameField.text!, options: [], range: NSMakeRange(0, (nameField.text?.count)!)) != nil
                {
                    errorMessage.text = "Name must be alphabet only"
                    newPlanBtn.isEnabled = false
                    return false
                }
                else
                {
                    errorMessage.text = ""
                    newPlanBtn.isEnabled = true
                    return true
                }
            } catch {
                
            }
        }
        return false
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    @IBAction func textFieldChanged()
    {
        if nameField.text == ""
        {
            newPlanBtn.isEnabled = false
            return
        }
        newPlanBtn.isEnabled = true
    }
}

extension InitialSelectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.becomeFirstResponder()
        return false
    }
}
