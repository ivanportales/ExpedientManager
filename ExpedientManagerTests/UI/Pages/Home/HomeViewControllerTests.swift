//
//  HomeViewControllerTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 12/02/24.
//

import Combine
@testable import ExpedientManager
import FSCalendar
import XCTest

final class HomeViewControllerTests: XCTestCase {
    
    private var viewModel: HomeViewModelStub!
    private var router: DeeplinkRouterStub!
    private var viewController: HomeViewController!
    private let currentDateForTesting: Date = Date.customDate()!
    private var subscribers: Set<AnyCancellable>!

    func test_call_to_fetch_function_when_view_controller_loads() {
        makeSUT()
        
        XCTAssertTrue(viewModel.didCallFetchScheduledNotifications)
    }
    
    func test_call_route_to_onboarding_page() {
        makeSUT()
        
        XCTAssertEqual(router.sendedDeeplink, .onboard)
    }
    
    func test_current_month_label_is_equal_to_current_month_on_initialization() {
        makeSUT()
        
        XCTAssertEqual(viewController.currentMonthLabel(), "January")
    }
    
    func test_if_list_navigation_bar_button_is_hidden_if_return_from_use_case_is_empty() {
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
    
    func test_if_list_navigation_bar_button_appears_if_return_from_use_case_is_not_empty() {
        let models = ScheduledNotification.getModels()
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
    
    func test_tap_on_add_scale_button() {
        makeSUT()
        
        if let barButton = self.viewController.navigationItem.rightBarButtonItems?[0] {
            barButton.testTap()
        }
       
        XCTAssertEqual(router.sendedDeeplink?.rawValue, Deeplink.addScale.rawValue)
    }
    
    func test_tap_on_scales_list_button() {
        makeSUT()
        
        if let barButton = self.viewController.navigationItem.rightBarButtonItems?[1] {
            barButton.testTap()
        }
       
        XCTAssertEqual(router.sendedDeeplink?.rawValue, Deeplink.scaleList.rawValue)
    }
    
    func test_loading_state() {
        makeSUT()
        viewModel.change(state: .loading)
        
        let expectation = XCTestExpectation(description: "Loading State diplays loading view")
        
        listenToStateChange { [weak self] state in
            switch state {
            case .loading:
                XCTAssertTrue(self!.viewController.isLoadingViewDisplayed())
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_activities_list_should_be_in_empty_state_if_return_from_use_case_is_empty() {
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
    
    func test_if_activities_list_is_displaying_the_right_information() {
        let models = ScheduledNotification.getModels()
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
    
    func test_change_current_selected_date_should_change_state_to_filter_content() {
        let models = ScheduledNotification.getModels()
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
    
    func test_number_of_events_for_current_month_in_calendar_if_return_from_use_case_is_empty() {
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
    
    func test_number_of_events_for_current_month_in_calendar_if_return_from_use_case() {
        let models = ScheduledNotification.getModels()
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
    
    func test_colors_for_dates_in_calendar() {
        let models = ScheduledNotification.getModels()
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
        
    func test_change_of_current_displayed_month_on_calendar() {
        makeSUT()
        let nextMonthDate = currentDateForTesting.add(1, to: .month)
        
        viewController.changeCurrentDisplayedMonthOnCalendar(to: nextMonthDate)
        
        XCTAssertEqual(viewController.title, "February")
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
    
    // MARK: - View Helpers
    
    func currentMonthLabel() -> String {
        return title ?? ""
    }
    
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
        return activitiesListTableView.isScheduledListInEmptyState()
    }
    
    func displayedDateOnActivitiesView(atIndex index: Int) -> String {
        return activitiesListTableView.displayedDateOnActivitiesView(atIndex: index)
    }
    
    func displayedTimeActivitiesView(atIndex index: Int) -> String {
        return activitiesListTableView.displayedTimeActivitiesView(atIndex: index)
    }
    
    func displayedColorOnActivitiesView(atIndex index: Int) -> UIColor {
        return activitiesListTableView.displayedColorOnActivitiesView(atIndex: index)
    }
    
    func displayedTitleOnActivitiesView(atIndex index: Int) -> String {
        return activitiesListTableView.displayedTitleOnActivitiesView(atIndex: index)
    }
    
    func displayedDescriptionOnActivitiesView(atIndex index: Int) -> String {
        return activitiesListTableView.displayedDescriptionOnActivitiesView(atIndex: index)
    }
}

// MARK: - Helper Classes

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
