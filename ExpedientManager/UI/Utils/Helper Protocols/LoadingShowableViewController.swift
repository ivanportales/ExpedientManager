//
//  LoadingShowableViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 08/02/24.
//

import UIKit

public protocol LoadingShowableViewControllerProtocol: UIViewController {
    var loadingView: UIActivityIndicatorView? { get set }
    
    func showLoadingView()
    func disableLoadingView()
}

extension LoadingShowableViewControllerProtocol {
    
    public func disableLoadingView() {
        guard let _ = loadingView else { return }
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    public func showLoadingView() {
        if let _ = loadingView {
            return
        }
        let loadingView = makeLoadingView()
        loadingView.startAnimating()
        view.addSubview(loadingView)
        loadingView.constraintViewToCenterOfSuperview()
        self.loadingView = loadingView
    }
    
    private func makeLoadingView() -> UIActivityIndicatorView {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.style = .large
        
        return loadingView
    }
}
