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
    private var delegate: MockTableViewDelegate!

    func test_setup_scheduledNotifications() {
        makeSUT()
        
        let mockNotifications = ScheduledNotification.getModels()
        tableView.setup(scheduledNotifications: mockNotifications)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), mockNotifications.count)
    }
    
    func test_empty_state() {
        makeSUT()
        
        tableView.setup(scheduledNotifications: [])
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EmptyTableViewCell
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.messageLabel.text, emptyListMessage)
    }
    
    func test_cell_content() {
        makeSUT()
        
        let mockNotification = ScheduledNotification.getModels().first!
        tableView.setup(scheduledNotifications: [mockNotification])
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ScheduledScalesTableViewCell
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(cell?.dayAndMonthLabel.text, mockNotification.date.formateDate(withFormat: "d/MM"))
        XCTAssertEqual(cell?.hourLabel.text, mockNotification.date.formatTime())
        XCTAssertEqual(cell?.titleLabel.text, mockNotification.title)
        XCTAssertEqual(cell?.descriptionLabel.text, mockNotification.description)
        XCTAssertEqual(cell?.scaleColorView.backgroundColor?.hex, mockNotification.colorHex)
    }
    
    func test_didSelectRow_callsDelegateMethod() {
        makeSUT()
        
        let mockNotifications = ScheduledNotification.getModels()
        tableView.setup(scheduledNotifications: mockNotifications)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(delegate.didTapOnItemCalled)
    }
    
    func makeSUT() {
        delegate = MockTableViewDelegate()
        tableView = ScheduledNotificationListTableView(scheduledNotifications: [],
                                                       emptyListMessage: emptyListMessage)
        tableView.viewDelegate = delegate
    }
}

fileprivate class MockTableViewDelegate: ScheduledNotificationListTableViewDelegate {
    var didTapOnItemCalled = false
    
    func didTapOnItem(_ view: ScheduledNotificationListTableView, item: ScheduledNotification, index: Int) {
        didTapOnItemCalled = true
    }
}
