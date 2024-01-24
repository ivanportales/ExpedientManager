//
//  SelectionSegmentedControl.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 24/01/24.
//

import Foundation

import UIKit

protocol SelectionSegmentedControlDelegate: AnyObject {
    func didChangeSelectedIndex(_ view: SelectionSegmentedControl, selectedIndex: Int)
}

final class SelectionSegmentedControl: UISegmentedControl {
    
    // MARK: - Exposed Properties
    
    weak var delegate: SelectionSegmentedControlDelegate?

    // MARK: - Inits
    
    init(segmentsTitles: [String]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViewAppearence()
        setup(segmentsTitles: segmentsTitles)
        setupValueChangeObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewAppearence()
        setupValueChangeObserver()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewAppearence()
        setupValueChangeObserver()
    }
    
    // MARK: - Setup Functions

    private func setupViewAppearence() {
        tintColor = UIColor.white
        backgroundColor = UIColor.white
        layer.cornerRadius = 20
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
    private func setup(segmentsTitles: [String]) {
        for (index, segmentsTitle) in segmentsTitles.enumerated() {
            insertSegment(withTitle: segmentsTitle, at: index, animated: false)
        }
        
        setup(textColor: .lightGray, for: .normal)
        setup(textColor: .white, for: .selected)
        
        selectedSegmentIndex = 0
        selectedSegmentTintColor = .appLightBlue
    }
    
    private func setup(textColor: UIColor,
                       for state: UIControl.State) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.poppinsLightOf(size: 18)
        ]
        setTitleTextAttributes(textAttributes, for: state)
    }
    
    // MARK: - Private Functions
    
    private func setupValueChangeObserver() {
        addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
    }
    
    @objc private func valueDidChange() {
        delegate?.didChangeSelectedIndex(self, selectedIndex: selectedSegmentIndex)
    }
}
