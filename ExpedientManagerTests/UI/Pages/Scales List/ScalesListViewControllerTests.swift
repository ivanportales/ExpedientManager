//
//  ScalesListViewControllerTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 24/02/24.
//

import Combine
@testable import ExpedientManager
import XCTest
import UIKit

final class ScalesListViewControllerTests: XCTestCase {
    
    private var viewModel: ScalesListViewModelStub!
    private var router: DeeplinkRouterStub!
    private var viewController: ScalesListViewController!
    private let currentDateForTesting: Date = Date.customDate()!
    var subscribers: Set<AnyCancellable>!
    
    func testIfScalesTableViewIsDisplayingTheRightInformation() {
        let fixedScales = FixedScale.mockModels
        let expectedScheduledNotifications = fixedScales.map { $0.toScheduledNotification() }
        makeSUT(scheduledNotifications: expectedScheduledNotifications)
        
        let expectation = XCTestExpectation(description: "Scales View displays all the scheduledNotifications")
        
        listenToStateChange { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .content(let scheduledNotifications,_):
                for index in 0..<scheduledNotifications.count {
                    let notification = scheduledNotifications[index]
                    XCTAssertEqual(self.viewController.displayedDateOnActivitiesView(atIndex: index),
                                   notification.date.formateDate(withFormat: "d/MM"))
                    XCTAssertEqual(self.viewController.displayedTimeActivitiesView(atIndex: index),
                                   notification.date.formatTime())
                    XCTAssertEqual(self.viewController.displayedColorOnActivitiesView(atIndex: index).hex,
                                   notification.colorHex)
                    XCTAssertEqual(self.viewController.displayedTitleOnActivitiesView(atIndex: index),
                                   notification.title)
                    XCTAssertEqual(self.viewController.displayedDescriptionOnActivitiesView(atIndex: index),
                                   notification.description)
                }
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInitialSelectedScale() {
        let fixedScales = FixedScale.mockModels
        let expectedScheduledNotifications = fixedScales.map { $0.toScheduledNotification() }
        makeSUT(scheduledNotifications: expectedScheduledNotifications)
                
        let expectation = XCTestExpectation(description: "selectedWorkScaleLabel is equal to selectedWorkScale.description")
        
        listenToStateChange { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .content(_, let selectedWorkScale):
                XCTAssertEqual(self.viewController.selectedWorkScaleLabel(), selectedWorkScale.description)
                XCTAssertEqual(selectedWorkScale, .fixedScale)
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Helpers Functions

    private func makeSUT(scheduledNotifications: [ScheduledNotification] = [],
                         selectedWorkScalePublished: WorkScaleType = .fixedScale) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = ScalesListViewModelStub(scheduledNotifications: scheduledNotifications, 
                                                 selectedWorkScalePublished: selectedWorkScalePublished)
        self.router = DeeplinkRouterStub()
        self.viewController = ScalesListViewController(viewModel: viewModel!,
                                                       router: router!)
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
    }

    private func listenToStateChange(_ callback: @escaping (ScalesListViewModelState) -> Void) {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { state in
                callback(state)
            }
            .store(in: &subscribers)
    }
}

extension ScalesListViewController {
    
    // MARK: - View Helpers
        
    func selectedWorkScaleLabel() -> String {
        return title ?? ""
    }
    
    // MARK: - Scales Options Helpers
    
    func changeSelectedScale(to selectedWorkScale: WorkScaleType) {
        didChangeSelectedIndex(scaleTypeSegmentControl, selectedWorkScale: selectedWorkScale)
    }

    // MARK: - Activities List Helpers
    
    func isScheduledListInEmptyState() -> Bool {
        return scalesTableView.isScheduledListInEmptyState()
    }
    
    func displayedDateOnActivitiesView(atIndex index: Int) -> String {
        return scalesTableView.displayedDateOnActivitiesView(atIndex: index)
    }
    
    func displayedTimeActivitiesView(atIndex index: Int) -> String {
        return scalesTableView.displayedTimeActivitiesView(atIndex: index)
    }
    
    func displayedColorOnActivitiesView(atIndex index: Int) -> UIColor {
        return scalesTableView.displayedColorOnActivitiesView(atIndex: index)
    }
    
    func displayedTitleOnActivitiesView(atIndex index: Int) -> String {
        return scalesTableView.displayedTitleOnActivitiesView(atIndex: index)
    }
    
    func displayedDescriptionOnActivitiesView(atIndex index: Int) -> String {
        return scalesTableView.displayedDescriptionOnActivitiesView(atIndex: index)
    }
}

fileprivate class ScalesListViewModelStub: ScalesListViewModelProtocol {
    
    // MARK: - Exposed Properties
    
    @Published private(set) var statePublished: ScalesListViewModelState = .initial
    var state: Published<ScalesListViewModelState>.Publisher { $statePublished }
    
    var scheduledNotifications: [ScheduledNotification]
    var selectedWorkScalePublished: WorkScaleType
    
    // MARK: - Init
    
    init(scheduledNotifications: [ScheduledNotification] = [],
         selectedWorkScalePublished: WorkScaleType = .fixedScale) {
        self.scheduledNotifications = scheduledNotifications
        self.selectedWorkScalePublished = selectedWorkScalePublished
    }
    
    // MARK: - Protocol Functions
    
    func getAllScales() {
        statePublished = .content(scheduledNotifications: scheduledNotifications,
                                  selectedWorkScale: selectedWorkScalePublished)
    }
    
    func change(selectedWorkScale: WorkScaleType) {
        selectedWorkScalePublished = selectedWorkScale
        statePublished = .content(scheduledNotifications: scheduledNotifications,
                                  selectedWorkScale: selectedWorkScalePublished)
    }
}
