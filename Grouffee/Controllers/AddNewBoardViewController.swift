//
//  AddNewBoardViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 01/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class AddNewBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var boardName: UITextField!
    @IBOutlet weak var durTxt: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var goals: UITextField!
    @IBOutlet weak var createBoardBtn: UIButton!
    
    @IBOutlet weak var durPickerView: UIView!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var durPicker: UIPickerView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let pickerDataSize = 100000
    var selectedHours = 0
    var selectedMinutes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        durPicker.dataSource = self
        durPicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDurPicker))
        durTxt.addGestureRecognizer(tapGesture)
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(hideDurPicker))
        durPickerView.addGestureRecognizer(hideGesture)
        
        durPickerView.alpha = 0.0
        //createBoardBtn.isEnabled = false
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
    
    @IBAction func cancelDidTap(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createBoardDidTap(_ sender: Any)
    {
        appDelegate.room.boards.append(Board(boardName: boardName.text!, duration: selectedHours*3600 + selectedMinutes*60))
        dismiss(animated: true, completion: nil)
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
        
        if boardName.text != "" {
            createBoardBtn.isEnabled = true
        }
        
        if selectedHours == 0 && selectedMinutes == 0 {
            durTxt.text = ""
            createBoardBtn.isEnabled = false
        } else if selectedHours == 0 {
            durTxt.text = "\(String(selectedMinutes)) \(minLabel)"
            
        } else if selectedMinutes % 60 == 0{
            durTxt.text = "\(String(selectedHours)) \((hoursLabel.text)!)"
            
        } else {
            durTxt.text = "\(String(selectedHours)) \((hoursLabel.text)!) \(String(selectedMinutes)) \(minLabel)"
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
}
