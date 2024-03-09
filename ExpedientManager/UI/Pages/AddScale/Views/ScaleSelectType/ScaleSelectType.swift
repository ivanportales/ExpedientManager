//
//  ScaleSelectType.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/5/24.
//

import Foundation
import UIKit

protocol ScaleSelectTypeDelegate: AnyObject {
    func workDurarionValueChanged(_ view: ScaleSelectType, workDuration: Int, restDuration: Int)
    func workScaleTypeChanged(_ view: ScaleSelectType, scaleType: WorkScaleType)
}

public enum WorkScaleType: String, CaseIterable {
    case fixedScale, onDuty
    
    var description: String {
        switch self {
        case .fixedScale:
            return LocalizedString.fixedButton
        case .onDuty:
            return LocalizedString.ondutyButton
        }
    }
    
    static let allDescriptions: [String] = allCases.map { $0.description }
}

@IBDesignable
class ScaleSelectType: UIView {
    
    // MARK: - UI
    
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var workDurantionTxtField: UITextField!
    @IBOutlet weak var workDurationTypeTxtField: UITextField!
    @IBOutlet weak var lineSeparatorView: UIView!
    @IBOutlet weak var restLineStackContainer: UIStackView!
    @IBOutlet weak var restTitleLabel: UILabel!
    @IBOutlet weak var restDurationTxtField: UITextField!
    @IBOutlet weak var restDurationTypeLabel: UILabel!
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self

        return pickerView
    }()
    
    // MARK: - Exposed Properties
    
    weak var delegate: ScaleSelectTypeDelegate?
    
    var selectedScaleType: ScaleType = .hour
    
    var selectedWorkScale: WorkScaleType = .fixedScale {
        didSet {
            didChangeWorkScale()
        }
    }
    
    var workDuration: Int {
        return getIntValue(from: workDurantionTxtField)
    }
    var restDuration: Int {
        return getIntValue(from: restDurationTxtField)
    }
    
    // MARK: - Private Properties
    
    private let workDurationArray = [LocalizedString.hoursLabel, LocalizedString.daysLabel]
    
    // MARK: - Inits
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        loadViewFromNib()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        setupView()
    }
    
    // MARK: - Private Functions
    
    private func didChangeWorkScale() {
        switch selectedWorkScale {
        case .fixedScale:
            restLineStackContainer.isHidden = false
            
            workDurationTypeTxtField.isEnabled = true
            workDurationTypeTxtField.textColor = .brand
            restDurationTypeLabel.text = workDurationTypeTxtField.text

            lineSeparatorView.isHidden = false
            
            break
        case .onDuty:
            restLineStackContainer.isHidden = true
            
            workDurationTypeTxtField.isEnabled = false
            workDurationTypeTxtField.textColor = .text2
            workDurationTypeTxtField.text = LocalizedString.hoursLabel
            
            lineSeparatorView.isHidden = true
            
            pickerView.selectRow(0, inComponent: 0, animated: false)
            
            selectedScaleType = .hour
            
            break
        }
    }
    
    private func getIntValue(from textField: UITextField) -> Int {
        guard let valueString = textField.text else {
            return 0
        }
        
        return Int(valueString) ?? 0
    }
}

// MARK: - Setup Functions

extension ScaleSelectType {
    private func setupView() {
        setupTextFields()
        setupToolbar()
        
        restTitleLabel.text = LocalizedString.restForLabel
        workTitleLabel.text = LocalizedString.workForLabel
        workDurationTypeTxtField.text = LocalizedString.hoursLabel
        restDurationTypeLabel.text = LocalizedString.hoursLabel
    }
    
    // TODO: verificar uma forma melhor de fazer isso
    private func setupToolbar() {
        let toolBar: UIToolbar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizedString.doneButton, style: .done, target: self, action: #selector(self.doneTapped))
        
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        workDurationTypeTxtField.inputAccessoryView = toolBar
    }
    
    @objc private func doneTapped() {
        self.workDurationTypeTxtField.resignFirstResponder()
    }
    
    private func setupTextFields() {
        workDurationTypeTxtField.tintColor = .clear
        workDurationTypeTxtField.inputView = pickerView
        workDurantionTxtField.keyboardType = .numberPad
        workDurantionTxtField.delegate = self
        
        restDurationTxtField.keyboardType = .numberPad
        restDurationTxtField.delegate = self
    }
}

// MARK: - UIPickerViewDataSource

extension ScaleSelectType: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workDurationArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workDurationArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedScaleType = row == 0 ? .hour : .day
        workDurationTypeTxtField.text = workDurationArray[row]
        restDurationTypeLabel.text = workDurationArray[row]
    }
}

// MARK: - UITextFieldDelegate

extension ScaleSelectType: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
}
