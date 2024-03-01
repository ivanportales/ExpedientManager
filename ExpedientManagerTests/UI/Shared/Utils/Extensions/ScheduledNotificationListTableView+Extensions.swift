//
//  ScheduledNotificationListTableView+Extensions.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 26/02/24.
//

@testable import ExpedientManager
import UIKit

extension ScheduledNotificationListTableView {
    func isScheduledListInEmptyState() -> Bool {
        guard numberOfRows(inSection: 0) == 1 else {
            return false
        }
        if let _ = cellForRow(at: IndexPath(item: 0, section: 0)) as? EmptyTableViewCell {
            return true
        }
        return false
    }
    
    func displayedDateOnActivitiesView(atIndex index: Int) -> String {
        guard let cell = cellFor(index: index) else {
            return ""
        }
        return cell.dayAndMonthLabel.text ?? ""
    }
    
    func displayedTimeActivitiesView(atIndex index: Int) -> String {
        guard let cell = cellFor(index: index) else {
            return ""
        }
        return cell.hourLabel.text ?? ""
    }
    
    func displayedColorOnActivitiesView(atIndex index: Int) -> UIColor {
        guard let cell = cellFor(index: index) else {
            return .clear
        }
        return cell.scaleColorView.backgroundColor ?? .clear
    }
    
    func displayedTitleOnActivitiesView(atIndex index: Int) -> String {
        guard let cell = cellFor(index: index) else {
            return ""
        }
        return cell.titleLabel.text ?? ""
    }
    
    func displayedDescriptionOnActivitiesView(atIndex index: Int) -> String {
        guard let cell = cellFor(index: index) else {
            return ""
        }
        return cell.descriptionLabel.text ?? ""
    }
    
    private func cellFor(index: Int) -> ScheduledScalesTableViewCell? {
        guard didCallReloadData() else {
            return nil
        }
        return tableView(self, cellForRowAt: IndexPath(item: index, section: 0)) as? ScheduledScalesTableViewCell
    }
    
    private func didCallReloadData() -> Bool {
        return visibleCells.count != 0
    }
}
