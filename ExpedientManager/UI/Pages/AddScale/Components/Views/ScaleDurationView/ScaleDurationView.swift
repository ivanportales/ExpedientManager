//
//  ScaleDurationView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 05/11/24.
//

import UIKit

protocol ScaleDurationViewDelegate: AnyObject {
    func dateChangedTo(date: Date)
    func hourChangedTo(date: Date)
}

enum ScaleDurationType {
    case startingTime, endingTime
}

enum ScaleDurationViewPresentationType {
    case editable, viewOnly
}

private enum PickerType {
    case date, time
}

@IBDesignable
class ScaleDurationView: UIView {
    
    // MARK: - UI

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        return datePicker
    }()
    
    lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        
        return timePicker
    }()
    
    // MARK: - Exposed Properties
    
    weak var delegate: ScaleDurationViewDelegate?
    let durationType: ScaleDurationType
    var presentationType: ScaleDurationViewPresentationType
    private(set) var date: Date = .init() {
        didSet {
            self.dateTextField.text = date.getFormattedDateString()
            self.timeTextField.text = date.getFormattedTimeString()
        }
    }
    
    // MARK: - Private Properties
    
    
    // MARK: - Inits
    
    init(durationType: ScaleDurationType,
         presentationType: ScaleDurationViewPresentationType = .editable,
         initialTime: Date = .init()) {
        self.durationType = durationType
        self.presentationType = presentationType
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        loadViewFromNib()
        setupView(with: initialTime)
    }
    
    required init?(coder: NSCoder) {
        self.durationType = .startingTime
        self.presentationType = .editable
        super.init(coder: coder)
        loadViewFromNib()
        setupView(with: .init())
     }
}

// MARK: - Setup Functions

private extension ScaleDurationView {
    func setupView(with initialTime: Date) {
        setupDatePicker(initialTime: initialTime)
        setupTimePicker(initialTime: initialTime)
        setupViewStyle()
        setupLabels()
    }

    func setupDatePicker(initialTime: Date) {
        datePicker.date = initialTime

        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = setupToolbar(forType: .date)
        dateTextField.tintColor = .clear
    }
    
    func setupTimePicker(initialTime: Date) {
        timePicker.date = initialTime
        
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = setupToolbar(forType: .time)
        timeTextField.tintColor = .clear
    }
    
    func setupViewStyle() {
        guard presentationType == .editable else {
            timeTextField.isEnabled = false
            timeTextField.textColor = .textAddShift
            
            dateTextField.isEnabled = false
            dateTextField.textColor = .textAddShift
            return
        }
        switch durationType {
        case .startingTime:
            timeTextField.isEnabled = true
            timeTextField.textColor = .appDarkBlue
            break
        case .endingTime:
            timeTextField.isEnabled = false
            timeTextField.textColor = .textAddShift
            break
        }
    }
    
    func setupLabels() {
        date = Calendar.current.combineTimeFrom(date: timePicker.date,
                                                andDateFrom: datePicker.date)
        label.text = durationType == .startingTime ? LocalizedString.startLabel : LocalizedString.endLabel
    }
    
    func setupToolbar(forType type: PickerType) -> UIToolbar {
        return type == .date ? makeToolbar(with: #selector(self.datePickerDoneTapped)) :
                               makeToolbar(with: #selector(self.timePickerDoneTapped))
    }
    
    func makeToolbar(with selector: Selector) -> UIToolbar {
        let toolBar: UIToolbar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: LocalizedString.doneButton,
                                         style: .done,
                                         target: self,
                                         action: selector)
        
        toolBar.setItems([flexSpace, doneButton], animated: false)
        
        return toolBar
    }
    
    @objc func datePickerDoneTapped() {
        date = Calendar.current.combineTimeFrom(date: timePicker.date, andDateFrom: datePicker.date)
        dateTextField.resignFirstResponder()
        delegate?.dateChangedTo(date: date)
    }
    
    @objc func timePickerDoneTapped(){
        date = Calendar.current.combineTimeFrom(date: timePicker.date, andDateFrom: datePicker.date)
        timeTextField.resignFirstResponder()
        delegate?.hourChangedTo(date: date)
    }
}
