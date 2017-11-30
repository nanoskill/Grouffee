//
//  HomeViewController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import Dispatch

class HomeViewController: UIViewController {

    @IBOutlet weak var nameField : UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        
        
        checkNow()
        // Do any additional setup after loading the view.
    }
    
    func checkNow()
    {
        if UIAccessibilityIsGuidedAccessEnabled() == false
        {
            /*
            let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            let subv = UIView(frame: rect)
            subv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3272447183)
            self.view.addSubview(subv)
            subv.becomeFirstResponder()*/
            let popup = UIAlertController.createOkayPopup(title: "Guided Access Disabled", message: "Enabled it!", handler :
            { (_) in
                DispatchQueue.main.async {
                    //subv.removeFromSuperview()
                }
                if UIAccessibilityIsGuidedAccessEnabled() == false
                {
                    self.checkNow()
                }
                else
                {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            DispatchQueue.main.async {
                popup.presentExclusively(view: self)
            }
        }
    }
    
    @IBAction func startBtn()
    {
        if nameField.text == ""
        {
            return //need optimization
        }
        appDelegate.user = User(name: nameField.text!)
    }
}

extension HomeViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == ""
        {
            return false
        }
        startBtn()
        return true
    }
}
