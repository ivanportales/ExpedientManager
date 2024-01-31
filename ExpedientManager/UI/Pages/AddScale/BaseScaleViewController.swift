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
    
    lazy var scaleTypeSegmentControll: WorkScaleTypeSegmentedControl = {
        let segmentControll = WorkScaleTypeSegmentedControl()
        segmentControll.delegate = self
        
        return segmentControll
    }()
    
    lazy var titleLabel: UILabel = {
        return UIView.makeLabelWith(text: LocalizedString.titleLabel,
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    lazy var titleTextField: TextField = {
        return TextField(placeholder: LocalizedString.nameLabel, 
                         textColor: .textAddShift)
    }()
    
    lazy var notesLabel: UILabel = {
        return UIView.makeLabelWith(text: LocalizedString.notesLabel,
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    lazy var notesTextView: TextView = {
        let textView = TextView(placeholder: LocalizedString.describeHerePlaceholder,
                                textColor: .textAddShift)
        textView.constraintView(height: 85)
        
        return textView
    }()
    
    lazy var durationLabel: UILabel = {
        return UIView.makeLabelWith(text: LocalizedString.durationLabel,
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    lazy var scaleSelectTypeView: ScaleSelectType = {
        return ScaleSelectType()
    }()
    
    lazy var shiftLabel: UILabel = {
        return UIView.makeLabelWith(text: LocalizedString.periodLabel,
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    lazy var scalesSelectionStackContainer: UIStackView = {
        return UIView.makeStackWith(axis: .horizontal,
                                    distribution: .fillEqually)
    }()
    
    lazy var begginingDurationView: ScaleDurationView = {
        let scaleView = ScaleDurationView(durationType: .startingTime)
        scaleView.constraintView(height: 100)
        
        return scaleView
    }()
    
    lazy var endingDurationView: ScaleDurationView = {
        let scaleView = ScaleDurationView(durationType: .endingTime, 
                                          isEditable: true)
        scaleView.constraintView(height: 100)
        
        return scaleView
    }()
    
    lazy var colorSelectionLabel: UILabel = {
        return UIView.makeLabelWith(text: LocalizedString.colorLabel,
                                    font: .poppinsSemiboldOf(size: 16),
                                    color: .textAddShift)
    }()
    
    lazy var scaleSetColorView: ScaleColorSelectionView = {
        let scaleColorView = ScaleColorSelectionView()
        
        return scaleColorView
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: AddScaleViewModel
    private let router: DeeplinkRouterProtocol
    private var subscribers = Set<AnyCancellable>()
    
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
        //hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupViewHierarchy()
        setupConstraints()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestAuthorizationToSendNotifications()
    }
    
    // MARK: - Private Functions
    
    private func saveScale() {
        guard let title = titleTextField.text,
              let notes = notesTextView.text,
              !title.isEmpty else {
            showAlertWith(title: LocalizedString.alertErrorTitle,
                          andMesssage: LocalizedString.alertErrorMsg)
            return
        }
        
        let selectedWorkScale = scaleSelectTypeView.selectedWorkScale

        let scaleOfWork = scaleSelectTypeView.workDuration
        let scaleOfRest = scaleSelectTypeView.restDuration
        let scaleType = scaleSelectTypeView.selectedScaleType

        let initialDate = begginingDurationView.date
        let finalDate = endingDurationView.date
        
        let selectedColor = scaleSetColorView.selectedColor

        if selectedWorkScale == .fixedScale {
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
}

// MARK: - Setup Extensions

extension BaseScaleViewController {
    func setupNavigationBar() {
        title = LocalizedString.addTitle
        setupNavigationBarItemOn(position: .right,
                                 withTitle: LocalizedString.saveButton,
                                 color: .appDarkBlue) { [weak self] _ in
            self?.saveScale()
        }
    }
    
    func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(scaleTypeSegmentControll)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(notesLabel)
        contentView.addSubview(notesTextView)
        contentView.addSubview(durationLabel)
        contentView.addSubview(scaleSelectTypeView)
        contentView.addSubview(scalesSelectionStackContainer)
        contentView.addSubview(shiftLabel)
        scalesSelectionStackContainer.addArrangedSubview(begginingDurationView)
        scalesSelectionStackContainer.addArrangedSubview(endingDurationView)
        contentView.addSubview(colorSelectionLabel)
        contentView.addSubview(scaleSetColorView)
    }
    
    func setupConstraints() {
        scrollView.constraintViewToSuperview()
        contentView.constraintViewToSuperview()
        
        let contentViewHeightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightAnchor.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentViewHeightAnchor,
            
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
            
            scaleSelectTypeView.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10),
            scaleSelectTypeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scaleSelectTypeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            shiftLabel.topAnchor.constraint(equalTo: scaleSelectTypeView.bottomAnchor, constant: 20),
            shiftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            shiftLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            scalesSelectionStackContainer.topAnchor.constraint(equalTo: shiftLabel.bottomAnchor, constant: 10),
            scalesSelectionStackContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scalesSelectionStackContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            colorSelectionLabel.topAnchor.constraint(equalTo: scalesSelectionStackContainer.bottomAnchor, constant: 20),
            colorSelectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            colorSelectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            scaleSetColorView.topAnchor.constraint(equalTo: colorSelectionLabel.bottomAnchor, constant: 10),
            scaleSetColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scaleSetColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            scaleSetColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func setupBindings() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else {return}
                switch state {
                case .initial:
                    break
                case .loading:
                    print("laoding")
                case .errorSavingScale(message: let message):
                    self.showAlertWith(title: LocalizedString.alertErrorTitle, andMesssage: message)
                case .successSavingScale:
                    self.router.pop()
                }
            }.store(in: &subscribers)
    }
}

// MARK: - WorkScaleTypeSegmentedControlDelegate

extension BaseScaleViewController: WorkScaleTypeSegmentedControlDelegate {
    func didChangeSelectedIndex(_ view: WorkScaleTypeSegmentedControl, selectedWorkScale: WorkScaleType) {
        scaleSelectTypeView.selectedWorkScale = selectedWorkScale
        endingDurationView.set(isEditable: selectedWorkScale == .fixedScale)
    }
}
