//
//  HomeViewControllerTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 12/02/24.
//

import Combine
@testable import ExpedientManager
import XCTest

final class HomeViewControllerTests: XCTestCase {
    
    private var viewModel: HomeViewModelStub!
    private var router: DeeplinkRouterStub!
    private var viewController: HomeViewController!
    var subscribers: Set<AnyCancellable>!

    func testViewDidAppearCallToFetchFunction() {
        makeSUT()
        
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
        
        XCTAssertTrue(viewModel.didCallFetchScheduledNotifications)
    }
    
    func testNumberOfEventsForCurrentMonthInCalendarIfReturnFromUseCaseIsEmpty() {
        makeSUT()
        
        let expectation = XCTestExpectation(description: "ViewModel fetches scheduled notifications")
        
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
        
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                XCTAssertEqual(self!.viewController.numberOfEventsForCurrentMonth(), 0)
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNumberOfEventsForCurrentMonthInCalendarIfReturnFromUseCase() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "ViewModel fetches scheduled notifications")
        
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
        
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                XCTAssertEqual(self!.viewController.numberOfEventsForCurrentMonth(), models.count)
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [expectation], timeout: 1.0)
    }

    
    private func makeSUT(scheduledNotifications: [ScheduledNotification] = []) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = HomeViewModelStub(scheduledNotifications: scheduledNotifications)
        self.router = DeeplinkRouterStub()
        self.viewController = HomeViewController(viewModel: viewModel!,
                                                 router: router!)
    }
    
    private func getModels() -> [ScheduledNotification] {
        var items: [ScheduledNotification] = []

        for index in 1..<11 {
            items.append(ScheduledNotification(uid: index.description,
                                               title: "Title \(index)",
                                               description: "Description \(index)",
                                               date: Date.customDate(day: index)!,
                                               scaleUid: "Scale UID \(index)",
                                               colorHex: UIColor.black.hex))
        }
        
        return items
    }
}


// MARK: - Helper Extension

fileprivate extension HomeViewController {
    func numberOfEventsForCurrentMonth() -> Int {
        var totalEvents = 0
        let dates = getDatesFromCurrentMonth()
        for date in dates {
            totalEvents += calendarView.dataSource?.calendar?(calendarView, numberOfEventsFor: date) ?? 0
        }
        return totalEvents
    }
    
    func getDatesFromCurrentMonth() -> [Date] {
        let now = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        
        if let range = calendar.range(of: .day, in: .month, for: now) {
            let days = range.count
            var datesCurrentMonth = [Date]()
            
            for day in 1...days {
                if let date = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: day)) {
                    datesCurrentMonth.append(date)
                }
            }
            
            return datesCurrentMonth
        }
        
        return []
    }
}


fileprivate extension Date {
    static func customDate(day: Int = 1,
                           hour: Int = 1,
                           minute: Int = 1,
                           second: Int = 1) -> Date? {
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: Date())
        
        var dateComponents = DateComponents()
        dateComponents.year = currentDateComponents.year
        dateComponents.month = currentDateComponents.month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

        return calendar.date(from: dateComponents)
    }
}

fileprivate final class HomeViewModelStub: HomeViewModelProtocol {
    
    // MARK: - Exposed Properties
    
    @Published private(set) var statePublished: HomeViewModelState = .initial
    var state: Published<HomeViewModelState>.Publisher { $statePublished }
    
    var scheduledNotifications: [ScheduledNotification]
    var didCallFetchScheduledNotifications = false
    
    // MARK: - Init
    
    init(scheduledNotifications: [ScheduledNotification]) {
        self.scheduledNotifications = scheduledNotifications
    }
    
    // MARK: - Protocol Functions
    
    func fetchScheduledNotifications() {
        didCallFetchScheduledNotifications = true
        statePublished = .content(notificationsCount: scheduledNotifications.count,
                                  filteredNotifications: scheduledNotifications)
    }
    
    func getFilteredScheduledDatesWith(date: Date) -> [ScheduledNotification] {
        return filterNotifications(with: date)
    }
    
    func getMonthDescriptionOf(date: Date) -> String {
        return date.formateDate(withFormat: "MMMM", dateStyle: .full).firstUppercased
    }
    
    func filterScheduledDatesWith(date: Date) {
        self.statePublished = .filterContent(filteredNotifications: filterNotifications(with: date))
    }
    
    func verifyFirstAccessOnApp(routeToOnboardingCallback: @escaping (() -> Void)) {
        routeToOnboardingCallback()
    }
    
    // MARK: - Helper Functions for Testing
    
    func change(state newState: HomeViewModelState) {
        self.statePublished = newState
    }
    
    func filterNotifications(with date: Date) -> [ScheduledNotification] {
        return scheduledNotifications.filter { $0.date.formateDate() == date.formateDate() }
    }
}
