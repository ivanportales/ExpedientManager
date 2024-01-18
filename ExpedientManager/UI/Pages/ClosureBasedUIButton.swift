//
//  ClosureBasedUIButton.swift
//  eveEchoesCompanionApp
//
//  Created by Gonzalo Ivan Santos Portales on 16/05/22.
//

import UIKit

public final class ClosureBasedUIButton: UIButton {
    
    public var touchDownCompletion: ((ClosureBasedUIButton) -> Void)?
    
    init(title: String,
         touchDownCompletion: ((ClosureBasedUIButton) -> Void)?) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        self.touchDownCompletion = touchDownCompletion
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
    
    @objc private func touchDownTarget() {
        touchDownCompletion?(self)
    }
}
