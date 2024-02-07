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
    
    private let localStorage: LocalStorageRepositoryProtocol = LocalStorageRepository()
    private let router: DeeplinkRouterProtocol
    
    // MARK: - Init
    
    init(router: DeeplinkRouterProtocol) {
        self.router = router
    }
    
    // MARK: - Exposed Functions
    
    func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController(router: router,
                                        localStorage: localStorage)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let getScheduledNotificationsUseCase = GetScheduledNotificationsUseCase(scheduledNotificationsRepository: CoreDataScheduledNotificationsRepository())
        let getValueForKeyUseCase = GetValueForKeyUseCase(localStorage: localStorage)
        let viewModel = HomeViewModel(getScheduledNotificationsUseCase: getScheduledNotificationsUseCase,
                                      getValueForKeyUseCase: getValueForKeyUseCase,
                                      calendarManager: Calendar.current)

        return HomeViewController(viewModel: viewModel, router: router)
    }
    
    func makeAddScaleViewController() -> BaseScaleViewController {
        let scheduledNotificationsRepository = CoreDataScheduledNotificationsRepository()
        let notificationManager = UserNotificationsManager()
        let saveFixedScaleUseCase = SaveFixedScaleUseCase(fixedScaleRepository: CoreDataFixedScaleRepository(),
                                                          scheduledNotificationsRepository: scheduledNotificationsRepository,
                                                          notificationManager: notificationManager,
                                                          calendarManager: Calendar.current)
        let saveOnDutyUseCase = SaveOnDutyUseCase(onDutyRepository: CoreDataOnDutyRepository(), 
                                                  scheduledNotificationsRepository: scheduledNotificationsRepository,
                                                  notificationManager: notificationManager)
        let viewModel = AddScaleViewModel(notificationManager: notificationManager,
                                          saveFixedScaleUseCase: saveFixedScaleUseCase,
                                          saveOnDutyUseCase: saveOnDutyUseCase)

        return BaseScaleViewController(viewModel: viewModel, router: router)
    }
    
    func makeScalesListViewController() -> ScalesListViewController {
        let getFixedScalesUseCase = GetFixedScalesUseCase(fixedScaleRepository: CoreDataFixedScaleRepository())
        let getOnDutyUseCase = GetOnDutyUseCase(onDutyRepository: CoreDataOnDutyRepository())
        
        let viewModel = ScalesListViewModel(getFixedScalesUseCase: getFixedScalesUseCase,
                                            getOnDutyUseCase: getOnDutyUseCase)

        return ScalesListViewController(viewModel: viewModel, 
                                        router: router)
    }
    
    func makeScalesDetailViewController(workScaleType: WorkScaleType,
                                        selectedFixedScale: FixedScale?,
                                        selectedOnDuty: OnDuty?) -> ScaleDetailsViewController {
        let viewModel = ScaleDetailsViewModel(state: workScaleType,
                                              selectedFixedScale: selectedFixedScale,
                                              selectedOnDuty: selectedOnDuty,
                                              scheduler: UserNotificationsManager(),
                                              scheduledNotificationsRepository: CoreDataScheduledNotificationsRepository(),
                                              fixedScaleRepository: CoreDataFixedScaleRepository(),
                                              onDutyRepository: CoreDataOnDutyRepository())

        return ScaleDetailsViewController(viewModel: viewModel,
                                          router: router)
    }
    
    func makeWebView(with url: URL) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
}
