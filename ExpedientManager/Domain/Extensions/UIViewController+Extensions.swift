//
//  Extension+UIViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/9/24.
//

import UIKit

// MARK: - NavigationBar Setup Extension

public enum NavigationItemPosition {
    case left, right
}

public extension UIViewController {
    
    func displayLargeNavigationBarTitle(_ showLargeTitle: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = showLargeTitle
    }
    
    func setupNavigationBarItemOn(position: NavigationItemPosition,
                                  withIcon icon: UIImage? = nil,
                                  withTitle title: String? = nil,
                                  color: UIColor,
                                  and completion: @escaping (ClosureBasedUIButton) -> Void) {
        guard icon != nil || title != nil else { return }
        let button = ClosureBasedUIButton()
        if let icon = icon {
            button.setImage(icon, for: .normal)
        } else {
            button.setTitle(title, for: .normal)
        }
        button.imageView?.tintColor = color
        button.touchDownCompletion = completion
        
        let barButton = UIBarButtonItem(customView: button)
        
        switch position {
        case .left:
            if navigationItem.leftBarButtonItems != nil {
                navigationItem.leftBarButtonItems?.append(barButton)
            } else {
                navigationItem.leftBarButtonItems = [barButton]
            }
        case .right:
            if navigationItem.rightBarButtonItems != nil {
                navigationItem.rightBarButtonItems?.append(barButton)
            } else {
                navigationItem.rightBarButtonItems = [barButton]
            }
        }
    }
    
    func hideNavigationBarButtonFrom(position: NavigationItemPosition, andIndex index: Int) {
        switch position {
        case .left:
            guard navigationItem.leftBarButtonItems != nil,
                  navigationItem.leftBarButtonItems!.count > index else { return }
            navigationItem.leftBarButtonItems![index].isEnabled = false
            navigationItem.leftBarButtonItems![index].isHidden = true
        case .right:
            guard navigationItem.rightBarButtonItems != nil,
                  navigationItem.rightBarButtonItems!.count > index else { return }
            navigationItem.rightBarButtonItems![index].isEnabled = false
            navigationItem.rightBarButtonItems![index].isHidden = true
        }
    }
    
    func showNavigationBarButtonFrom(position: NavigationItemPosition, andIndex index: Int) {
        switch position {
        case .left:
            guard navigationItem.leftBarButtonItems != nil,
                  navigationItem.leftBarButtonItems!.count > index else { return }
            navigationItem.leftBarButtonItems![index].isEnabled = true
            navigationItem.leftBarButtonItems![index].isHidden = false
        case .right:
            guard navigationItem.rightBarButtonItems != nil,
                  navigationItem.rightBarButtonItems!.count > index else { return }
            navigationItem.rightBarButtonItems![index].isEnabled = true
            navigationItem.rightBarButtonItems![index].isHidden = false
        }
    }
}


// MARK: - Keyboard Manager Extension

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Spinner Extension

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

// MARK: - Alert Extension

extension UIViewController {
    func showAlertWith(title: String, andMesssage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
