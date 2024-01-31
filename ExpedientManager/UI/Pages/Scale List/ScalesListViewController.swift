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
    
    lazy var scalesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "ScheduledScalesTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduledScalesTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 0
        
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
                    self.scalesTableView.reloadData()
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
                self.scalesTableView.reloadData()
            }.store(in: &subscribers)
    }
}

// MARK: - UITableViewDelegate

extension ScalesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.selectedWorkScale == .fixedScale ? viewModel.fixedScales.count : viewModel.onDuties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduledScalesTableViewCell.cellIdentifier) as! ScheduledScalesTableViewCell
        
        if viewModel.selectedWorkScale == .fixedScale {
            let scale = viewModel.fixedScales[indexPath.item]
            
            let model: ScheduledNotification = .init(
                uid: scale.id,
                title: scale.title!,
                description: scale.annotation!,
                date: scale.initialDate!,
                scaleUid: scale.id,
                colorHex: scale.colorHex!)
            cell.setDataOf(scheduledNotification: model)
                    
        } else {
            let scale = viewModel.onDuties[indexPath.item]
            let model: ScheduledNotification = .init(
                uid: scale.id,
                title: scale.titlo,
                description: scale.annotation!,
                date: scale.initialDate,
                scaleUid: scale.id,
                colorHex: scale.colorHex!)
            cell.setDataOf(scheduledNotification: model)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state: WorkScaleType = viewModel.selectedWorkScale
        var fixedScale: FixedScale? = nil
        var onDuty: OnDuty? = nil
        
        if state == .fixedScale {
            fixedScale = viewModel.fixedScales[indexPath.item]
        } else {
            onDuty = viewModel.onDuties[indexPath.item]
        }
        
        router.route(to: .scaleDetails,
                     withParams: [
                        "workScaleType": state,
                        "selectedFixedScale": fixedScale as Any,
                        "selectedOnDuty": onDuty as Any
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
