//
//  CarouselView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 18/01/24.
//

import UIKit

final class CarouselView: UIView {
    
    // MARK: - UI
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = userInteractionIsEnabled
        collectionView.backgroundColor = .clear
        collectionView.register(ImageCellView.self,
                                forCellWithReuseIdentifier: ImageCellView.reuseIdentifier)
        
        return collectionView
    }()
    
    // MARK: - Exposed Properties
    
    private(set) var currentShowedItemIndex = 0
    let models: [OnboardingCarouselItem]

    // MARK: - Private Properties
    
    private let userInteractionIsEnabled: Bool
    
    // MARK: - Inits
    
    init(models: [OnboardingCarouselItem],
         userInteractionIsEnabled: Bool = true) {
        self.models = models
        self.userInteractionIsEnabled = userInteractionIsEnabled
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Exposed Functions
    
    func scrollToNextItem() {
        guard canScrollToNextItem() else { return }
        currentShowedItemIndex += 1
        collectionView.scrollToItem(at: IndexPath(item: currentShowedItemIndex, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
    }
    
    func canScrollToNextItem() -> Bool {
        guard (currentShowedItemIndex + 1) < models.count else {
            return false
        }
        return true
    }
    
    // MARK: - Private Functions
    
    private func setupViewHierarchy() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCellView.reuseIdentifier,
            for: indexPath) as? ImageCellView else {
            return UICollectionViewCell()
        }
        let model = models[indexPath.item]
        cell.setupCell(withModel: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
