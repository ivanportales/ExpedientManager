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
    
    lazy var advanceButton: ButtonView = {
        let advanceButton = ButtonView(title: LocalizedString.nextButton,
                                       backgroundColor: .appDarkBlue) { [weak self] _ in
            self?.didTapButton()
        }
        
        
        return advanceButton
    }()
    
    // MARK: - Private Properties
    
    private let router: DeeplinkRouterProtocol
    private let setValueForKeyUseCase: SetValueForKeyUseCaseProtocol
    private let models: [OnboardingCarouselItem] = [
        OnboardingCarouselItem(image: "onboarding0", message: LocalizedString.onboardingMsg1),
        OnboardingCarouselItem(image: "onboarding1", message: LocalizedString.onboardingMsg2),
        OnboardingCarouselItem(image: "onboarding2", message: LocalizedString.onboardingMsg3),
    ]
    
    // MARK: - Init
    
    init(router: DeeplinkRouterProtocol,
         setValueForKeyUseCase: SetValueForKeyUseCaseProtocol) {
        self.router = router
        self.setValueForKeyUseCase = setValueForKeyUseCase
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
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            carouselView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            carouselView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            advanceButton.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 30),
            advanceButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            advanceButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            advanceButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40),
        ])
    }
}

// MARK: - Private Functions

private extension OnboardingViewController {
    func didTapButton() {
        if carouselView.canScrollToNextItem() {
            carouselView.scrollToNextItem()
            if !carouselView.canScrollToNextItem() {
                advanceButton.change(text: LocalizedString.getStartButton)
            }
        } else {
            router.pop()
            setValueForKeyUseCase.save(value: true, forKey: .hasOnboarded)
        }
    }
}
