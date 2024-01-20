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
        setTitle(title, for: .normal)
        backgroundColor = color
        setupCompletion()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCompletion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCompletion() {
        addTarget(self, action: #selector(touchDownTarget), for: .touchDown)
    }
    
    // MARK: - Private Functions
    
    @objc private func touchDownTarget() {
        touchDownCompletion?(self)
    }
}
