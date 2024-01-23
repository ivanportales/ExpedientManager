//
//  BaseScaleViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/01/24.
//

import Combine
import UIKit

class BaseScaleViewController: UIViewController {
    
    // MARK: - UI
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white

        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        return contentView
    }()
    
    lazy var scaleTypeSegmentControll: UISegmentedControl = {
        let segmentControll = UISegmentedControl()
        segmentControll.translatesAutoresizingMaskIntoConstraints = false
        segmentControll.insertSegment(withTitle: "Escala Fixa", at: 0, animated: false)
        segmentControll.insertSegment(withTitle: "Plantão", at: 1, animated: false)
        
        return segmentControll
    }()
    
    lazy var titleLabel: UILabel = {
        return UIView.makeLabelWith(text: "Título",
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    lazy var titleTextField: TextField = {
        return TextField(placeholder: LocalizedString.nameLabel, 
                         textColor: .textAddShift)
    }()
    
    lazy var notesLabel: UILabel = {
        return UIView.makeLabelWith(text: "Notas",
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    lazy var notesTextView: TextView = {
        let textView = TextView(placeholder: "Descreva Aqui...",
                                textColor: .textAddShift)
        textView.constraintView(height: 85)
        
        return textView
    }()
    
    lazy var durationLabel: UILabel = {
        return UIView.makeLabelWith(text: "Duração",
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    
//    @IBOutlet weak var scaleSelectType: ScaleSelectType!
//    @IBOutlet weak var begginingDurationView: ScaleDurationView!
//    @IBOutlet weak var endingDurationView: ScaleDurationView!
//    @IBOutlet weak var scrollView: ScrollToKeyboardAvoiding!
//    @IBOutlet weak var scaleButton: UIButton!
//    @IBOutlet weak var onDutyButton: UIButton!
//    @IBOutlet weak var scaleSelectTypeHeight: NSLayoutConstraint!
//    @IBOutlet weak var scaleSetColorView: ScaleSetColorView!
//    
//    @IBOutlet weak var shiftLabel: UILabel!
//    @IBOutlet weak var activitiesLabel: UILabel!
//    @IBOutlet weak var durationLabel: UILabel!
//    @IBOutlet weak var colorLabel: UILabel!
    
    // MARK: - Private Properties
    
//    private let viewModel: ScaleDetailsViewModel
//    private let router: DeeplinkRouterProtocol
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: - Inits

//    init(viewModel: ScaleDetailsViewModel,
//         router: DeeplinkRouterProtocol) {
//        self.viewModel = viewModel
//        self.router = router
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupViewHierarchy()
        setupConstraints()
//        setupBindings()
//        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // viewModel.requestAuthorizationToSendNotifications()
    }
}

// MARK: - Setup Extensions

extension BaseScaleViewController {
    func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(scaleTypeSegmentControll)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(notesLabel)
        contentView.addSubview(notesTextView)
        contentView.addSubview(durationLabel)
    }
    
    func setupConstraints() {
        scrollView.constraintViewToSuperview()
        contentView.constraintViewToSuperview()
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 2),
            
            scaleTypeSegmentControll.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            scaleTypeSegmentControll.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scaleTypeSegmentControll.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: scaleTypeSegmentControll.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            notesLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            notesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            notesTextView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 10),
            notesTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            notesTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            durationLabel.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 20),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            durationLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),

        ])
    }
}

// MARK: - UITextViewDelegate

