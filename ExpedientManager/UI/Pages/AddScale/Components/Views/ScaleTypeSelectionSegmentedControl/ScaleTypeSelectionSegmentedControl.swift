//
//  ScaleTypeSelectionSegmentedControl.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 24/01/24.
//

import Foundation

import UIKit

final class ScaleTypeSelectionSegmentedControl: UISegmentedControl {
    

    // MARK: - Inits
    
    init(segmentsTitles: [String]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViewAppearence()
        setup(segmentsTitles: segmentsTitles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewAppearence()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewAppearence()
    }
    
    // MARK: - Setup Functions

    private func setupViewAppearence() {
        tintColor = UIColor.card
        backgroundColor = UIColor.card
        layer.cornerRadius = 20
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
    private func setup(segmentsTitles: [String]) {
        for (index, segmentsTitle) in segmentsTitles.enumerated() {
            insertSegment(withTitle: segmentsTitle, at: index, animated: false)
        }
        
        let font = UIFont.poppinsLightOf(size: 18)
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: font
        ]
        setTitleTextAttributes(normalTextAttributes, for: .normal)

        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font,
        ]
        setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        selectedSegmentIndex = 0
        selectedSegmentTintColor = .appLightBlue
    }
}
