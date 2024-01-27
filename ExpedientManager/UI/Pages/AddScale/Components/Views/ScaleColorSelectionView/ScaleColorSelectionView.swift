//
//  ScaleColorSelectionView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 25/01/24.
//

import UIKit

final class ScaleColorSelectionView: UICollectionView {

    // MARK: - Override Properties
    
    override var contentSize: CGSize {
        didSet {
            guard viewWithSameSizeAsContent else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        guard viewWithSameSizeAsContent else {
            return super.intrinsicContentSize
        }
        layoutIfNeeded()
        
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    // MARK: - Private Properties
    
    private let viewWithSameSizeAsContent: Bool
    
    // MARK: - Private Properties
    
    private lazy var selectedColor: UIColor = colors.first ?? .clear
    
    private let colors = [
        UIColor(hex: "#0000FF"),
        UIColor(hex: "#FF2D55"),
        UIColor(hex: "#00FF00"),
        UIColor(hex: "#800080"),
        UIColor(hex: "#FF8000"),
        UIColor(hex: "#FF8000"),
    ]
    
    // MARK: - Inits
    
    init(viewWithSameSizeAsContent: Bool = true) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.viewWithSameSizeAsContent = viewWithSameSizeAsContent
        super.init(frame: .zero, collectionViewLayout: layout)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .card
        layer.cornerRadius = 10
        delegate = self
        dataSource = self
        register(ScaleColorSelectionCellView.self,
                 forCellWithReuseIdentifier: ScaleColorSelectionCellView.cellIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Functions

private extension ScaleColorSelectionView {
    
    func setupViewConstraints() {
        
    }
}

// MARK: - UICollectionViewDataSource

extension ScaleColorSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScaleColorSelectionCellView.cellIdentifier,
                                                            for: indexPath) as? ScaleColorSelectionCellView else {
            return UICollectionViewCell()
        }
        
        cell.set(color: colors[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.item]
    }
}

extension ScaleColorSelectionView: UICollectionViewDelegateFlowLayout {}
