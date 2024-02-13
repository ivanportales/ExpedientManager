//
//  HomeViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 01/11/23.
//

import Combine
import FSCalendar
import UIKit

final class HomeViewController: UIViewController, LoadingShowableViewControllerProtocol {
    
    // MARK: - UI
    
    var loadingView: LoadingView?
    
    lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = .clear
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.appearance.weekdayTextColor = .appDarkBlue
        calendarView.appearance.weekdayFont = .poppinsMediumOf(size: 16)
        calendarView.appearance.borderSelectionColor = .appDarkBlue
        calendarView.appearance.titleSelectionColor = .textColor
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.titleDefaultColor = .textColor
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.titleTodayColor = .appDarkBlue
        calendarView.appearance.titleFont = .poppinsSemiboldOf(size: 15)

        calendarView.headerHeight = 0
        
        return calendarView
    }()
    
    lazy var activityLabelView: UILabel = {
        return UIView.makeLabelWith(text: LocalizedString.activitiesLabel,
                                    font: .poppinsSemiboldOf(size: 19),
                                    color: .black)
    }()
    
    lazy var activitiesListTableView: ScheduledNotificationListTableView = {
        return ScheduledNotificationListTableView(emptyListMessage: LocalizedString.emptyScheduledNotificationsForDayMessage)
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: HomeViewModelProtocol
    private let router: DeeplinkRouterProtocol
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: - Inits
    
    init(viewModel: HomeViewModelProtocol,
         router: DeeplinkRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupViewHierarchy()
        setupConstraints()
        setupBindings()
        verifyFirstAccessOnApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchScheduledNotifications()
        displayLargeNavigationBarTitle(true)
    }
}

// MARK: - Setup Functions

private extension HomeViewController {
    func setupViewHierarchy() {
        view.addSubview(calendarView)
        view.addSubview(activityLabelView)
        view.addSubview(activitiesListTableView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            calendarView.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            activityLabelView.topAnchor.constraint(equalTo: safeArea.centerYAnchor),
            activityLabelView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            activityLabelView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            activitiesListTableView.topAnchor.constraint(equalTo: activityLabelView.bottomAnchor, constant: 10),
            activitiesListTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            activitiesListTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            activitiesListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        displayLargeNavigationBarTitle(true)
        setupNavigationBarMonthTitle()
                
        setupNavigationBarItemOn(position: .right,
                                 withIcon: UIImage(systemName: "plus"),
                                 color: .appLightBlue) { [weak self] _ in
            self?.showAddScaleScreen()
        }
        
        setupNavigationBarItemOn(position: .right,
                                 withIcon: UIImage(systemName: "list.bullet"),
                                 color: .appLightBlue) { [weak self] _ in
            self?.showScalesListScreen()
        }
    }
    
    func setupNavigationBarMonthTitle() {
       title = viewModel.getMonthDescriptionOf(date: calendarView.currentPage)
    }
    
    func setupBindings() {
        viewModel
            .state
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.disableLoadingView()
                switch state {
                case .initial:
                    break
                case .loading:
                    self.showLoadingView()
                case .error(let message):
                    self.showAlertWith(title: LocalizedString.alertErrorTitle,
                                       andMesssage: message)
                case .content(let notificationsCount,
                              let filteredNotifications):
                    self.handleContentState(notificationsCount,
                                            filteredNotifications)
                case .filterContent(let filteredNotifications):
                    self.activitiesListTableView.setup(scheduledNotifications: filteredNotifications)
                }
            }.store(in: &subscribers)
    }
    
    func handleContentState(_ notificationsCount: Int,
                            _ filteredNotifications: [ScheduledNotification]) {
        if notificationsCount == 0 {
            hideNavigationBarButtonFrom(position: .right, andIndex: 1)
        } else {
            showNavigationBarButtonFrom(position: .right, andIndex: 1)
        }
        calendarView.reloadData()
        activitiesListTableView.setup(scheduledNotifications: filteredNotifications)
    }
}

// MARK: - FSCalendarDelegate

extension HomeViewController: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setupNavigationBarMonthTitle()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.filterScheduledDatesWith(date: date)
    }
}

// MARK: - FSCalendarDataSource

extension HomeViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.getFilteredScheduledDatesWith(date: date).count
    }
}

// MARK: - FSCalendarDelegateAppearance

extension HomeViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let scheduledNotifications = viewModel.getFilteredScheduledDatesWith(date: date)
        return scheduledNotifications.map { UIColor(hex: $0.colorHex) }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let scheduledNotifications = viewModel.getFilteredScheduledDatesWith(date: date)
        return scheduledNotifications.map { UIColor(hex: $0.colorHex) }
    }
}

// MARK: - Helpers functions

private extension HomeViewController {
    func verifyFirstAccessOnApp() {
        viewModel.verifyFirstAccessOnApp { [weak self] in
            self?.router.route(to: .onboard, withParams: [:])
        }
    }
    
    @objc func showAddScaleScreen() {
        router.route(to: .addScale, withParams: [:])
    }
    
    @objc func showScalesListScreen() {
        router.route(to: .scaleList, withParams: [:])
    }
}