extension BaseScaleViewController: UITextViewDelegate {
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

//// MARK: - Setup Extensions
//
extension BaseScaleViewController {
    internal func setupNavigationBar() {
        title = "Adicionar"
    }
}
//    private func setupUI(){
//        r
////        
////        scaleSelectType.delegate = self
////        begginingDurationView.delegate = self
//        
//        localizeLabels()
//        setupRightScaleUI()
//    }
//    

//    
//    private func localizeLabels() {
//        shiftLabel.text = LocalizedString.shiftLabel
//        activitiesLabel.text = LocalizedString.durationLabel
//        durationLabel.text = LocalizedString.periodLabel
//        colorLabel.text = LocalizedString.colorLabel
//        notesLabel.text = LocalizedString.notesLabel
//        titleTextField.placeholder = LocalizedString.nameLabel
//        titleTextField.autocapitalizationType = .words
//        scaleButton.setTitle(LocalizedString.fixedButton, for: .normal)
//        onDutyButton.setTitle(LocalizedString.ondutyButton, for: .normal)
//        
//        let scaleButtonAttributed = NSAttributedString(string: LocalizedString.fixedButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "brandingColor") as Any])
//        scaleButton.setAttributedTitle(scaleButtonAttributed, for: .normal)
//        
//        let onDutyButtonAttributed = NSAttributedString(string: LocalizedString.ondutyButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "placeholderColor") as Any])
//        
//        onDutyButton.setAttributedTitle(onDutyButtonAttributed, for: .normal)
//    }
//    
//    @objc private func deleteScale() {
//        let alert = UIAlertController(title: LocalizedString.deleteAlertTitle, message: LocalizedString.deleteAlertMsg, preferredStyle: .alert)
//        let deleteAction = UIAlertAction(title: LocalizedString.yesText, style: .destructive) { [weak self] _ in
//            self?.viewModel.delete()
//            self?.router.pop()
//        }
//        let cancelAction = UIAlertAction(title: LocalizedString.noText, style: .default) { [weak self] _ in
//        }
//        
//        alert.addAction(deleteAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    @objc private func saveScale() {
//        guard let scaleTypeString = scaleSelectType.workDurationTypeTxtField.text,
//              let scaleType: ScaleType = (scaleTypeString == LocalizedString.daysLabel ? .day: .hour),
//              let notesText = notesTextView.text,
//              let notes = (notesText == LocalizedString.describeHerePlaceholder) ? "": notesTextView.text,
//              let scaleOfWork = Int(scaleSelectType.workDurantionTxtField.text!),
//              let scaleOfRest = Int(scaleSelectType.restDurationTxtField.text!),
//              let title = titleTextField.text
//        else {
//            showAlertWith(title: LocalizedString.alertErrorTitle, andMesssage: "")
//            return
//        }
//        
//        let selectedColor = scaleSetColorView.selectedColor
//        let initialDate = begginingDurationView.date
//        let finalDate = endingDurationView.date
//            
//        if title.isEmpty || selectedColor == .clear {
//            showAlertWith(title: LocalizedString.alertErrorTitle, andMesssage: LocalizedString.alertErrorMsg)
//            return
//        }
//        
//        // TODO AQUI MUDAR PRA PEGAR NO INIT O ITEM PRA FAZER UPDATE
//        if viewModel.state == .fixedScale {
//            viewModel.selectedFixedScale!.title = title
//            viewModel.selectedFixedScale!.annotation = notes
//            viewModel.selectedFixedScale!.colorHex = selectedColor.hex
//            viewModel.selectedFixedScale!.initialDate = initialDate
//            viewModel.selectedFixedScale!.finalDate = finalDate
//            viewModel.selectedFixedScale!.scale!.type = scaleType
//            viewModel.selectedFixedScale!.scale!.scaleOfWork = scaleOfWork
//            viewModel.selectedFixedScale!.scale!.scaleOfRest = scaleOfRest
//        } else {
//            viewModel.selectedOnDuty!.titlo = title
//            viewModel.selectedOnDuty!.annotation = notes
//            viewModel.selectedOnDuty!.colorHex = selectedColor.hex
//            viewModel.selectedOnDuty!.initialDate = initialDate
//            viewModel.selectedOnDuty!.hoursDuration = scaleOfWork
//        }
//        
//        viewModel.update()
//        router.pop()
//    }
//    
//    private func setupBindings() {
//        viewModel
//            .$isLoading
//            .receive(on: DispatchQueue.main)
//            .dropFirst()
//            .sink { [weak self] value in
//                guard let self = self else {return}
//                if value {
//                    self.showSpinner(onView: self.view)
//                } else {
//                    self.removeSpinner()
//                    self.router.pop()
//                }
//            }.store(in: &subscribers)
//        
//        viewModel
//            .$initialDutyDate
//            .receive(on: DispatchQueue.main)
//            .dropFirst()
//            .sink { [weak self] date in
//                guard let self = self else {return}
//                guard let durationString = self.scaleSelectType.workDurantionTxtField.text, let duration = Int(durationString) else { return }
//                self.viewModel.calculateFinalDutyDateFrom(date: date, withDuration: duration)
//            }.store(in: &subscribers)
//        
//        viewModel
//            .$finalDutyDate
//            .receive(on: DispatchQueue.main)
//            .dropFirst()
//            .sink { [weak self] date in
//                guard let self = self else {return}
//                self.endingDurationView.setDateLabelWith(date: date)
//                self.endingDurationView.setTimeLabelWith(date: date)
//            }.store(in: &subscribers)
//    }
//}
//
//
//extension BaseScaleViewController {
//    private func setupRightScaleUI(){
//        if viewModel.state == .onDuty {
//            //onDutyButton
//            //viewModel.changeViewStateTo(state: .onDuty)
//            onDutyButton.borderColor = UIColor.init(named: "brandingColor")
//            let onDutyButtonAttributed = NSAttributedString(string: LocalizedString.ondutyButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "brandingColor") as Any])
//            onDutyButton.setAttributedTitle(onDutyButtonAttributed, for: .normal)
//            
//            //ScaleButton
//            scaleButton.borderColor = UIColor.init(named: "placeholderColor")
//            let scaleButtonAttributed = NSAttributedString(string: LocalizedString.fixedButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "placeholderColor") as Any])
//            scaleButton.setAttributedTitle(scaleButtonAttributed, for: .normal)
//            
//            scaleSelectType.restDurationTypeLabel.isHidden = true
//            scaleSelectType.restDurationTxtField.isHidden = true
//            scaleSelectType.restTitleLabel.isHidden = true
//            scaleSelectType.lineSeparatorView.isHidden = true
//            scaleSelectTypeHeight.constant = 45
//            scaleSelectType.workDurationTypeTxtField.isEnabled = false
//            scaleSelectType.workDurationTypeTxtField.textColor = .textColor
//            
//            endingDurationView.dateTextField.isEnabled = false
//            endingDurationView.dateTextField.textColor = UIColor(named: "textAddShiftColor")
//            
//            titleTextField.text = viewModel.selectedOnDuty!.titlo
//            notesTextView.text = viewModel.selectedOnDuty!.annotation
//            scaleSelectType.workDurantionTxtField.text = String(viewModel.selectedOnDuty!.hoursDuration)
//            
//            let selecteddColor = UIColor(hex: viewModel.selectedOnDuty!.colorHex!)
//            scaleSetColorView.selectedColor = UIColor(hex: viewModel.selectedOnDuty!.colorHex!)
//            scaleSetColorView.setColor(.init(rawValue: selecteddColor)!)
//            
//            begginingDurationView.date = viewModel.selectedOnDuty!.initialDate
//            begginingDurationView.datePicker.date = viewModel.selectedOnDuty!.initialDate
//            begginingDurationView.timePicker.date = viewModel.selectedOnDuty!.initialDate
//            begginingDurationView.setDateLabelWith(date: viewModel.selectedOnDuty!.initialDate)
//            begginingDurationView.setTimeLabelWith(date: viewModel.selectedOnDuty!.initialDate)
//            
//        } else if viewModel.state == .fixedScale {
//            //ScaleButton
//            //viewModel.changeViewStateTo(state: .fixedScale)
//            scaleButton.borderColor = UIColor.init(named: "brandingColor")
//            let scaleButtonAttributed = NSAttributedString(string: LocalizedString.fixedButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "brandingColor") as Any])
//            scaleButton.setAttributedTitle(scaleButtonAttributed, for: .normal)
//            
//            //OnDutyButton
//            onDutyButton.borderColor = UIColor.init(named: "placeholderColor")
//            let onDutyButtonAttributed = NSAttributedString(string: LocalizedString.ondutyButton, attributes: [.font: UIFont(name: "Poppins-Regular", size: 18) as Any, .foregroundColor: UIColor.init(named: "placeholderColor") as Any])
//            onDutyButton.setAttributedTitle(onDutyButtonAttributed, for: .normal)
//            
//            endingDurationView.dateTextField.isEnabled = true
//            endingDurationView.dateTextField.textColor = UIColor(named: "brandingColor")
//            
//            scaleSelectType.restDurationTypeLabel.isHidden = false
//            scaleSelectType.restDurationTxtField.isHidden = false
//            scaleSelectType.restTitleLabel.isHidden = false
//            scaleSelectType.lineSeparatorView.isHidden = false
//            scaleSelectTypeHeight.constant = 91
//            
//            titleTextField.text = viewModel.selectedFixedScale!.title
//            notesTextView.text = viewModel.selectedFixedScale!.annotation
//            
//            guard let scaleDurationType: ScaleType = viewModel.selectedFixedScale?.scale?.type else {return}
//            scaleSelectType.workDurationTypeTxtField.text = scaleDurationType == .day ? LocalizedString.daysLabel : LocalizedString.hoursLabel
//            scaleSelectType.restDurationTypeLabel.text = scaleDurationType == .day ? LocalizedString.daysLabel : LocalizedString.hoursLabel
//            scaleSelectType.workDurantionTxtField.text = String(viewModel.selectedFixedScale!.scale!.scaleOfWork)
//            scaleSelectType.restDurationTxtField.text = String(viewModel.selectedFixedScale!.scale!.scaleOfRest)
//            
//            let selecteddColor = UIColor(hex: viewModel.selectedFixedScale!.colorHex!)
//            scaleSetColorView.setColor(.init(rawValue: selecteddColor)!)
//            scaleSetColorView.selectedColor = UIColor(hex: viewModel.selectedFixedScale!.colorHex!)
//           
//            begginingDurationView.date = viewModel.selectedFixedScale!.initialDate!
//            begginingDurationView.datePicker.date = viewModel.selectedFixedScale!.initialDate!
//            begginingDurationView.timePicker.date = viewModel.selectedFixedScale!.initialDate!
//            begginingDurationView.setDateLabelWith(date: viewModel.selectedFixedScale!.initialDate!)
//            begginingDurationView.setTimeLabelWith(date: viewModel.selectedFixedScale!.initialDate!)
//            
//            endingDurationView.date = viewModel.selectedFixedScale!.finalDate!
//            endingDurationView.datePicker.date = viewModel.selectedFixedScale!.finalDate!
//            endingDurationView.timePicker.date = viewModel.selectedFixedScale!.finalDate!
//            endingDurationView.setDateLabelWith(date: viewModel.selectedFixedScale!.finalDate!)
//            endingDurationView.setTimeLabelWith(date: viewModel.selectedFixedScale!.finalDate!)
//        }
//    }
//    
//    @IBAction func segmentedButtonTapped(sender: UIButton){
//    }
//}
//

//extension BaseScaleViewController: ScaleDurationViewDelegate {
//    func hourChangedTo(date: Date) {
//        if viewModel.state == .onDuty {
//            viewModel.setInitialDutyDate(date)
//        }
//    }
//    
//    func dateChangedTo(date: Date) {
//        if viewModel.state == .onDuty {
//            viewModel.setInitialDutyDate(date)
//        }
//    }
//}
//
//extension BaseScaleViewController: ScaleSelectTypeDelegate {
//    func workDurarionValueChanged() {
//        print("")
//    }
//    
//    func workDurationTypeChanged() {
//        print("")
//    }
//}
