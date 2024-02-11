//
//  LoadingContainerViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/02/24.
//

import UIKit

final class LoadingContainerViewController: UIViewController {
    
    // MARK: - UI
    
    lazy var loadingView: LoadingView = {
        return LoadingView()
    }()
    
    // MARK: - Inits
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingView.startLoadingAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingView.stopLoadingAnimation()
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        view.backgroundColor = .clear
    }
    
    private func setupViewHierarchy() {
        view.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        loadingView.constraintViewToSuperview()
    }
}
