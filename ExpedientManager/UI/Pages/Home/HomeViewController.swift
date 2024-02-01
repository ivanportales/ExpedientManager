//
//  HomeViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/20/24.
//

import Combine
import FSCalendar
import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Views
    
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
        return ScheduledNotificationListTableView()
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: HomeVideModel
    private let router: DeeplinkRouterProtocol
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: - Inits
    
    init(viewModel: HomeVideModel,
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
        viewModel.load()
        displayLargeNavigationBarTitle(true)
    }
}

// MARK: - Setup Functions

extension HomeViewController {
    private func setupViewHierarchy() {
        view.addSubview(calendarView)
        view.addSubview(activityLabelView)
        view.addSubview(activitiesListTableView)
    }
    
    private func setupConstraints() {
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
    
    private func setupNavigationBar() {
        displayLargeNavigationBarTitle(true)
        setNavigationBarMonthTitle()
                
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
    
    private func setNavigationBarMonthTitle() {
       title = viewModel.getMonthDescriptionOf(date: calendarView.currentPage)
    }
    
    private func setupBindings() {
        viewModel
            .$scheduledScales
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scheduledScales in
                guard let self = self else {return}
                calendarView.reloadData()
                if scheduledScales.isEmpty {
                    self.hideNavigationBarButtonFrom(position: .right, andIndex: 1)
                } else {
                    self.showNavigationBarButtonFrom(position: .right, andIndex: 1)
                }
            }.store(in: &subscribers)
        
        viewModel
            .$filteredScheduledDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.activitiesListTableView.setup(scheduledNotifications: viewModel.filteredScheduledDates)
            }.store(in: &subscribers)
    }
}

// MARK: - FSCalendarDelegate

extension HomeViewController: FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setNavigationBarMonthTitle()
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let scheduledNotifications = viewModel.scheduledScalesDict[date.dateString] {
            var colors: [UIColor] = []
            
            for scheduledNotification in scheduledNotifications {
                colors.append(.init(hex: scheduledNotification.colorHex))
            }
            
            cell.eventIndicator.isHidden = false
            cell.eventIndicator.numberOfEvents = scheduledNotifications.count
            cell.preferredEventDefaultColors = colors
            cell.preferredEventSelectionColors = colors
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarViewDateChangedTo(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if let scheduledNotifications = viewModel.scheduledScalesDict[date.dateString] {
            return scheduledNotifications.count
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if let scheduledScales = viewModel.scheduledScalesDict[date.dateString] {
            var colors: [UIColor] = []
            
            for scheduledScale in scheduledScales {
                colors.append(.init(hex: scheduledScale.colorHex))
            }
            
            return colors
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if let scheduledScales = viewModel.scheduledScalesDict[date.dateString] {
            var colors: [UIColor] = []
            
            for scheduledScale in scheduledScales {
                colors.append(.init(hex: scheduledScale.colorHex))
            }
            
            return colors
        }
        return nil
    }
}

// MARK: - Helpers functions

extension HomeViewController {
    private func calendarViewDateChangedTo(date: Date) {
        viewModel.filterScheduledDatesWith(date: date)
    }
    
    private func verifyFirstAccessOnApp() {
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

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {}
