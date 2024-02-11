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
        
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.style = .large
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
