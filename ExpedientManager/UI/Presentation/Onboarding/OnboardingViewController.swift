//
//  OnboardingViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/25/24.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var holderView: UIView!
    
    let scrollView: UIScrollView = UIScrollView()
    
    private let router: DeeplinkRouterProtocol
    private let localStorage: LocalStorageRepositoryProtocol
    
    let descriptions: [String] = [
        LocalizedString.onboardingMsg1,
        LocalizedString.onboardingMsg2, 
        LocalizedString.onboardingMsg3
    ]
    
    init(router: DeeplinkRouterProtocol,
         localStorage: LocalStorageRepositoryProtocol) {
        self.router = router
        self.localStorage = localStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureView()
    }
}

extension OnboardingViewController {
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 3 else {
            router.pop()
            localStorage.save(value: true, forKey: .hasOnboarded)
            return
        }
        
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
}

extension OnboardingViewController {
    
    private func configureView() {
        scrollView.frame = holderView.bounds
        scrollView.showsHorizontalScrollIndicator = false
        holderView.addSubview(scrollView)
        
        for x in 0..<3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            let button = UIButton(frame: CGRect(x: (pageView.frame.size.width/2)-40, y: 0, width: pageView.frame.size.width - 20, height: 50))
        
            let imageView = UIImageView(frame: CGRect(x: 10, y: pageView.frame.size.height/6, width: pageView.frame.size.width - 20, height: pageView.frame.size.height/2))
            
            let label = UILabel(frame: CGRect(x: 50, y: pageView.frame.size.height/1.45, width: pageView.frame.size.width-100, height: 120))
            
            label.textAlignment = .center
            label.text = descriptions[x]
            label.font = UIFont(name: "Poppins-Regular", size: 16)
            label.numberOfLines = 0
            pageView.addSubview(label)
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "onboarding\(x)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.appLightBlue, for: .normal)
            button.setTitle(LocalizedString.nextButton, for: .normal)
            button.titleLabel?.font = UIFont(name: "Poppins-Semibold", size: 16)
            if x == 2 {
                button.setTitle(LocalizedString.getStartButton, for: .normal)
                
                let toplabel = UILabel(frame: CGRect(x: 65, y:60, width: pageView.frame.size.width-120, height: 120))
                toplabel.textAlignment = .center
                toplabel.text = "Escolha entre dois tipos de escala:"
                toplabel.font = UIFont(name: "Poppins-Regular", size: 16)
                toplabel.numberOfLines = 0
                pageView.addSubview(toplabel)
            }
            button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            button.tag = x+1
            pageView.addSubview(button)
            
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width*3, height: 0)
        scrollView.isPagingEnabled = true
    }
}
