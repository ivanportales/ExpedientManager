//
//  ScheduledNotificationListTableView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 31/01/24.
//

import UIKit

protocol ScheduledNotificationListTableViewDelegate: AnyObject {
    func didTapOnItem(_ view: ScheduledNotificationListTableView, item: ScheduledNotification, index: Int)
}

final class ScheduledNotificationListTableView: UITableView {
    
    // MARK: - Exposed Properties
    
    weak var viewDelegate: ScheduledNotificationListTableViewDelegate?
    
    // MARK: - Private Properties
    
    private let emptyListMessage: String
    
    private var scheduledNotifications: [ScheduledNotification] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Inits
    
    init(scheduledNotifications: [ScheduledNotification] = [],
         emptyListMessage: String) {
        self.emptyListMessage = emptyListMessage
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupCell()
        setup(scheduledNotifications: scheduledNotifications)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Exposed Functions
    
    func setup(scheduledNotifications: [ScheduledNotification]) {
        self.scheduledNotifications = scheduledNotifications
    }
}

// MARK: - Setup Functions

private extension ScheduledNotificationListTableView {
    func setupView() {
        backgroundColor = .clear
        separatorColor = .clear
        showsVerticalScrollIndicator = false
        delegate = self
        dataSource = self
    }
    
    func setupCell() {
        register(UINib(nibName: "ScheduledScalesTableViewCell", bundle: nil),
                       forCellReuseIdentifier: ScheduledScalesTableViewCell.cellIdentifier)
        register(UINib(nibName: "EmptyTableViewCell", bundle: nil),
                       forCellReuseIdentifier: EmptyTableViewCell.cellIdentifier)
        rowHeight = 110
    }
}

// MARK: - UITableViewDataSource

extension ScheduledNotificationListTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scheduledNotifications.isEmpty ? 1 : scheduledNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scheduledNotifications.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.cellIdentifier, for: indexPath) as! EmptyTableViewCell
            cell.setupCell(withMessage: emptyListMessage)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduledScalesTableViewCell.cellIdentifier) as! ScheduledScalesTableViewCell
        cell.setDataOf(scheduledNotification: scheduledNotifications[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        viewDelegate?.didTapOnItem(self, item: scheduledNotifications[index], index: index)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.scheduledNotifications.remove(at: indexPath.row)
            if self.scheduledNotifications.isEmpty {
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: - UITableViewDelegate

extension ScheduledNotificationListTableView: UITableViewDelegate {}
