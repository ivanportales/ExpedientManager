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
    
    func testIfListNavigationBarButtonAppearsIfReturnFromUseCaseIsNotEmpty() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "List NavigationBarButton and AddScale button appears")
        
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
    
    func testActivitiesListShouldBeInEmptyStateIfReturnFromUseCaseIsEmpty() {
        makeSUT()
        
        let expectation = XCTestExpectation(description: "ActivitiesList diplays empty state")
        
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
    
    func testIfActivitiesListIsDisplayingTheRightInformation() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "ActivitiesList displays all the filteredNotifications")
        
        listenToStateChange { [weak self] state in
            switch state {
            case .content(_,
                          let filteredNotifications):
                for index in 0..<filteredNotifications.count {
                    let notification = filteredNotifications[index]
                    XCTAssertEqual(self!.viewController.displayedDateOnActivitiesView(atIndex: index),
                                   notification.date.formateDate(withFormat: "d/MM"))
                    XCTAssertEqual(self!.viewController.displayedTimeActivitiesView(atIndex: index),
                                   notification.date.formatTime())
                    XCTAssertEqual(self!.viewController.displayedColorOnActivitiesView(atIndex: index).hex,
                                   notification.colorHex)
                    XCTAssertEqual(self!.viewController.displayedTitleOnActivitiesView(atIndex: index),
                                   notification.title)
                    XCTAssertEqual(self!.viewController.displayedDescriptionOnActivitiesView(atIndex: index),
                                   notification.description)
                }
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testChangeCurrentSelectedDateShouldChangeStateToFilterContent() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "ActivitiesList displays all the filteredNotifications when state change to filterContent")
        
        let newSelectedDate = models[1].date
        viewController.changeCurrentSelectedDate(to: newSelectedDate)
        
        listenToStateChange { [weak self] state in
            switch state {
            case .filterContent(let filteredNotifications):
                for index in 0..<filteredNotifications.count {
                    let notification = filteredNotifications[index]
                    XCTAssertEqual(newSelectedDate, notification.date)
                    XCTAssertEqual(self!.viewController.displayedDateOnActivitiesView(atIndex: index),
                                   notification.date.formateDate(withFormat: "d/MM"))
                    XCTAssertEqual(self!.viewController.displayedTimeActivitiesView(atIndex: index),
                                   notification.date.formatTime())
                    XCTAssertEqual(self!.viewController.displayedColorOnActivitiesView(atIndex: index).hex,
                                   notification.colorHex)
                    XCTAssertEqual(self!.viewController.displayedTitleOnActivitiesView(atIndex: index),
                                   notification.title)
                    XCTAssertEqual(self!.viewController.displayedDescriptionOnActivitiesView(atIndex: index),
                                   notification.description)
                }
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNumberOfEventsForCurrentMonthInCalendarIfReturnFromUseCaseIsEmpty() {
        makeSUT()
        
        let expectation = XCTestExpectation(description: "CalendarView diplays empty event calendar")
        
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
    
    func testNumberOfEventsForCurrentMonthInCalendarIfReturnFromUseCase() {
        let models = getModels()
        makeSUT(scheduledNotifications: models)
        
        let expectation = XCTestExpectation(description: "CalendarView diplays event calendar with 10 events on total")
        
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
        
        let expectation = XCTestExpectation(description: "CalendarView displays right event colors for date")
        
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
        self.viewModel = HomeViewModelStub(scheduledNotifications: scheduledNotifications,
                                           currentSelectedDate: currentDateForTesting)
        self.router = DeeplinkRouterStub()
        self.viewController = HomeViewController(viewModel: viewModel!,
                                                 router: router!)
        viewController.changeCurrentDisplayedMonthOnCalendar(to: currentDateForTesting)
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
    }
    
    private func getModels() -> [ScheduledNotification] {
        var items: [ScheduledNotification] = []
        let colors = [
            UIColor(hex: "#0000FF"),
            UIColor(hex: "#FF2D55"),
            UIColor(hex: "#00FF00"),
            UIColor(hex: "#800080"),
            UIColor(hex: "#FF8000"),
            UIColor(hex: "#101138"),
            UIColor(hex: "#0000FF"),
            UIColor(hex: "#FF2D55"),
            UIColor(hex: "#00FF00"),
            UIColor(hex: "#800080")
        ]

        for index in 0..<10 {
            items.append(ScheduledNotification(uid: index.description,
                                               title: "Title \(index)",
                                               description: "Description \(index)",
                                               date: Date.customDate(day: index + 1)!,
                                               scaleUid: "Scale UID \(index)",
                                               colorHex: colors[index].hex))
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
    
    // MARK: - Calendar View Helpers
    
    func changeCurrentDisplayedMonthOnCalendar(to date: Date) {
        calendarView.setCurrentPage(date, animated: false)
        calendarCurrentPageDidChange(calendarView)
    }
    
    func changeCurrentSelectedDate(to date: Date) {
        calendar(calendarView, didSelect: date, at: FSCalendarMonthPosition.current)
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
    
    // MARK: - Activities List Helpers
    
    func isScheduledListInEmptyState() -> Bool {
        guard activitiesListTableView.numberOfRows(inSection: 0) == 1 else {
            return false
        }
        if let _ = activitiesListTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? EmptyTableViewCell {
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
    
    func cellFor(index: Int) -> ScheduledScalesTableViewCell? {
        return activitiesListTableView.cellForRow(at: IndexPath(item: index, section: 0)) as? ScheduledScalesTableViewCell
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
    var currentSelectedDate: Date
    var didCallFetchScheduledNotifications = false
    
    // MARK: - Init
    
    init(scheduledNotifications: [ScheduledNotification],
         currentSelectedDate: Date) {
        self.scheduledNotifications = scheduledNotifications
        self.currentSelectedDate = currentSelectedDate
    }
    
    // MARK: - Protocol Functions
    
    func fetchScheduledNotifications() {
        didCallFetchScheduledNotifications = true
        statePublished = .content(notificationsCount: scheduledNotifications.count,
                                  filteredNotifications: filterNotifications(with: currentSelectedDate))
    }
    
    func getFilteredScheduledDatesWith(date: Date) -> [ScheduledNotification] {
        return filterNotifications(with: date)
    }
    
    func getMonthDescriptionOf(date: Date) -> String {
        return date.formateDate(withFormat: "MMMM", dateStyle: .full).firstUppercased
    }
    
    func filterScheduledDatesWith(date: Date) {
        self.currentSelectedDate = date
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
