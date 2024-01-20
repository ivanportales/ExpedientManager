//
//  OnboardingViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/25/24.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - UI
    
    lazy var carouselView: CarouselView = {
        return CarouselView(models: models,
                            userInteractionIsEnabled: false)
    }()
    
    lazy var advanceButton: ClosureBasedUIButton = {
        let advanceButton = ClosureBasedUIButton(title: "Avançar") { [weak self] _ in
            self?.didTapButton()
        }
        advanceButton.backgroundColor = .appLightBlue
        
        return advanceButton
    }()
    
    // MARK: - Private Properties
    
    private let router: DeeplinkRouterProtocol
    private let localStorage: LocalStorageRepositoryProtocol
    private let models: [OnboardingCarouselItem] = [
        OnboardingCarouselItem(image: "onboarding0", message: LocalizedString.onboardingMsg1),
        OnboardingCarouselItem(image: "onboarding1", message: LocalizedString.onboardingMsg2),
        OnboardingCarouselItem(image: "onboarding2", message: LocalizedString.onboardingMsg3),
    ]
    
    // MARK: - Init
    
    init(router: DeeplinkRouterProtocol,
         localStorage: LocalStorageRepositoryProtocol) {
        self.router = router
        self.localStorage = localStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViewHierarchy()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

// "nextButton"

extension OnboardingViewController {
    func didTapButton() {
        if carouselView.canScrollToNextItem() {
            carouselView.scrollToNextItem()
            if !carouselView.canScrollToNextItem() {
                advanceButton.setTitle(LocalizedString.getStartButton, for: .normal)
            }
        } else {
            router.pop()
            localStorage.save(value: true, forKey: .hasOnboarded)
        }
    }
}

// MARK: - Setup Functions

extension OnboardingViewController {
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupViewHierarchy() {
        view.addSubview(carouselView)
        view.addSubview(advanceButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            advanceButton.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 20),
            advanceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            advanceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            advanceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
}
