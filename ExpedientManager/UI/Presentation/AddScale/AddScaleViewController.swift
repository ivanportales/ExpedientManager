//
//  AddScaleViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/28/24.
//

import Combine
import Foundation
import UIKit

final class AddScaleViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var scaleSelectType: ScaleSelectType!
    @IBOutlet weak var begginingDurationView: ScaleDurationView!
    @IBOutlet weak var endingDurationView: ScaleDurationView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var scrollView: ScrollToKeyboardAvoiding!
    @IBOutlet weak var scaleButton: UIButton!
    @IBOutlet weak var onDutyButton: UIButton!
    @IBOutlet weak var scaleSelectTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var scaleSetColorView: ScaleSetColorView!
    @IBOutlet weak var shiftLabel: UILabel!
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var subscribers = Set<AnyCancellable>()
    private let viewModel: AddScaleViewModel
    private let router: DeeplinkRouterProtocol
    
    // MARK: - Inits
    
    init(viewModel: AddScaleViewModel,
         router: DeeplinkRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupBindings()
        setupUI()
//        endingDurationView.datePicker.datePickerMode = .date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestAuthorizationToSendNotifications()
    }
}

// MARK: - Setup Functions

extension AddScaleViewController {
    private func setupUI(){
        notesTextView.delegate = self
        notesTextView.text = LocalizedString.describeHerePlaceholder
        notesTextView.autocapitalizationType = .sentences
        notesTextView.textColor = UIColor.init(named: "placeholderColor")
        
        scaleSelectType.delegate = self
        begginingDurationView.delegate = self
        
        localizeLabels()
    }
    
    private func setupNavigationBar() {
        self.title = LocalizedString.addTitle
        let saveButton = UIBarButtonItem(title: LocalizedString.saveButton, style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveScale))
        saveButton.setTitleTextAttributes([.font: UIFont(name: "Poppins-SemiBold", size: 16)!], for: .normal)
        navigationItem.setRightBarButtonItems([saveButton], animated: true)
    }
    
    private func localizeLabels() {
        shiftLabel.text = LocalizedString.shiftLabel
        activitiesLabel.text = LocalizedString.durationLabel
        durationLabel.text = LocalizedString.periodLabel
        colorLabel.text = LocalizedString.colorLabel
        notesLabel.text = LocalizedString.notesLabel
        titleTextField.placeholder = LocalizedString.nameLabel
        titleTextField.autocapitalizationType = .words
        scaleButton.setTitle(LocalizedString.fixedButton, for: .normal)
        onDutyButton.setTitle(LocalizedString.ondutyButton, for: .normal)
        
        let scaleButtonAttributed = NSAttributedString(string: LocalizedString.fixedButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "brandingColor") as Any])
        scaleButton.setAttributedTitle(scaleButtonAttributed, for: .normal)
        
        let onDutyButtonAttributed = NSAttributedString(string: LocalizedString.ondutyButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "placeholderColor") as Any])
        onDutyButton.setAttributedTitle(onDutyButtonAttributed, for: .normal)
    }
    
    @objc private func saveScale() {
        guard let scaleTypeString = scaleSelectType.workDurationTypeTxtField.text,
              let scaleType: ScaleType = (scaleTypeString == LocalizedString.daysLabel ? .day: .hour),
              let notesText = notesTextView.text,
              let notes = (notesText == LocalizedString.describeHerePlaceholder) ? "": notesTextView.text,
              let scaleOfWork = Int(scaleSelectType.workDurantionTxtField.text!),
              let scaleOfRest = Int(scaleSelectType.restDurationTxtField.text!),
              let title = titleTextField.text
        else {
            showAlertWith(title: LocalizedString.alertErrorTitle, andMesssage: "")
            return
        }
        
        let selectedColor = scaleSetColorView.selectedColor
        let initialDate = begginingDurationView.date
        let finalDate = endingDurationView.date
            
        if title.isEmpty || selectedColor == .clear {
            showAlertWith(title: LocalizedString.alertErrorTitle, andMesssage: LocalizedString.alertErrorMsg)
            return 
        }
        
        if viewModel.state == .fixedScale {
            viewModel.save(
                fixedScale: .init(
                    id: UUID().uuidString,
                    title: title,
                    scale: .init(type: scaleType, scaleOfWork: scaleOfWork, scaleOfRest: scaleOfRest),
                    initialDate: initialDate,
                    finalDate: finalDate,
                    annotation: notes,
                    colorHex: selectedColor.hex
                ))
        } else {
            viewModel.save(
                onDuty: .init(
                    id: UUID().uuidString,
                    title: title,
                    initialDate: initialDate,
                    hoursDuration: scaleOfWork,
                    annotation: notes,
                    colorHex: selectedColor.hex
                ))
        }
    }
    
    private func setupBindings() {
        viewModel
            .$isLoading
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] value in
                guard let self = self else {return}
                if value {
                    self.showSpinner(onView: self.view)
                } else {
                    self.removeSpinner()
                    self.router.pop()
                }
            }.store(in: &subscribers)
        
        viewModel
            .$initialDutyDate
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] date in
                guard let self = self else {return}
                guard let durationString = self.scaleSelectType.workDurantionTxtField.text, let duration = Int(durationString) else { return }
                self.viewModel.calculateFinalDutyDateFrom(date: date, withDuration: duration)
            }.store(in: &subscribers)
        
        viewModel
            .$finalDutyDate
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] date in
                guard let self = self else {return}
                self.endingDurationView.setDateLabelWith(date: date)
                self.endingDurationView.setTimeLabelWith(date: date)
            }.store(in: &subscribers)
    }
}

