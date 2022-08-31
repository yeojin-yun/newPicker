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
            print("ddd")
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
        cell.setCheckMark(index: viewModel.images[cell.currentIndex].selectedNumber)
        
        return cell
    }
}

extension SelectingView: BottomCellDelegate {
    
    func didPressCheckButton(_ cell: BottomCollectionViewCell) {

        if viewModel.images[cell.currentIndex].selectedNumber != nil {

            // 이미 배열 속에 들어있다면? 제거돼야지!!
            guard let selectedNumber = viewModel.images[cell.currentIndex].selectedNumber else { return } //3
            
            viewModel.selectedAsset.remove(at: selectedNumber - 1)
            viewModel.images[cell.currentIndex].selectedNumber = nil
            
//            print("selectedNumber", selectedNumber, "vs", "selectedAsset", viewModel.selectedAsset.count)

            //제거된 에셋의 selectedNumber를 nil으로 바꿔야하고, 남은 에셋의 selectedNumber를 재조정해줘야 함
            viewModel.images = viewModel.images.map {
                guard var number = $0.selectedNumber else { return ImageData(image: $0.image, selectedNumber: nil) }
//                print("guardNumber", number)
                if number > selectedNumber {
                    number -= 1
//                    print("number", number)
                }
                return ImageData(image: $0.image, selectedNumber: number)
            }
//            print("currentIndex:", cell.currentIndex)
//            dump(viewModel.images)
//            print("current:", viewModel.images[cell.currentIndex].selectedNumber)
            cell.setCheckMark(index: viewModel.images[cell.currentIndex].selectedNumber)
            collectionView.reloadData()
        } else {
            // 선택된 적이 없으면
            viewModel.selectedAsset.append(viewModel.images[cell.currentIndex].image)
            viewModel.images[cell.currentIndex].selectedNumber = viewModel.selectedAsset.count
            //guard let number = viewModel.images[cell.currentIndex].selectedNumber else { return }
            cell.setCheckMark(index: viewModel.selectedAsset.count)
        }
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
