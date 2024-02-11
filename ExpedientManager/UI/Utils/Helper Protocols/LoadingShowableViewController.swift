//
//  LoadingShowableViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 08/02/24.
//

import UIKit

public protocol LoadingShowableViewControllerProtocol: UIViewController {
    var loadingView: LoadingView? { get set }
    
//    func showLoadingView()
//    func disableLoadingView()
}

extension UIViewController {
    
    public func disableLoadingView() {
        guard presentedViewController is UIAlertController else { return }
        dismiss(animated: true)
    }
    
    public func showLoadingView() {
        let alert = LoadingContainerViewController()
        alert.modalPresentationStyle = .custom
        alert.transitioningDelegate = transitionsFactory.makeBottomSheetTransitionManager()
        present(alert, animated: true, completion: nil)
    }
}
