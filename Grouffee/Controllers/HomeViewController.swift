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
    @IBOutlet weak var start : UIButton!
    @IBAction func startBtn()
    {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    let user = User(name: "Ravian")
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        start.layer.cornerRadius = 10
        /*
        UNUserNotificationCenter.current().getNotificationSettings
        { (set) in
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
        */
        NotificationCenter.default.addObserver(self, selector: #selector(user.timer.restoreTimer), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        user.timer.snapTimer()
      //  NotificationCenter.default.addObserver(self, selector: #selector(user.timer.snapTimer), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func restoreTimer() {
        print("Resign Active")
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
        
        user.timer.restoreTimer()
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
//            textField
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
