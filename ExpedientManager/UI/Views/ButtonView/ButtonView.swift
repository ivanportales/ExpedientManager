//
//  ButtonView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 20/01/24.
//

import UIKit

public final class ButtonView: ClosureButtonView {
    
    
    override init(title: String,
                  color: UIColor,
                  touchDownCompletion: ((ClosureButtonView) -> Void)?) {
        super.init(title: title, color: color, touchDownCompletion: touchDownCompletion)
        contentEdgeInsets = .init(top: 15, left: 0, bottom: 15, right: 0)
        cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
