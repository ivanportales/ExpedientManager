//
//  ScaleTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 17/04/24.
//

import XCTest
@testable import ExpedientManager

final class ScheduledNotificationListTableViewTests: XCTestCase {
    
    private var tableView: ScheduledNotificationListTableView!
    
    override func setUp() {
        super.setUp()
        tableView = ScheduledNotificationListTableView(scheduledNotifications: [], emptyListMessage: "No notifications")
    }
    
    override func tearDown() {
        tableView = nil
        super.tearDown()
    }
    
    func test_setup_scheduledNotifications() {
        let mockNotifications = [ScheduledNotification(), ScheduledNotification()]
        tableView.setup(scheduledNotifications: mockNotifications)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), mockNotifications.count)
    }
}
