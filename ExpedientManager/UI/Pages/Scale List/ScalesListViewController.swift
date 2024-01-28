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
    
    lazy var fixedScalesLAbel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LocalizedString.fixedButton
        label.font = .poppinsMediumOf(size: 16)
        label.textColor = .textColor
        
        return label
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
    
    lazy var onDutyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
       // label.backgroundColor = .green
        label.text = LocalizedString.ondutyButton
        label.font = .poppinsMediumOf(size: 16)
        label.textColor = .textColor
        
        return label
    }()
    
    lazy var onDutyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "ScheduledScalesTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduledScalesTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
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
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllScales()
    }
}

extension ScalesListViewController {
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        title = LocalizedString.listTitleView
    }
    
    private func setupUI() {
        setupViewHierarchy()
        setupViewsConstraints()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(fixedScalesLAbel)
        view.addSubview(scalesTableView)
        view.addSubview(onDutyLabel)
        view.addSubview(onDutyTableView)
    }
    
    private func setupViewsConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            fixedScalesLAbel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            fixedScalesLAbel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            fixedScalesLAbel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            scalesTableView.topAnchor.constraint(equalTo: fixedScalesLAbel.bottomAnchor, constant: 10),
            scalesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            scalesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            scalesTableView.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            onDutyLabel.topAnchor.constraint(equalTo: scalesTableView.bottomAnchor, constant: 5),
            onDutyLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            onDutyLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            onDutyTableView.topAnchor.constraint(equalTo: onDutyLabel.bottomAnchor, constant: 10),
            onDutyTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            onDutyTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            onDutyTableView.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
    
    private func updateUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        if viewModel.fixedScales.isEmpty {
            fixedScalesLAbel.removeFromSuperview()
            scalesTableView.removeFromSuperview()
            onDutyLabel.removeFromSuperview()
            onDutyTableView.removeFromSuperview()
            
            view.addSubview(onDutyLabel)
            view.addSubview(onDutyTableView)
            
            NSLayoutConstraint.activate([
                onDutyLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
                onDutyLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                onDutyLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                
                onDutyTableView.topAnchor.constraint(equalTo: onDutyLabel.bottomAnchor, constant: 10),
                onDutyTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                onDutyTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                onDutyTableView.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: -8)
            ])
        } else if viewModel.onDuties.isEmpty {
            fixedScalesLAbel.removeFromSuperview()
            scalesTableView.removeFromSuperview()
            onDutyLabel.removeFromSuperview()
            onDutyTableView.removeFromSuperview()
            
            view.addSubview(fixedScalesLAbel)
            view.addSubview(scalesTableView)
            
            NSLayoutConstraint.activate([
                fixedScalesLAbel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
                fixedScalesLAbel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                fixedScalesLAbel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                
                scalesTableView.topAnchor.constraint(equalTo: fixedScalesLAbel.bottomAnchor, constant: 10),
                scalesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                scalesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                scalesTableView.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: -8)
            ])
        }
    }
   
    private func setupBindings() {
        viewModel
            .$fixedScales
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.scalesTableView.reloadData()
            }.store(in: &subscribers)
        
        viewModel
            .$onDuties
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.onDutyTableView.reloadData()
                self.updateUI()
            }.store(in: &subscribers)
    }
}

// MARK: - UITableViewDelegate

extension ScalesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView == scalesTableView ? viewModel.fixedScales.count : viewModel.onDuties.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduledScalesTableViewCell.cellIdentifier) as! ScheduledScalesTableViewCell
        
        if tableView == scalesTableView {
            let scale = viewModel.fixedScales[indexPath.section]
            
            let model: ScheduledNotification = .init(
                uid: scale.id,
                title: scale.title!,
                description: scale.annotation!,
                date: scale.initialDate!,
                scaleUid: scale.id,
                colorHex: scale.colorHex!)
            cell.setDataOf(scheduledNotification: model)
                    
        } else {
            let scale = viewModel.onDuties[indexPath.section]
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
        var state: WorkScaleType = .fixedScale
        var fixedScale: FixedScale? = nil
        var onDuty: OnDuty? = nil
        
        if tableView == scalesTableView {
            fixedScale = viewModel.fixedScales[indexPath.section]
        } else {
            state = .onDuty
            onDuty = viewModel.onDuties[indexPath.section]
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
