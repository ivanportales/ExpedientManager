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
    
    // MARK: - Exposed Functions
    
    func displayLargeNavigationBarTitle(_ showLargeTitle: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = showLargeTitle
    }
    
    func setupNavigationBarItemOn(position: NavigationItemPosition,
                                  withIcon icon: UIImage? = nil,
                                  withTitle title: String? = nil,
                                  color: UIColor,
                                  and completion: @escaping (ClosureButtonView) -> Void) {
        guard icon != nil || title != nil else { return }
        var button: ClosureButtonView!
        if let icon = icon {
            button = ClosureButtonView(icon: icon, color: color, touchDownCompletion: completion)
        } else if let title = title {
            button = ClosureButtonView(title: title, textColor: color, font: .poppinsSemiboldOf(size: 16), touchDownCompletion: completion)
        }
        
        let barButton = UIBarButtonItem(customView: button)

        switch position {
        case .left:
            if var leftBarButtonItems = navigationItem.leftBarButtonItems {
                leftBarButtonItems.append(barButton)
                navigationItem.leftBarButtonItems = leftBarButtonItems
            } else {
                navigationItem.leftBarButtonItems = [barButton]
            }
        case .right:
            if var rightBarButtonItems = navigationItem.rightBarButtonItems {
                rightBarButtonItems.append(barButton)
                navigationItem.rightBarButtonItems = rightBarButtonItems
            } else {
                navigationItem.rightBarButtonItems = [barButton]
            }
        }
    }
    
    func showNavigationBarButtonFrom(position: NavigationItemPosition, andIndex index: Int) {
        toggleNavigationBarButton(at: position, andIndex: index, isEnabled: true, isHidden: false)
    }

    func hideNavigationBarButtonFrom(position: NavigationItemPosition, andIndex index: Int) {
        toggleNavigationBarButton(at: position, andIndex: index, isEnabled: false, isHidden: true)
    }
    
    // MARK: - Private Functions
    
    private func toggleNavigationBarButton(at position: NavigationItemPosition,
                                           andIndex index: Int,
                                           isEnabled: Bool,
                                           isHidden: Bool) {
        var barButtonItems: [UIBarButtonItem]?

        switch position {
        case .left:
            barButtonItems = navigationItem.leftBarButtonItems
        case .right:
            barButtonItems = navigationItem.rightBarButtonItems
        }

        guard let items = barButtonItems, items.indices.contains(index) else { return }

        let item = items[index]
        item.isEnabled = isEnabled
        item.isHidden = isHidden
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

// MARK: - Alert Extension

extension UIViewController {
    func showAlertWith(title: String, andMesssage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
