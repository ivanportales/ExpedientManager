//
//  ScrollView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/23/24.
//

import Foundation
import UIKit

class ScrollToKeyboardAvoiding: UIScrollView {
    
    private var offsetAddedWithKeyboard: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }
    
    private func commonInit() {
        self.addObserverToScroll()
        self.keyboardDismissMode = .onDrag
    }

    private func addObserverToScroll() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame: CGRect? = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let firstResponderTextField: UIView? = self.findFirstResponder(inView: self)

        if firstResponderTextField != nil && keyboardFrame != nil {
            let convertedKeyboardFrame: CGRect? = self.convert(keyboardFrame!, from: nil)
            let convertedFirstResponder: CGRect? = self.convert(firstResponderTextField!.frame, from: firstResponderTextField?.superview)
            let convertedFirstResponderMaxYPositionInScrollView: CGFloat = convertedFirstResponder?.maxY ?? 0
            let acessoryViewHeight: CGFloat = firstResponderTextField!.inputAccessoryView?.frame.height ?? 0
            let keyboardMinY: CGFloat = convertedKeyboardFrame?.minY ?? 0
            let keyboardAndAcessoryViewMinY: CGFloat = keyboardMinY - acessoryViewHeight
            let difference: CGFloat = keyboardAndAcessoryViewMinY - convertedFirstResponderMaxYPositionInScrollView
            
            if difference < 0 {
                self.offsetAddedWithKeyboard = -difference
                self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y-difference), animated: false)
            } else {
                self.offsetAddedWithKeyboard = 0
            }
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        if let offset = self.offsetAddedWithKeyboard, !self.isDragging, self.contentOffset.y-offset >= 0 {
            self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y-offset), animated: false)
        }
        self.offsetAddedWithKeyboard = nil
    }
}
