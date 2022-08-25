//
//  SelectedView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/08/24.
//

import UIKit
import Photos

class SelectedView: UIView {
    
    var selectedAsset: [PHAsset] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    

    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let width = UIScreen.main.bounds.width / 5
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = CollectionViewCell.cellSpacing
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(asset: [PHAsset]) {
        self.selectedAsset = asset
        super.init(frame: .zero)
        setUI()
        collectionView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelectedView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as? TopCollectionViewCell else { fatalError() }
        cell.setImage(asset: selectedAsset[indexPath.item])

        return cell
    }
}

extension SelectedView: UICollectionViewDelegate {
    
}

extension SelectedView {
    func setUI() {
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
