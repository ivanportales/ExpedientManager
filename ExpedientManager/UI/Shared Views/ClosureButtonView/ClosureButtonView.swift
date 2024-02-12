//
//  ClosureButtonView.swift
//  eveEchoesCompanionApp
//
//  Created by Gonzalo Ivan Santos Portales on 16/05/22.
//

import UIKit


public class ClosureButtonView: UIButton {
    
    // MARK: - Override Properties
    
    public override var isEnabled: Bool {
        didSet {
            guard let title = titleLabel?.text,
                  !enabledTextAttributes.isEmpty else { return }
            
            let attributes = isEnabled ? enabledTextAttributes : disabledTextAttributes
            configuration?.attributedTitle = .init(title,
                                                   attributes: AttributeContainer(attributes))
        }
    }
    
    // MARK: - Exposed Properties
    
    public var touchDownCompletion: ((ClosureButtonView) -> Void)?
    
    // MARK: - Internal Properties
    
    internal var enabledTextAttributes: [NSAttributedString.Key: Any] = [:]
    internal var disabledTextAttributes: [NSAttributedString.Key: Any] = [:]
    
    // MARK: - Inits
    
    init(title: String,
         textColor: UIColor = .white,
         backgroundColor: UIColor = .clear,
         font: UIFont = .poppinsRegularOf(size: 16),
         touchDownCompletion: ((ClosureButtonView) -> Void)?) {
        super.init(frame: .zero)
        self.touchDownCompletion = touchDownCompletion
        translatesAutoresizingMaskIntoConstraints = false
        setupStyleWith(title: title, 
                       backgroundColor: backgroundColor,
                       textColor: textColor,
                       font: font)
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
    
    // MARK: - Exposed Functions
    
    public func change(text: String) {
        let attributes = isEnabled ? enabledTextAttributes : disabledTextAttributes
        configuration?.attributedTitle = .init(text, attributes: AttributeContainer(attributes))
    }
    
    // MARK: - Internal Functions
    
    internal func setupStyleWith(title: String,
                                 backgroundColor: UIColor,
                                 textColor: UIColor = .white,
                                 font: UIFont = .poppinsRegularOf(size: 16)) {
        enabledTextAttributes = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        disabledTextAttributes = [
            .font: font,
            .foregroundColor: UIColor.lightGray
        ]
        
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.attributedTitle = .init(title, attributes: AttributeContainer(enabledTextAttributes))
        buttonConfig.baseBackgroundColor = backgroundColor
        buttonConfig.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        configuration = buttonConfig
    }
    
    internal func setupStyleWith(icon: UIImage,
                                 color: UIColor) {
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.image = icon
        buttonConfig.baseForegroundColor = color
        buttonConfig.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

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
