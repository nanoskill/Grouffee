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
    @IBOutlet weak var joinPlanBtn: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newPlanBtn.isEnabled = false
        joinPlanBtn.isEnabled = false
        errorMessage.text = ""
        nameField.delegate = self
        //addKeyboardViewAdjustment()
        errorView.isHidden = true
        errorView.layer.cornerRadius = 10
        nameField.becomeFirstResponder()
    }
    
    @IBAction func newPlanDidTap(_ sender: Any) {
        if validateName()
        {
            let sb = UIStoryboard(name: "CreateRoom", bundle: nil)
            let con : UIViewController! = sb.instantiateInitialViewController()
            present(con, animated: true, completion: nil)
            //performSegue(withIdentifier: "CreateRoomSegue", sender: sender)
        }
    }
    @IBAction func joinPlanDidTap(_ sender: Any) {
        if validateName()
        {
            appDelegate.user.peerId = MCPeerID(displayName: appDelegate.user.name)
            appDelegate.connection = ConnectionModel(peerId: appDelegate.user.peerId!)
            print((appDelegate.connection?.session)!)
            appDelegate.connection?.serviceBrowser.startBrowsingForPeers()
            let sb = UIStoryboard(name: "RoomList", bundle: nil)
            let con : UIViewController! = sb.instantiateInitialViewController()
            present(con, animated: true, completion: nil)
            //performSegue(withIdentifier: "RoomListSegue", sender: sender)
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
                    errorView.isHidden = false
                    errorMessage.text = "Name must be alphabet only"
                    newPlanBtn.isEnabled = false
                    joinPlanBtn.isEnabled = false
                    return false
                }
                else
                {
                    errorMessage.text = ""
                    newPlanBtn.isEnabled = true
                    joinPlanBtn.isEnabled = true
                    appDelegate.user = User(name: nameField.text!)
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
        if nameField.text == "" || !validateName()
        {
            newPlanBtn.isEnabled = false
            joinPlanBtn.isEnabled = false
            errorView.isHidden = false
            if nameField.text == ""{
                errorView.isHidden = true
            }
            return
        }
        errorView.isHidden = true
        newPlanBtn.isEnabled = true
        joinPlanBtn.isEnabled = true
    }
    
    // to set status bar text to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //textField code
    override func viewDidLayoutSubviews() {
        customizeTextField(textField: nameField, placeHolder: "Your name")
    }
    
    func customizeTextField(textField: UITextField, placeHolder: String){
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = #colorLiteral(red: 0.3330789208, green: 0.7621915936, blue: 0.7701457143, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        
        let leftView: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 40, height: 26))
        leftView.backgroundColor = UIColor.clear
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.contentVerticalAlignment = .center
    }
}

extension InitialSelectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.becomeFirstResponder()
        return false
    }
}
