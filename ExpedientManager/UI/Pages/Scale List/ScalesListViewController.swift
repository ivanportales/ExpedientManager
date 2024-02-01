//
//  ScalesListViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/12/24.
//

import Combine
import UIKit

final class ScalesListViewController: UIViewController {
    
    // MARK: - UI
    
    lazy var scaleTypeSegmentControll: WorkScaleTypeSegmentedControl = {
        let segmentControll = WorkScaleTypeSegmentedControl()
        segmentControll.delegate = self
        
        return segmentControll
    }()
    
    lazy var scalesTableView: ScheduledNotificationListTableView = {
        let tableView = ScheduledNotificationListTableView()
        tableView.viewDelegate = self
        
        return tableView
    }()
    
    // MARK: - Private Properties

    private let viewModel: ScalesListViewModel
    private let router: DeeplinkRouterProtocol
    private var subscribers: Set<AnyCancellable> = []
    
    // MARK: - Inits
    
    init(viewModel: ScalesListViewModel,
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
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupViewHierarchy()
        setupViewsConstraints()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllScales()
    }
}

// MARK: - Setup Functions

extension ScalesListViewController {
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        title = ""
    }
    
    private func setupViewHierarchy() {
        view.addSubview(scaleTypeSegmentControll)
        view.addSubview(scalesTableView)
    }
    
    private func setupViewsConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scaleTypeSegmentControll.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            scaleTypeSegmentControll.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            scaleTypeSegmentControll.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            scalesTableView.topAnchor.constraint(equalTo: scaleTypeSegmentControll.bottomAnchor, constant: 20),
            scalesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            scalesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            scalesTableView.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupBindings() {
        viewModel
            .$state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .initial:
                    break
                case .loading:
                    print("loading")
                case .content:
                    self.scalesTableView.setup(scheduledNotifications: viewModel.scheduledNotifications)
                case .error(message: let message):
                    self.showAlertWith(title: LocalizedString.alertErrorTitle, andMesssage: message)
                }
            }.store(in: &subscribers)
        
        viewModel
            .$selectedWorkScale
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedWorkScale in
                guard let self = self else { return }
                self.title = selectedWorkScale.description
                self.scalesTableView.setup(scheduledNotifications: viewModel.scheduledNotifications)
            }.store(in: &subscribers)
    }
}

// MARK: - WorkScaleTypeSegmentedControlDelegate

extension ScalesListViewController: ScheduledNotificationListTableViewDelegate {
    func didTapOnItem(_ view: ScheduledNotificationListTableView, item: ScheduledNotification, index: Int) {
        let state: WorkScaleType = viewModel.selectedWorkScale

         router.route(to: .scaleDetails,
                      withParams: [
                         "workScaleType": state,
                         "selectedFixedScale": item,
                         "selectedOnDuty": item
                      ]
         )
    }
}

// MARK: - WorkScaleTypeSegmentedControlDelegate

extension ScalesListViewController: WorkScaleTypeSegmentedControlDelegate {
    func didChangeSelectedIndex(_ view: WorkScaleTypeSegmentedControl, selectedWorkScale: WorkScaleType) {
        viewModel.selectedWorkScale = selectedWorkScale
    }
}
