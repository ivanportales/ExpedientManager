//
//  ScaleSelectType.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/5/24.
//

import Foundation
import UIKit

class ScaleSelectTypeView: UIView {
    
    @IBOutlet weak var workDurantionTxtField: UITextField!
    @IBOutlet weak var workDurationTypeTxtField: UITextField!
    @IBOutlet weak var restDurationTxtField: UITextField!
    @IBOutlet weak var restDurationTypeLabel: UILabel!
    
    let workDurationArray = ["Dia(s)", "Hora(s)"]
    let pickerView: UIPickerView = UIPickerView()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        setupUI()
    }
}

extension ScaleSelectTypeView {
    
    private func setupUI() {
        setupPickerView()
        setupTextFields()
        setupKeyboard()
        setupToolbar()
    }
    
    private func setupToolbar() {
        let toolBar: UIToolbar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Feito", style: .done, target: self, action: #selector(self.doneTapped))
        
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        workDurationTypeTxtField.inputAccessoryView = toolBar
    }
    
    
    @objc private func doneTapped() {
        self.workDurationTypeTxtField.resignFirstResponder()
    }
    
    private func loadView() {
        let bundle = Bundle(for: ScaleSelectTypeView.self)
        let nib = UINib(nibName: "ScaleSelectType", bundle: bundle)
        let view = nib.instantiate(withOwner: self).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func setupTextFields() {
        workDurantionTxtField.delegate = self
        restDurationTxtField.delegate = self
        
        workDurationTypeTxtField.inputView = pickerView
    }
    
    private func setupKeyboard() {
        workDurantionTxtField.keyboardType = .numberPad
        restDurationTxtField.keyboardType = .numberPad
    }
}

extension ScaleSelectTypeView: UIPickerViewDataSource, UIPickerViewDelegate {
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
        workDurationTypeTxtField.text = workDurationArray[row]
        restDurationTypeLabel.text = workDurationArray[row]
    }
}

extension ScaleSelectTypeView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
