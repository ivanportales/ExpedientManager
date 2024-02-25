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
