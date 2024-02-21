//
//  HomeViewModelTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 20/02/24.
//

import Combine
@testable import ExpedientManager
import XCTest

final class HomeViewModelTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private let currentDateForTesting: Date = Date.customDate()!
    var subscribers: Set<AnyCancellable>!
    
    // MARK: - Helpers Functions

    private func makeSUT(scheduledNotifications: [ScheduledNotification] = [],
                         shoulShowOnboardScreen: Bool = false,
                         error: Error? = nil) {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = HomeViewModel(getScheduledNotificationsUseCase: GetScheduledNotificationsUseCaseStub(scheduledNotifications: scheduledNotifications, error: error),
                                                 getValueForKeyUseCase: GetValueForKeyUseCaseStub(returnedValue: shoulShowOnboardScreen))
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
}
