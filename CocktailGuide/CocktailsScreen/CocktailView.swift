//
//  CocktailView.swift
//  CocktailGuide
//
//  Created by Дмитрий on 20.08.2024.
//

import UIKit

final class CocktailView: UIView {
//MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - Properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CoctailCollectionViewCell.self,
                                forCellWithReuseIdentifier: CoctailCollectionViewCell.cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
//MARK: - Functions
    
    private func setupViews() {
        addSubview(collectionView)
    }
    
    func setCollectionView(delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    func setCollectionView(dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

//MARK: - setConstraints
private extension CocktailView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
