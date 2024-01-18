//
//  ScaleDurationView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 05/11/24.
//

import UIKit

enum PickerType {
    case date
    case time
}

protocol ScaleDurationViewDelegate: AnyObject {
    func dateChangedTo(date: Date)
    func hourChangedTo(date: Date)
}

@IBDesignable
class ScaleDurationView: UIView {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    var date: Date = .init()
    
    weak var delegate: ScaleDurationViewDelegate?
    
    @IBInspectable var labelText: String = "" {
        didSet {
            let text =  (labelText == "Início") ? LocalizedString.startLabel : LocalizedString.endLabel
            label.text = text
            layoutIfNeeded()
        }
    }
    @IBInspectable var finalTimeTextIsEnable: Bool = true {
        didSet {
            timeTextField.isEnabled = finalTimeTextIsEnable
            timeTextField.textColor = UIColor(named: "textAddShiftColor")
            layoutIfNeeded()
        }
    }
    
    let datePicker: UIDatePicker = UIDatePicker()
    let timePicker: UIDatePicker = UIDatePicker()
    
    required init?(coder: NSCoder) {
         super.init(coder: coder)
        loadView()
        setupUI()
        date = Calendar.current.combineTimeFrom(date: timePicker.date, andDateFrom: datePicker.date)
     }
}

extension ScaleDurationView {
    
    private func setupUI() {
        setupDatePicker()
        setupTimePicker()
    }
    
    private func setupTimePicker() {
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = createToolbar(type: .time)
        timeTextField.tintColor = .clear
        setTimeLabelWith(date: .init())
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolbar(type: .date)
        dateTextField.tintColor = .clear
        setDateLabelWith(date: .init())
    }
    
    private func createToolbar(type: PickerType) -> UIToolbar {
        let toolBar: UIToolbar = UIToolbar()
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        switch type {
        case .date:
            let doneButton = UIBarButtonItem(title: LocalizedString.doneButton, style: .done, target: self, action: #selector(self.datePickerDoneTapped))
            toolBar.setItems([flexSpace, doneButton], animated: false)
            return toolBar
        case .time:
            let doneButton = UIBarButtonItem(title: LocalizedString.doneButton, style: .done, target: self, action: #selector(self.timePickerDoneTapped))
            toolBar.setItems([flexSpace, doneButton], animated: false)
            return toolBar
        }
    }
    
//    @objc private func datePickerDoneTapped() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeZone = .none
//        dateFormatter.dateFormat = "d MMM. yyyy"
//        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
//        self.dateTextField.resignFirstResponder()
//        delegate?.dateChanged()
//    }
//
//    @objc private func timePickerDoneTapped(){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "h:mm a"
//        self.timeTextField.text = dateFormatter.string(from: timePicker.date)
//        self.timeTextField.resignFirstResponder()
//        delegate?.hourChanged()
//    }
    
    @objc private func datePickerDoneTapped() {
        date = Calendar.current.combineTimeFrom(date: timePicker.date, andDateFrom: datePicker.date)
        setDateLabelWith(date: date)
        self.dateTextField.resignFirstResponder()
        delegate?.dateChangedTo(date: date)
    }
    
    @objc private func timePickerDoneTapped(){
        date = Calendar.current.combineTimeFrom(date: timePicker.date, andDateFrom: datePicker.date)
        setTimeLabelWith(date: date)
        self.timeTextField.resignFirstResponder()
        delegate?.hourChangedTo(date: date)
    }
    
    func setDateLabelWith(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = "d MMM yyyy"
        self.dateTextField.text = dateFormatter.string(from: date)
    }
    
    func setTimeLabelWith(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "h:mm a"
        self.timeTextField.text = dateFormatter.string(from: date)
    }
    
    private func loadView() {
        let bundle = Bundle(for: ScaleDurationView.self)
        let nib = UINib(nibName: "ScaleDurationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
