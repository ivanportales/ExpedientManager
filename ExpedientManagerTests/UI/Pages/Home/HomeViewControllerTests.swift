//
//  HomeViewControllerTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 12/02/24.
//

import Combine
@testable import ExpedientManager
import XCTest
import FSCalendar

final class HomeViewControllerTests: XCTestCase {
    
    private var viewModel: HomeViewModelStub!
    private var router: DeeplinkRouterStub!
    private var viewController: HomeViewController!
    private let currentDateForTesting: Date = Date.customDate()!
    var subscribers: Set<AnyCancellable>!

    func testCallToFetchFunctionWhenViewControllerLoads() {
        makeSUT()
        
        XCTAssertTrue(viewModel.didCallFetchScheduledNotifications)
    }
    
    func testNavigationTitleEqualsToCurrentMonthOnInitialization() {
        makeSUT()
        
        XCTAssertEqual(viewController.title,
                       currentDateForTesting.formateDate(withFormat: "MMMM", dateStyle: .full).firstUppercased)
    }
    
    func testIfListNavigationBarButtonIsHiddenIfReturnFromUseCaseIsEmpty() {
        makeSUT()
         
        let expectation = XCTestExpectation(description: "List NavigationBarButton is Hidden and AddScale button is not")
         
        listenToStateChange { [weak self] state in
            switch state {
            case .content(let notificationsCount,
                          let filteredNotifications):
                XCTAssertEqual(notificationsCount, 0)
                XCTAssertTrue(filteredNotifications.isEmpty)
                
                XCTAssertFalse(self!.viewController.navigationItem.rightBarButtonItems![0].isHidden)
                XCTAssertTrue(self!.viewController.navigationItem.rightBarButtonItems![1].isHidden)
            default:
                XCTFail()
            }
             
            expectation.fulfill()
         }
         
         wait(for: [expectation], timeout: 1.0)
    }
    
