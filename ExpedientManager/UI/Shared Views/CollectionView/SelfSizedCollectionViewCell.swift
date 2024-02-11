//
//  SelfSizedCollectionViewCell.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 26/01/24.
//

import UIKit

class SelfSizedCollectionViewCell: UICollectionViewCell {
    
    // MARK: -  Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("This view does not support Storyboard!")
    }
    
    // MARK: - Internal Functions
    
    internal func cellSizeCalculator(intrinsicCellSize: CGSize) -> CGSize? {
        return nil
    }
    
    // MARK: - Override Functions

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if let calculatedCellSize = cellSizeCalculator(intrinsicCellSize: preferredAttributes.size) {
            preferredAttributes.size = calculatedCellSize
        }

        return preferredAttributes // By default, the size of the cell will be the size of its content
    }
}
