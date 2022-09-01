//
//  SelectingView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/08/24.
//

import UIKit
import Photos

protocol PickerDelegate: AnyObject {
    func getNewAsset(_ assetArray: [PHAsset])
}


class BottomCollectionView: UIView {
    
    weak var delegate: PickerDelegate? {
        didSet {
            print("delegate didSet")
        }
    }

    public var fetchResult: PHFetchResult<PHAsset> {
        didSet {
            collectionView.reloadData()
            print("🩸")
        }
    }
    
    let viewModel = PickerViewModel()
    
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
        fetchResult.enumerateObjects { asset, index, _ in
            let sample = ImageData(image: asset)
            self.viewModel.images.append(sample)
        }
        setUI()
        print("SelectingView init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else { fatalError() }
        cell.photo.image = fetchResult.object(at: indexPath.item).getAssetThumbnail(size: cell.photo.frame.size)
        cell.currentAsset = fetchResult.object(at: indexPath.item)
        cell.currentIndex = indexPath.item
        cell.delegate = self
        cell.setCheckMark(index: viewModel.images[cell.currentIndex].selectedNumber)
        
        return cell
    }
}

// ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
// 1. bottom에서 선택 -> bottom cell에 넘버링 되어야 함,top에 추가가 되어야 함
// 2. bottom에서 선택 해제 -> bottom cell에 넘버링 빠져야 함, top에서 제거되어야 함
// 이 작업이 PickerViewModel에 있는 selectedAsset에서 이루어짐 (다른 변수를 만들어내는 순간 관리가 안됨)
extension BottomCollectionView: BottomCellDelegate {
    
    func didPressCheckButton(_ cell: BottomCollectionViewCell) {

        if viewModel.images[cell.currentIndex].selectedNumber != nil {

            // 이미 배열 속에 들어있다면? 제거돼야지!!
            guard let selectedNumber = viewModel.images[cell.currentIndex].selectedNumber else { return } //3
            
            viewModel.selectedAsset.remove(at: selectedNumber - 1)
            viewModel.images[cell.currentIndex].selectedNumber = nil
            

            viewModel.images = viewModel.images.map {
                guard var number = $0.selectedNumber else { return ImageData(image: $0.image, selectedNumber: nil) }

                if number > selectedNumber {
                    number -= 1

                }
                return ImageData(image: $0.image, selectedNumber: number)
            }
            cell.setCheckMark(index: viewModel.images[cell.currentIndex].selectedNumber)
            collectionView.reloadData()
        } else {
            // 선택된 적이 없으면
            viewModel.selectedAsset.append(viewModel.images[cell.currentIndex].image)
            viewModel.images[cell.currentIndex].selectedNumber = viewModel.selectedAsset.count
            cell.setCheckMark(index: viewModel.selectedAsset.count)
        }
        delegate?.getNewAsset(viewModel.selectedAsset)
    }
}

extension BottomCollectionView {
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
