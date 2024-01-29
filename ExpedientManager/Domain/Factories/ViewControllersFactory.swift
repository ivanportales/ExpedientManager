//
//  ViewControllersFactory.swift
//  destiny2AssistentApp
//
//  Created by Gonzalo Ivan Santos Portales on 01/08/22.
//

import Foundation
import SafariServices

final class ViewControllersFactory {
    
    private let localStorage: LocalStorageRepositoryProtocol = LocalStorageRepository()
    private let router: DeeplinkRouterProtocol
    
    init(router: DeeplinkRouterProtocol) {
        self.router = router
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController(router: router,
                                        localStorage: localStorage)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let scheduledNotificationsRepository = CoreDataScheduledNotificationsRepository()
        let viewModel = HomeVideModel(scheduledNotificationsRepository: scheduledNotificationsRepository,
                                      localStorage: localStorage)

        return HomeViewController(viewModel: viewModel, router: router)
    }
    
    func makeAddScaleViewController() -> BaseScaleViewController {
        let viewModel = AddScaleViewModel(scheduler: UserNotificationsManager(),
                                          scheduledNotificationsRepository: CoreDataScheduledNotificationsRepository(),
                                          fixedScaleRepository: CoreDataFixedScaleRepository(),
                                          onDutyRepository: CoreDataOnDutyRepository())

        return BaseScaleViewController(viewModel: viewModel, router: router)
    }
    
    func makeScalesListViewController() -> ScalesListViewController {
        let viewModel = ScalesListViewModel(fixedScaleRepository: CoreDataFixedScaleRepository(),
                                            onDutyRepository: CoreDataOnDutyRepository())

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
