//
//  TextView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 23/01/24.
//

import UIKit

final class TextView: UITextView {
    
    // MARK: - Private Properties

    private let padding: UIEdgeInsets
    private let placeholder: String
    private let placeholderTextColor: UIColor
    private let inputTextColor: UIColor
    private var isPlaceholderVisible: Bool = true
    
    // MARK: - Inits
    
    init(placeholder: String,
         placeholderTextColor: UIColor = .lightGray,
         font: UIFont = .poppinsRegularOf(size: 16),
         textColor: UIColor,
         backgroundColor: UIColor = .background2,
         padding: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)) {
        self.placeholder = placeholder
        self.placeholderTextColor = placeholderTextColor
        self.inputTextColor = textColor
        self.padding = padding
        super.init(frame: .zero, textContainer: nil)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.font = font
        self.textColor = placeholderTextColor
        text = placeholder
        delegate = self
        layer.cornerRadius = 10
        textContainerInset = padding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextViewDelegate

extension TextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderVisible {
            text = nil
            textColor = inputTextColor
            isPlaceholderVisible = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            text = placeholder
            textColor = placeholderTextColor
            isPlaceholderVisible = true
        }
    }
}
