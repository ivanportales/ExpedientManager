//
//  LoadingShowableViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 08/02/24.
//

import UIKit

extension UIViewController {
    public func disableLoadingView() {
        guard presentedViewController is LoadingContainerViewController else { return }
        dismiss(animated: true)
    }
    
    public func showLoadingView() {
        let alert = LoadingContainerViewController()
        alert.modalPresentationStyle = .custom
        alert.transitioningDelegate = CustomAlertTransitionManager(duration: 0.5)
        present(alert, animated: true, completion: nil)
    }
}
