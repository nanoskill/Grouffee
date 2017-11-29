//
//  ViewController.swift
//  test
//
//  Created by Aldo Novendi Fadly on 27/11/17.
//  Copyright © 2017 binus. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CreateRoomViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var durTxt: UITextField!
    @IBOutlet weak var durPickerView: UIView!
    @IBOutlet weak var durPicker: UIPickerView!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var roomNameField: UITextField!
    
    var timer = Timer()
    
    var hours: [Int] = Array(0...23)
    var minutes: [Int] = Array(0...59)
    
    var selectedHours = 0
    var selectedMinutes = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for i in 0...23 * 10 {
            hours.append(hours[i])
        }
        for i in 0...59 * 10 {
            minutes.append(minutes[i])
        }
        
        selectedHours = (hours.count / 2) - 7
        selectedMinutes = (minutes.count / 2) - 25
        
        durPicker.dataSource = self
        durPicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDurPicker))
        durTxt.addGestureRecognizer(tapGesture)
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(hideDurPicker))
        durPickerView.addGestureRecognizer(hideGesture)
        
        durPickerView.alpha = 0.0
        //durPicker.alpha = 0.0
        //timerLabel.isHidden = true
        startBtn.isEnabled = false
        
        //addPickerLabel(labelString: "hours", rightX: 123, top: 100, height: 100)
    }
    
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
    }
    
    @objc
    func openDurPicker(){
        UIView.animate(withDuration: 0.2) {
            self.durPickerView.alpha = 1
            self.durPicker.alpha = 1
            self.durPicker.frame = CGRect(x: 0, y: self.durPickerView.bounds.height - self.durPicker.bounds.height, width: self.durPicker.bounds.width, height: self.durPicker.bounds.height)
        }
        self.durPicker.selectRow(selectedHours, inComponent: 0, animated: false)
        self.durPicker.selectRow(selectedMinutes, inComponent: 1, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewPlan" {
            let dest = segue.destination as! BoardListViewController
            dest.timeRemaining = (hours[selectedHours] * 3600) + (minutes[selectedMinutes] * 60)
        }
    }
    
    @objc
    func hideDurPicker(){
        selectedHours = durPicker.selectedRow(inComponent: 0)
        selectedMinutes = durPicker.selectedRow(inComponent: 1)
        if hours[selectedHours] == 0 && minutes[selectedMinutes] == 0 {
            durTxt.text = ""
        } else if hours[selectedHours] == 0 {
            durTxt.text = "\(String(minutes[selectedMinutes])) \("minutes")"
            startBtn.isEnabled = true
        } else if minutes[selectedMinutes] == 0{
            durTxt.text = "\(String(hours[selectedHours])) \("hours")"
            startBtn.isEnabled = true
        } else {
            durTxt.text = "\(String(hours[selectedHours])) \("hours") \(String(minutes[selectedMinutes])) \("minutes")"
            startBtn.isEnabled = true
        }
        UIView.animate(withDuration: 0.2) {
            self.durPickerView.alpha = 0
            self.durPicker.frame = CGRect(x: 0, y: self.durPickerView.bounds.height, width: self.durPicker.bounds.width, height: self.durPicker.bounds.height)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else {
            return minutes.count
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return String(hours[row])
        } else {
            return String(minutes[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 150
    }
    
    /*
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = String(hours[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 26.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        pickerLabel.attributedText = myTitle
        return pickerLabel
    }
    */
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        var pickerviewtemp = UIView()
//        var lbl = UILabel()
//        lbl.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
//        lbl.text = "hours"
//        lbl.font = UIFont(name: "System", size: 16)
//        pickerviewtemp.addSubview(lbl)
//
//        var lb2 = UILabel()
//        lb2.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
//        lb2.text = "min"
//        lb2.font = UIFont(name: "System", size: 16)
//        lb2.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
//        pickerviewtemp.addSubview(lb2)
//
//
//        return pickerviewtemp
//    }
    
//    func addPickerLabel(labelString: String, rightX: CGFloat, top: CGFloat, height: CGFloat){
//        var x: CGFloat = rightX
//
//        var hrsLbl = UILabel(frame: CGRect(x: x, y: top + 1, width: rightX, height: height))
//        hrsLbl.text = labelString
//        hrsLbl.font = UIFont(name: "System", size: 18)
//        hrsLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        hrsLbl.isOpaque = false
//        self.durPickerView.addSubview(hrsLbl)
//    }
    
    
}


