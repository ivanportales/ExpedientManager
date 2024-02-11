//
//  ScaleDetailsViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/24.
//

import Combine
import UIKit

final class ScaleDetailsViewController: UIViewController {
    
    // MARK: - UI
    
    // MARK: - Private Properties
    
    private let viewModel: ScaleDetailsViewModel
    private let router: DeeplinkRouterProtocol
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: - Inits

    init(viewModel: ScaleDetailsViewModel,
         router: DeeplinkRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
//        endingDurationView.datePicker.datePickerMode = .date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestAuthorizationToSendNotifications()
    }
}

// MARK: - Setup Extensions

extension ScaleDetailsViewController {
    private func setupNavigationBar() {
        title = viewModel.state == .fixedScale ? LocalizedString.editShiftTitle : LocalizedString.editOndutyTitle
        
        setupNavigationBarItemOn(position: .right,
                                 withTitle: LocalizedString.saveButton,
                                 color: .appDarkBlue) { [weak self] _ in
            //self?.saveScale()
        }
        
        setupNavigationBarItemOn(position: .right,
                                 withTitle: LocalizedString.deleteTitleText,
                                 color: .red) { [weak self] _ in
            //self?.deleteScale()
        }
    }
    
    @objc private func deleteScale() {
        let alert = UIAlertController(title: LocalizedString.deleteAlertTitle, message: LocalizedString.deleteAlertMsg, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: LocalizedString.yesText, style: .destructive) { [weak self] _ in
            self?.viewModel.delete()
            self?.router.pop()
        }
        let cancelAction = UIAlertAction(title: LocalizedString.noText, style: .default) { [weak self] _ in
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
