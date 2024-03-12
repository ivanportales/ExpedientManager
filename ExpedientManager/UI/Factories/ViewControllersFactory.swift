//
//  ViewControllersFactory.swift
//  destiny2AssistentApp
//
//  Created by Gonzalo Ivan Santos Portales on 01/08/22.
//

import Foundation
import SafariServices

final class ViewControllersFactory {
    
    // MARK: - Private Fucntion
    
    private let router: DeeplinkRouterProtocol
    
    // MARK: - Init
    
    init(router: DeeplinkRouterProtocol) {
        self.router = router
    }
    
    // MARK: - Exposed Functions
    
    func makeOnboardingViewController() -> OnboardingViewController {
        let setValueForKeyUseCase = SetValueForKeyUseCase(storage: UserDefaults.standard)
        return OnboardingViewController(router: router,
                                        setValueForKeyUseCase: setValueForKeyUseCase)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let getScheduledNotificationsUseCase = GetScheduledNotificationsUseCase(scheduledNotificationsRepository: CoreDataScheduledNotificationRepository())
        let getValueForKeyUseCase = GetValueForKeyUseCase(storage: UserDefaults.standard)
        let viewModel = HomeViewModel(getScheduledNotificationsUseCase: getScheduledNotificationsUseCase,
                                      getValueForKeyUseCase: getValueForKeyUseCase)

        return HomeViewController(viewModel: viewModel, router: router)
    }
    
    func makeAddScaleViewController() -> AddScaleViewController {
        let scheduledNotificationsRepository = CoreDataScheduledNotificationRepository()
        let notificationManager = UserNotificationsManager()
        let askForNotificationPermissionUseCase = AskForNotificationPermissionUseCase(notificationsManager: notificationManager)
        let saveFixedScaleUseCase = SaveFixedScaleUseCase(fixedScaleRepository: CoreDataFixedScaleRepository(),
                                                          scheduledNotificationsRepository: scheduledNotificationsRepository,
                                                          notificationManager: notificationManager,
                                                          calendarManager: Calendar.current)
        let saveOnDutyUseCase = SaveOnDutyUseCase(onDutyRepository: CoreDataOnDutyRepository(), 
                                                  scheduledNotificationsRepository: scheduledNotificationsRepository,
                                                  notificationManager: notificationManager)
        let viewModel = AddScaleViewModel(askForNotificationPermissionUseCase: askForNotificationPermissionUseCase,
                                          saveFixedScaleUseCase: saveFixedScaleUseCase,
                                          saveOnDutyUseCase: saveOnDutyUseCase)

        return AddScaleViewController(viewModel: viewModel, router: router)
    }
    
    func makeScalesListViewController() -> ScalesListViewController {
        let getFixedScalesUseCase = GetFixedScalesUseCase(fixedScaleRepository: CoreDataFixedScaleRepository())
        let getOnDutyUseCase = GetOnDutyUseCase(onDutyRepository: CoreDataOnDutyRepository())
        
        let viewModel = ScalesListViewModel(getFixedScalesUseCase: getFixedScalesUseCase,
                                            getOnDutyUseCase: getOnDutyUseCase)

        return ScalesListViewController(viewModel: viewModel, 
                                        router: router)
    }
    
    func makeWebView(with url: URL) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
}
