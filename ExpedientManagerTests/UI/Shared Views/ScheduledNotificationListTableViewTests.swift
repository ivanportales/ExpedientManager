//
//  ScheduledNotificationListTableViewTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 17/04/24.
//

import XCTest
@testable import ExpedientManager

final class ScheduledNotificationListTableViewTests: XCTestCase {
    
    private var tableView: ScheduledNotificationListTableView!
    private let emptyListMessage = "No notifications"
    
    func test_setup_scheduledNotifications() {
        makeSUT()
        
        let mockNotifications = ScheduledNotification.getModels()
        tableView.setup(scheduledNotifications: mockNotifications)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), mockNotifications.count)
    }
    
    func test_empty_state() {
        makeSUT()
        tableView.setup(scheduledNotifications: [])
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EmptyTableViewCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.messageLabel.text, emptyListMessage)
    }
    
    func makeSUT() {
        tableView = ScheduledNotificationListTableView(scheduledNotifications: [], 
                                                       emptyListMessage: "No notifications")
    }
}
