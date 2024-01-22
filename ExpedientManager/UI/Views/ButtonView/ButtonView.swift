//
//  ButtonView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 20/01/24.
//

import UIKit

public final class ButtonView: ClosureButtonView {
    
    // MARK: -  UI
    
    override init(title: String,
                  color: UIColor,
                  touchDownCompletion: ((ClosureButtonView) -> Void)?) {
        super.init(title: title, color: color, touchDownCompletion: touchDownCompletion)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Functions
    
    override func setupStyleWith(title: String,
                                 backgroundColor: UIColor,
                                 textColor: UIColor = .white,
                                 font: UIFont = .poppinsRegularOf(size: 16)) {
        privateTextAttributes = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        var buttonConfig = UIButton.Configuration.filled()

        buttonConfig.attributedTitle = .init(title, attributes: AttributeContainer(privateTextAttributes))
        buttonConfig.baseBackgroundColor = backgroundColor
        buttonConfig.contentInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 0)
        buttonConfig.cornerStyle = .capsule
        
        configuration = buttonConfig
    }
}
