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
        let repository = CoreDataScheduledNotificationsRepository()
        let viewModel = HomeVideModel(repository: repository,
                                      localStorage: localStorage)

        return HomeViewController(viewModel: viewModel, router: router)
    }
    
    func makeAddScaleViewController() -> AddScaleViewController {
        let viewModel = AddScaleViewModel(scheduler: UserNotificationService(),
                                          repository: CoreDataScheduledNotificationsRepository(),
                                          fixedScaleRepository: CoreDataFixedScaleRepository(),
                                          onDutyRepository: CoreDataOnDutyRepository())

        return AddScaleViewController(viewModel: viewModel, router: router)
    }
    
    func makeScalesListViewController() -> ScalesListViewController {
        let viewModel = ScalesListViewModel(fixedScaleRepository: CoreDataFixedScaleRepository(),
                                            onDutyRepository: CoreDataOnDutyRepository())

        return ScalesListViewController(viewModel: viewModel, 
                                        router: router)
    }
    
    func makeScalesDetailViewController(viewState: ViewStates,
                                        selectedFixedScale: FixedScale?,
                                        selectedOnDuty: OnDuty?) -> ScaleDetailsViewController {
        let viewModel = ScaleDetailsViewModel(state: viewState,
                                              selectedFixedScale: selectedFixedScale,
                                              selectedOnDuty: selectedOnDuty,
                                              scheduler: UserNotificationService(),
                                              repository: CoreDataScheduledNotificationsRepository(),
                                              fixedScaleRepository: CoreDataFixedScaleRepository(),
                                              onDutyRepository: CoreDataOnDutyRepository())

        return ScaleDetailsViewController(viewModel: viewModel,
                                          router: router)
    }
    
    func makeWebView(with url: URL) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
}
