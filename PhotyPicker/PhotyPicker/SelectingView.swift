//
//  SelectingView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/08/24.
//

import UIKit
import Photos

//protocol SelectingViewDelegate: AnyObject {
//    func didSelectToItem(at index: Int)
//}

class SelectingView: UIView {
    
    
    public var fetchResult: PHFetchResult<PHAsset> {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let viewModel = ViewModel()
    
//    weak var delegate: SelectingViewDelegate?

    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (CollectionViewCell.viewWidth - CollectionViewCell.cellSpacing * (CollectionViewCell.cellColumns - 1)) / CollectionViewCell.cellColumns
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = CollectionViewCell.cellSpacing
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(phAsset: PHFetchResult<PHAsset>) {
        self.fetchResult = phAsset
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else { fatalError() }
        cell.photo.image = fetchResult.object(at: indexPath.item).getAssetThumbnail(size: cell.photo.frame.size)
        cell.currentAsset = fetchResult.object(at: indexPath.item)
        cell.currentIndex = indexPath.item
        cell.delegate = self
        return cell
    }
}

extension SelectingView: BottomCellDelegate {
    
    func didPressCheckButton(_ cell: BottomCollectionViewCell) {

        // 선택된 적이 없으면
        print(cell.currentIndex)
//        viewModel.image
//        if viewModel.images[cell.currentIndex].selectedNumber != nil {
//            // 이미 선택된 적이 있으면
//        } else {
//            // 선택된 적이 없으면
//            let image = viewModel.images[cell.currentIndex].image
//            viewModel.selectedImages.append(image)
//            viewModel.images[cell.currentIndex].selectedNumber = viewModel.selectedImages.count //0번째부터 할당해도 된다
//        }
        collectionView.reloadData()
        
        
//        viewModel.selectedAsset.append(asset)
//        print(viewModel.selectedAsset.count)
//        let count = viewModel.selectedAsset.count
//        
//        let modelCase = AssetModel(asset: asset, count: count)
//        viewModel.likes.append(modelCase)
//        
//        cell.setCheckMark(index: count)
//        cell.checkMark.backgroundColor = .black
//        cell.isSelected = true
    }
}

extension SelectingView {
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