extension AddScaleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.textColor == UIColor.init(named: "placeholderColor") {
            notesTextView.text = nil
            notesTextView.textColor = UIColor.init(named: "textAddShiftColor")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextView.text.isEmpty {
            notesTextView.text = LocalizedString.describeHerePlaceholder
            notesTextView.textColor = UIColor.init(named: "placeholderColor")
        }
    }
}

extension AddScaleViewController {
    @IBAction func segmentedButtonTapped(sender: UIButton){
        if sender == onDutyButton {
            //onDutyButton
            viewModel.changeViewStateTo(state: .onDuty)
            onDutyButton.borderColor = UIColor.init(named: "brandingColor")
            let onDutyButtonAttributed = NSAttributedString(string: LocalizedString.ondutyButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "brandingColor") as Any])
            onDutyButton.setAttributedTitle(onDutyButtonAttributed, for: .normal)
            
            //ScaleButton
            scaleButton.borderColor = UIColor.init(named: "placeholderColor")
            let scaleButtonAttributed = NSAttributedString(string: LocalizedString.fixedButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "placeholderColor") as Any])
            scaleButton.setAttributedTitle(scaleButtonAttributed, for: .normal)
            
            scaleSelectType.restDurationTypeLabel.isHidden = true
            scaleSelectType.restDurationTxtField.isHidden = true
            scaleSelectType.restTitleLabel.isHidden = true
            scaleSelectType.lineSeparatorView.isHidden = true
            scaleSelectTypeHeight.constant = 45
            
            scaleSelectType.workDurationTypeTxtField.isEnabled = false
            scaleSelectType.workDurationTypeTxtField.textColor = .textColor
            scaleSelectType.workDurationTypeTxtField.text = LocalizedString.hoursLabel
            
            endingDurationView.dateTextField.isEnabled = false
            endingDurationView.dateTextField.textColor = UIColor(named: "textAddShiftColor")
            
        } else if sender == scaleButton {
            //ScaleButton
            viewModel.changeViewStateTo(state: .fixedScale)
            scaleButton.borderColor = UIColor.init(named: "brandingColor")
            let scaleButtonAttributed = NSAttributedString(string: LocalizedString.fixedButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "brandingColor") as Any])
            scaleButton.setAttributedTitle(scaleButtonAttributed, for: .normal)
            
            //OnDutyButton
            onDutyButton.borderColor = UIColor.init(named: "placeholderColor")
            let onDutyButtonAttributed = NSAttributedString(string: LocalizedString.ondutyButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "placeholderColor") as Any])
            onDutyButton.setAttributedTitle(onDutyButtonAttributed, for: .normal)
            
            endingDurationView.dateTextField.isEnabled = true
            endingDurationView.dateTextField.textColor = UIColor(named: "brandingColor")
            
            scaleSelectType.workDurationTypeTxtField.isEnabled = true
            scaleSelectType.workDurationTypeTxtField.textColor = .appDarkBlue
            scaleSelectType.restDurationTypeLabel.text = scaleSelectType.workDurationTypeTxtField.text
            
            scaleSelectType.restDurationTypeLabel.isHidden = false
            scaleSelectType.restDurationTxtField.isHidden = false
            scaleSelectType.restTitleLabel.isHidden = false
            scaleSelectType.lineSeparatorView.isHidden = false
            scaleSelectTypeHeight.constant = 91
        }
    }
}

extension AddScaleViewController: ScaleDurationViewDelegate {
    func hourChangedTo(date: Date) {
        if viewModel.state == .onDuty {
            viewModel.setInitialDutyDate(date)
        }
    }
    
    func dateChangedTo(date: Date) {
        if viewModel.state == .onDuty {
            viewModel.setInitialDutyDate(date)
        }
    }
}

extension AddScaleViewController: ScaleSelectTypeDelegate {
    func workDurarionValueChanged() {
        print("")
    }
    
    func workDurationTypeChanged() {
        print("")
    }
}
