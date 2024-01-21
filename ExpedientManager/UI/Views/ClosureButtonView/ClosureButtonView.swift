//
//  ClosureButtonView.swift
//  eveEchoesCompanionApp
//
//  Created by Gonzalo Ivan Santos Portales on 16/05/22.
//

import UIKit

public class ClosureButtonView: UIButton {
    
    // MARK: - Exposed Properties
    
    public var touchDownCompletion: ((ClosureButtonView) -> Void)?
    
    // MARK: - Inits
    
    init(title: String,
         color: UIColor,
         touchDownCompletion: ((ClosureButtonView) -> Void)?) {
        super.init(frame: .zero)
        self.touchDownCompletion = touchDownCompletion
        translatesAutoresizingMaskIntoConstraints = false
        setupStyleWith(title: title, color: color)
        setupCompletion()
    }
    
    init(icon: UIImage,
         color: UIColor,
         touchDownCompletion: ((ClosureButtonView) -> Void)?) {
        super.init(frame: .zero)
        self.touchDownCompletion = touchDownCompletion
        translatesAutoresizingMaskIntoConstraints = false
        setupStyleWith(icon: icon, color: color)
        setupCompletion()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCompletion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Functions
    
    internal func setupStyleWith(title: String,
                                 color: UIColor) {
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.title = title
        buttonConfig.baseBackgroundColor = color
        
        configuration = buttonConfig
    }
    
    internal func setupStyleWith(icon: UIImage,
                                 color: UIColor) {
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.image = icon
        buttonConfig.baseForegroundColor = color
        
        configuration = buttonConfig
    }
    
    // MARK: - Private Functions
    
    private func setupCompletion() {
        addTarget(self, action: #selector(touchDownTarget), for: .touchDown)
    }
    
    @objc private func touchDownTarget() {
        touchDownCompletion?(self)
    }
}
