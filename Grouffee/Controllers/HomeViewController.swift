//
//  HomeViewController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import Dispatch
import UserNotifications

class HomeViewController: UIViewController {

    @IBOutlet weak var nameField : UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        
        UNUserNotificationCenter.current().getNotificationSettings { (set) in
            if set.authorizationStatus == .denied
            {
                let popup = UIAlertController.createOkayPopup(title: "Notification display", message: "We strongly recommend you to give us permission to display notifications in your notification center", handler: {(_) in self.checkNow()})
                DispatchQueue.main.async {
                    popup.presentExclusively(view: self)
                }
            }
            else
            {
                self.checkNow()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func checkNow()
    {
        if UIAccessibilityIsGuidedAccessEnabled() == false
        {
            let popup = UIAlertController.createOkayPopup(title: "Guided Access Disabled", message: "Enabled it!", handler :
            { (_) in
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

extension HomeViewController : UIGuidedAccessRestrictionDelegate
{
    var guidedAccessRestrictionIdentifiers: [String]? {
        var a = [String]()
        a.append("Ini")
        a.append("Itu")
        return a
    }
    
    func textForGuidedAccessRestriction(withIdentifier restrictionIdentifier: String) -> String? {
        for it in guidedAccessRestrictionIdentifiers! {
            if it == restrictionIdentifier
            {
                return "text \(it)"
            }
        }
        return ""
    }
    
    func guidedAccessRestriction(withIdentifier restrictionIdentifier: String, didChange newRestrictionState: UIGuidedAccessRestrictionState)
    {
        print(restrictionIdentifier + " changed")
    }
}
