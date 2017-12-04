//
//  InitialSelectionViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class InitialSelectionViewController: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var newPlanBtn: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newPlanBtn.isEnabled = false
        errorMessage.text = ""
        nameTxt.delegate = self
    }

    @IBAction func vaidateName(_ sender: Any) {
        if nameTxt.text != ""{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: nameTxt.text!, options: [], range: NSMakeRange(0, (nameTxt.text?.count)!)) != nil{
                    errorMessage.text = "Name must be alphabet only"
                    newPlanBtn.isEnabled = false
                } else {
                    errorMessage.text = ""
                    newPlanBtn.isEnabled = true
                }
            } catch {
                
            }
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
}

extension InitialSelectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.becomeFirstResponder()
        return false
    }
}
