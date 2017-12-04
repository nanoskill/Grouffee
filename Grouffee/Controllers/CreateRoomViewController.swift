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
    
    @IBOutlet weak var roomNameTxt: UITextField!
    @IBOutlet weak var durTxt: UITextField!
    @IBOutlet weak var durPickerView: UIView!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var durPicker: UIPickerView!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    
    var timer = Timer()
    
    let pickerDataSize = 100000
    
    var selectedHours = 0
    var selectedMinutes = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        roomNameTxt.delegate = self
        
        durPicker.dataSource = self
        durPicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDurPicker))
        durTxt.addGestureRecognizer(tapGesture)
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(hideDurPicker))
        durPickerView.addGestureRecognizer(hideGesture)
        
        durPickerView.alpha = 0.0
        startBtn.isEnabled = false
    }
    
    @IBAction func newPlanDidTap(_ sender: Any)
    {
        appDelegate.myPeerId = MCPeerID(displayName: roomNameTxt.text!)
        appDelegate.connection = ConnectionModel(peerId: appDelegate.myPeerId)
        appDelegate.connection?.serviceAdvertiser.startAdvertisingPeer()
    }
    
    @objc
    func openDurPicker(){
        self.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.durPickerView.alpha = 1
            self.durPicker.alpha = 1
            self.pickerContainer.frame = CGRect(x: 0, y: self.durPickerView.bounds.height - self.pickerContainer.bounds.height, width: self.pickerContainer.bounds.width, height: self.pickerContainer.bounds.height)
        }
        self.durPicker.selectRow((pickerDataSize / 2) - 8 + selectedHours, inComponent: 0, animated: false)
        self.durPicker.selectRow((pickerDataSize / 2) - 20 + selectedMinutes, inComponent: 1, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewPlan" {
            let dest = segue.destination as! BoardListViewController
            dest.timeRemaining = (selectedHours * 3600) + (selectedMinutes * 60)
            dest.roomNameInput = roomNameTxt.text
        }
    }
    
    @objc
    func hideDurPicker(){
        
        UIView.animate(withDuration: 0.2) {
            self.durPickerView.alpha = 0
            self.pickerContainer.frame = CGRect(x: 0, y: self.durPickerView.bounds.height, width: self.pickerContainer.bounds.width, height: self.pickerContainer.bounds.height)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(row % 24)
        } else {
            return String(row % 60)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            if durPicker.selectedRow(inComponent: 0) % 24 == 1 {
                hoursLabel.text = "hour"
            } else {
                hoursLabel.text = "hours"
            }
            let position = pickerDataSize / 2 + row - 8
            pickerView.selectRow(position, inComponent: 0, animated: false)
        } else {
            let position = pickerDataSize / 2 + row - 20
            pickerView.selectRow(position, inComponent: 1, animated: false)
        }
        showSelectedDataToTextField()
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func showSelectedDataToTextField(){
        selectedHours = durPicker.selectedRow(inComponent: 0) % 24
        selectedMinutes = durPicker.selectedRow(inComponent: 1) % 60
        
        var minLabel = "minutes"
        
        if selectedMinutes % 60 == 1 {
            minLabel = "minute"
        } else {
            minLabel = "minutes"
        }
        
        if roomNameTxt.text != "" {
            startBtn.isEnabled = true
        }
        
        if selectedHours == 0 && selectedMinutes == 0 {
            durTxt.text = ""
            startBtn.isEnabled = false
        } else if selectedHours == 0 {
            durTxt.text = "\(String(selectedMinutes)) \(minLabel)"
            
        } else if selectedMinutes % 60 == 0{
            durTxt.text = "\(String(selectedHours)) \((hoursLabel.text)!)"
            
        } else {
            durTxt.text = "\(String(selectedHours)) \((hoursLabel.text)!) \(String(selectedMinutes)) \(minLabel)"
        }
    }
    
    //Room name validation
    @IBAction func validateRoomName(_ sender: Any) {
        if durTxt.text != "" {
            if roomNameTxt.text != "" {
                startBtn.isEnabled = true
                //print("ABCD")
            } else {
                startBtn.isEnabled = false
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

extension CreateRoomViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.becomeFirstResponder()
        return false
    }
}

