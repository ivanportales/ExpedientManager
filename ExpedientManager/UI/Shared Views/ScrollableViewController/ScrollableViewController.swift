//
//  ScrollableViewController.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 02/03/24.
//

import UIKit

class ScrollableViewController: UIViewController {
    
    // MARK: - UI
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white

        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        return contentView
    }()
    
    open func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    open func setupConstraints() {
        scrollView.constraintViewToSuperview()
        contentView.constraintViewToSuperview()
        
        let contentViewHeightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightAnchor.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentViewHeightAnchor,
        ])
    }
}
