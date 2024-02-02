//
//  ScaleColorSelectionCellView.swft.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 25/01/24.
//

import UIKit

final class ScaleColorSelectionCellView: SelfSizedCollectionViewCell {
    
    static let cellIdentifier = "ScaleColorSelectionCellView"
    
    // MARK: -  UI
    
    lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 8
        
        return colorView
    }()
    
    // MARK: - Overrides Properties
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderWidth = 3
                self.layer.borderColor = UIColor.appDarkBlue.cgColor
            } else {
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    // MARK: -  Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupViewHierarchy()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("This view does not support Storyboard!")
    }
    
    // MARK: - Public Functions
    
    func set(color: UIColor) {
        colorView.backgroundColor = color
    }
    
    override func cellSizeCalculator(intrinsicCellSize: CGSize) -> CGSize? {
        let width: CGFloat = 40
        let height: CGFloat = 40
    
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Internal Functions
        
    internal func setupView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    internal func setupViewHierarchy() {
        contentView.addSubview(colorView)
    }
    
    internal func setupViewConstraints() {
        colorView.constraintViewToSuperview()
    }
}
