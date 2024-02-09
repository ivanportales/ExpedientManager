//
//  UIView+Extensions.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 25/01/24.
//

import UIKit

// MARK: - Views Makers Functions

extension UIView {
    static func makeLabelWith(text: String,
                              font: UIFont = .poppinsRegularOf(size: 16),
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
    
    func constraintViewToCenterOfSuperview() {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor),
            bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor),
            
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
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

// MARK: - Helper Functions

extension UIView {
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
}
