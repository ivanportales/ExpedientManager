//
//  LoadingShowableViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 08/02/24.
//

import UIKit



public protocol LoadingShowableViewControllerProtocol: UIViewController {
    var loadingView: LoadingView? { get set }

    func showLoadingView()
    func disableLoadingView()
}

extension LoadingShowableViewControllerProtocol {

    public func disableLoadingView() {
        guard loadingView != nil else { return }
        
        setupNavigationBarTo(enableItems: true)
        
        loadingView?.stopLoadingAnimation()
        loadingView?.removeFromSuperview()
        
        loadingView = nil
    }

    public func showLoadingView() {
        guard loadingView == nil else { return }
        
        setupNavigationBarTo(enableItems: false)
        
        let loadingView = LoadingView()
        loadingView.startLoadingAnimation()
        
        view.addSubview(loadingView)
        loadingView.constraintViewToSuperview()
        
        self.loadingView = loadingView
    }
    
    private func setupNavigationBarTo(enableItems: Bool) {
        if navigationItem.rightBarButtonItems != nil {
            for barButtonItem in navigationItem.rightBarButtonItems! {
                barButtonItem.isEnabled = enableItems
            }
        }
    }
}
