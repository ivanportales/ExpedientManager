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
    private(set) var date: Date = .init() {
        didSet {
            self.dateTextField.text = date.formateDate()
            self.timeTextField.text = date.formatTime()
        }
    }
    
    // MARK: - Private Properties
    
    private let calendarManager: CalendarManagerProtocol
    private var isEditable: Bool
    private let durationType: ScaleDurationType

    // MARK: - Inits
    
    init(durationType: ScaleDurationType,
         isEditable: Bool = true,
         calendarManager: CalendarManagerProtocol = Calendar.current,
         initialTime: Date = .init()) {
        self.durationType = durationType
        self.isEditable = isEditable
        self.calendarManager = calendarManager
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        loadViewFromNib()
        setupView(with: initialTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Only usable via viewCode")
        
    }
    
    // MARK: - Exposed Functions
    
    func set(isEditable: Bool) {
        self.isEditable = isEditable
        setupDateTextField()
    }
}

// MARK: - Setup Functions

private extension ScaleDurationView {
    func setupView(with initialTime: Date) {
        setupDatePicker(initialTime: initialTime)
        setupTimePicker(initialTime: initialTime)
        setupDateTextField()
        setupTimeTextField()
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
    
    func setupDateTextField() {
        dateTextField.isEnabled = isEditable
        dateTextField.textColor = isEditable ? .brand : .text
    }
    
    func setupTimeTextField() {
        switch durationType {
        case .startingTime:
            timeTextField.isEnabled = isEditable
            timeTextField.textColor = isEditable ? .brand : .text
        case .endingTime:
            timeTextField.isEnabled = false
            timeTextField.textColor = .text
        }
    }
    
    func setupLabels() {
        date = calendarManager.combineTimeFrom(timePicker.date,
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
        date = calendarManager.combineTimeFrom(timePicker.date,
                                               andDateFrom: datePicker.date)
        dateTextField.resignFirstResponder()
        delegate?.dateChangedTo(date: date)
    }
    
    @objc func timePickerDoneTapped(){
        date = calendarManager.combineTimeFrom(timePicker.date, 
                                               andDateFrom: datePicker.date)
        timeTextField.resignFirstResponder()
        delegate?.hourChangedTo(date: date)
    }
}