    func testActivitiesListShouldBeInEmptyStateIfReturnFromUseCaseIsEmpty() {
        makeSUT()
        
        let expectation = XCTestExpectation(description: "ViewController diplays empty event calendar")
        
        listenToStateChange { [weak self] state in
            switch state {
            case .content(let notificationsCount,
                          let filteredNotifications):
                XCTAssertEqual(notificationsCount, 0)
                XCTAssertTrue(filteredNotifications.isEmpty)
                XCTAssertTrue(self!.viewController.isScheduledListInEmptyState())
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNumberOfEventsForCurrentMonthInCalendarIfReturnFromUseCaseIsEmpty() {
        makeSUT()
        
        let expectation = XCTestExpectation(description: "ViewController diplays empty event calendar")
        
        listenToStateChange { [weak self] state in
            switch state {
            case .content(let notificationsCount,
                          let filteredNotifications):
                XCTAssertEqual(self!.viewController.numberOfEventsForCurrentMonth(), 0)
                XCTAssertEqual(notificationsCount, 0)
                XCTAssertTrue(filteredNotifications.isEmpty)
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testIfListNavigationBarButtonAppearsIfReturnFromUseCaseIsNotEmpty() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "List NavigationBarButto and AddScale button appears")
        
        listenToStateChange { [weak self] state in
            switch state {
            case .content(let notificationsCount,
                         let filteredNotifications):
                XCTAssertEqual(notificationsCount, models.count)
                XCTAssertFalse(filteredNotifications.isEmpty)
               
                XCTAssertFalse(self!.viewController.navigationItem.rightBarButtonItems![0].isHidden)
                XCTAssertFalse(self!.viewController.navigationItem.rightBarButtonItems![1].isHidden)
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
   }
    
    func testNumberOfEventsForCurrentMonthInCalendarIfReturnFromUseCase() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "ViewController diplays event calendar with 10 events")
        
        listenToStateChange { [weak self] state in
            switch state {
            case .content(let notificationsCount,
                          let filteredNotifications):
                XCTAssertEqual(self!.viewController.numberOfEventsForCurrentMonth(), models.count)
                XCTAssertEqual(notificationsCount, models.count)
                XCTAssertFalse(filteredNotifications.isEmpty)
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testColorsForDatesInCalendar() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "ViewController displays right event colors for date on calendar")
        
        listenToStateChange { [weak self] state in
            for model in models {
                let color = UIColor(hex: model.colorHex)
                XCTAssertTrue(self!.viewController.colorsForEvents(on: model.date).contains(color))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
        
    func testChangeOfCurrentDisplayedMonthOnCalendar() {
        makeSUT()
        let nextMonthDate = currentDateForTesting.add(1, to: .month)
        
        viewController.changeCurrentDisplayedMonthOnCalendar(to: nextMonthDate)
        
        XCTAssertEqual(viewController.title,
                       nextMonthDate.formateDate(withFormat: "MMMM", dateStyle: .full).firstUppercased)
    }
    
    // MARK: - Helpers Functions

    private func makeSUT(scheduledNotifications: [ScheduledNotification] = []) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = HomeViewModelStub(scheduledNotifications: scheduledNotifications)
        self.router = DeeplinkRouterStub()
        self.viewController = HomeViewController(viewModel: viewModel!,
                                                 router: router!)
        viewController.setDateForCurrentCalendarPage(currentDateForTesting)
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
    }
    
    private func getModels() -> [ScheduledNotification] {
        var items: [ScheduledNotification] = []

        for index in 1..<6 {
            items.append(ScheduledNotification(uid: index.description,
                                               title: "Title \(index)",
                                               description: "Description \(index)",
                                               date: Date.customDate(day: index)!,
                                               scaleUid: "Scale UID \(index)",
                                               colorHex: UIColor.black.hex))
        }
        
        for index in 6..<11 {
            items.append(ScheduledNotification(uid: index.description,
                                               title: "Title \(index)",
                                               description: "Description \(index)",
                                               date: Date.customDate(day: index)!,
                                               scaleUid: "Scale UID \(index)",
                                               colorHex: UIColor.blue.hex))
        }
        
        return items
    }
    
    private func listenToStateChange(_ callback: @escaping (HomeViewModelState) -> Void) {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { state in
                callback(state)
            }
            .store(in: &subscribers)
    }
}


// MARK: - Helper Extensions

fileprivate extension HomeViewController {
    func setDateForCurrentCalendarPage(_ date: Date) {
        calendarView.setCurrentPage(date, animated: false)
    }
    
    func changeCurrentDisplayedMonthOnCalendar(to date: Date) {
        setDateForCurrentCalendarPage(date)
        calendarCurrentPageDidChange(calendarView)
    }
    
    func numberOfEventsForCurrentMonth() -> Int {
        var totalEvents = 0
        let dates = getDatesFromCurrentCalendarDisplayedMonth()
        for date in dates {
            totalEvents += calendarView.dataSource?.calendar?(calendarView, numberOfEventsFor: date) ?? 0
        }
        return totalEvents
    }
    
    func colorsForEvents(on date: Date) -> [UIColor] {
        let eventDefaultColors = calendar(calendarView, appearance: calendarView.appearance, eventDefaultColorsFor: date) ?? []
        let eventSelectionColors = calendar(calendarView, appearance: calendarView.appearance, eventSelectionColorsFor: date) ?? []
        
        if eventDefaultColors == eventSelectionColors {
            return eventDefaultColors
        }
        
        return []
    }
    
    func isScheduledListInEmptyState() -> Bool {
        guard activitiesListTableView.numberOfRows(inSection: 0) == 1 else {
            return false
        }
        if let _ = activitiesListTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? EmptyTableViewCell {
            return true
        }
        return false
    }
    
    func getDatesFromCurrentCalendarDisplayedMonth() -> [Date] {
        let now = calendarView.currentPage
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
    static func customDate(year: Int = 2023,
                           month: Int = 1,
                           day: Int = 1,
                           hour: Int = 1,
                           minute: Int = 1,
                           second: Int = 1) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

        return Calendar.current.date(from: dateComponents)
    }
    
    func add(_ value: Int, to component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
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
