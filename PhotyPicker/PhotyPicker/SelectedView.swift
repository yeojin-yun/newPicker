//
//  SelectedView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/08/24.
//

import UIKit
import Photos

class SelectedView: UIView {
    
    let viewModel: ViewModel?
    
    
    var selectedAsset: [PHAsset] = [] {
        didSet {
            collectionView.reloadData()
            print("선택됨")
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
        self.viewModel = ViewModel()
        super.init(frame: .zero)
        print("selectedView init")
        setUI()
        collectionView.backgroundColor = .red
//        viewModel = ViewModel()
        viewModel?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectedView: ViewModelDelegate {

    func getNewAsset(_ assetArray: [PHAsset]) {
        print("delegate")
        self.selectedAsset = assetArray
    }
}

extension SelectedView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(selectedAsset.count)
        return selectedAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as? TopCollectionViewCell else { fatalError() }
        cell.setImage(asset: selectedAsset[indexPath.item])
        cell.backgroundColor = .yellow
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
