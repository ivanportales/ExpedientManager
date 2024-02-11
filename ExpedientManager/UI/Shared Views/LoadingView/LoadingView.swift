//
//  LoadingView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 09/02/24.
//

import UIKit

public final class LoadingView: UIView {
    
    // MARK: - UI
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.style = .large
        loadingView.color = .white
        
        return loadingView
    }()
    
    lazy var blurBackgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    // MARK: - Inits

    init() {
        super.init(frame: .zero)
        setupView()
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Exposed Functions
    
    func startLoadingAnimation() {
        loadingView.startAnimating()
    }
    
    func stopLoadingAnimation() {
        loadingView.stopAnimating()
    }
}

// MARK: - Setup Functions

extension LoadingView {
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    private func setupViewHierarchy() {
        addSubview(blurBackgroundView)
        blurBackgroundView.contentView.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        blurBackgroundView.constraintViewToSuperview()
        loadingView.constraintViewToCenterOfSuperview()
    }
}
