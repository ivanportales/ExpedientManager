//
//  TextField.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 23/01/24.
//

import UIKit

class TextField: UITextField {
    
    // MARK: - Private Properties

    private let padding: UIEdgeInsets
    
    // MARK: - Inits
    
    init(placeholder: String = "",
         font: UIFont = .poppinsRegularOf(size: 16),
         textColor: UIColor,
         backgroundColor: UIColor = .card,
         padding: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)) {
        self.padding = padding
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.placeholder = placeholder
        self.font = font
        self.textColor = textColor
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Functions
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
