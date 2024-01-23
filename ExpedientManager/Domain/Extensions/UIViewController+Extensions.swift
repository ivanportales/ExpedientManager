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

// MARK: - Views Makers Functions

extension UIView {
    static func makeLabelWith(text: String,
                              font: UIFont? = .systemFont(ofSize: 15),
                              color: UIColor = .white) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = font
        label.textColor = color
        
        return label
    }
    
    static func makeStackWith(axis: NSLayoutConstraint.Axis = .vertical,
                              distribution: UIStackView.Distribution = .fill,
                              alignment: UIStackView.Alignment = .fill,
                              spacing: CGFloat = 5) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = distribution
        stack.axis = axis
        
        return stack
    }
}

// MARK: - Constraints Functions

extension UIView {
    func constraintViewToSuperview(top: CGFloat = 0,
                                   leading: CGFloat = 0,
                                   trailing: CGFloat = 0,
                                   bottom: CGFloat = 0) {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
        ])
    }
    
    func constraintViewToSuperviewOnly(top: CGFloat? = nil,
                                       leading: CGFloat? = nil,
                                       trailing: CGFloat? = nil,
                                       bottom: CGFloat? = nil) {
        guard let superview = superview else { return }
        
        if let top = top {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
        }
    }
    
    func constraintViewTouperview() {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor),
            bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor)
        ])
    }
    
    func constraintView(height: CGFloat, andWidth width: CGFloat) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height),
            widthAnchor.constraint(equalToConstant: width),
        ])
    }
    
    func constraintView(height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func constraintView(width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
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
