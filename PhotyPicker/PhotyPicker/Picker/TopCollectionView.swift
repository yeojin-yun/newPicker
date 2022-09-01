//
//  SelectedView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/08/24.
//

import UIKit
import Photos

class TopCollectionView: UIView {
    
    let viewModel: PickerViewModel?
    
    var selectedAsset: [PHAsset] = [] {
        didSet {
            collectionView.reloadData()
            viewModel?.selectedAsset = self.selectedAsset
            print("🟠",selectedAsset)
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
        
        collectionView.dataSource = self
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(asset: [PHAsset]) {
        self.selectedAsset = asset
        self.viewModel = PickerViewModel()
        super.init(frame: .zero)
        print("selectedView init")
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
extension TopCollectionView: PickerDelegate {
    func getNewAsset(_ assetArray: [PHAsset]) {
        //BottomCollectionView에서 assset이 추가되거나 삭제되면 불리게 되는 메서드
        selectedAsset = assetArray
    }
}

// ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
extension TopCollectionView: TopCellDelegate {
    func didPressDeleteButton(_ cell: TopCollectionViewCell) {
        // 삭제를 누르면 발생할 일
        // 1. Top - dataSource에서 해당 이미지 remove
        let indexPath = cell.currentIndex
        print("====",indexPath)
        selectedAsset.remove(at: indexPath)
        
        // Bottom - dataSource에도 적용되도록
        //
    }
}

extension TopCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(selectedAsset.count)
        return selectedAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as? TopCollectionViewCell else { fatalError() }
        cell.setImage(asset: selectedAsset[indexPath.item])
        cell.currentIndex = indexPath.item
        cell.delegate = self
        return cell
    }
}



extension TopCollectionView {
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
