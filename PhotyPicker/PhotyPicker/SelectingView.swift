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

        if viewModel.images[cell.currentIndex].selectedNumber != nil {

            // 이미 배열 속에 들어있다면? 제거돼야지!!
            guard let selectedNumber = viewModel.images[cell.currentIndex].selectedNumber else { return } //3
            
            viewModel.selectedAsset.remove(at: selectedNumber - 1)
            
            
            print("selectedNumber", selectedNumber, "vs", "selectedAsset", viewModel.selectedAsset.count)
            
            //제거된 에셋의 selectedNumber를 nil으로 바꿔야하고, 남은 에셋의 selectedNumber를 재조정해줘야 함
            if selectedNumber <= viewModel.selectedAsset.count { // 에셋을 뺐다.
                
                viewModel.images = viewModel.images.map {
//                    print("$0.selectedNumber", $0.selectedNumber)
                    guard var number = $0.selectedNumber else { return ImageData(image: $0.image, selectedNumber: nil) }
                    print("guard", number)
                    // 선택되었다.
                    if number > selectedNumber {
                        number -= 1
                        print("number", number)
                    } else {
                        
                    }
                    return ImageData(image: $0.image, selectedNumber: number)
                }
                print(viewModel.images[cell.currentIndex].selectedNumber)
                cell.setCheckMark(index: viewModel.images[cell.currentIndex].selectedNumber)
                // 선택되지 않는 cell들은 어떻게 하나
                // 여기서는 다른 indexPath를 다룰 수 없음
            }

            viewModel.images[cell.currentIndex].selectedNumber = nil
            // 번호가 reload되지 않음
            cell.setCheckMark(index: viewModel.images[cell.currentIndex].selectedNumber)
            print("💊",viewModel.images[cell.currentIndex].selectedNumber)
        } else {
            // 선택된 적이 없으면
            viewModel.selectedAsset.append(viewModel.images[cell.currentIndex].image)
            viewModel.images[cell.currentIndex].selectedNumber = viewModel.selectedAsset.count
            //guard let number = viewModel.images[cell.currentIndex].selectedNumber else { return }
            cell.setCheckMark(index: viewModel.selectedAsset.count)
        }
//
        // 총 5개
        // 선택 : 1번 & 3번 & 4번 선택
        // ImageData(image: asset1, selectedNumber: 1)
        // ImageData(image: asset2, selectedNumber: nil)
        // ImageData(image: asset3, selectedNumber: 2)
        // ImageData(image: asset4, selectedNumber: 3)
        // ImageData(image: asset5, selectedNumber: nil)
        
        // 선택해제 : 3번 해제
        // ImageData(image: asset1, selectedNumber: 1)
        // ImageData(image: asset2, selectedNumber: nil)
        // 🩸 ImageData(image: asset3, selectedNumber: nil)
        // ImageData(image: asset4, selectedNumber: 2)
        // ImageData(image: asset5, selectedNumber: nil)
        
        
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
        
    // 저것이 성립하려면 셀을 누르기 전에 인덱스별로 images 배열이 구성되어 있어야 함
        
//        if images[cell.index].selectedNumber != nil {
//            guard let selectedNumber = images[cell.index].selectedNumber else {return}
//            selectedImages.remove(at: selectedNumber - 1)
//
//            if selectedNumber <= selectedImages.count { //A
//                images = images.map{
//                    guard var number = $0.selectedNumber else {return ImageData(image: $0.image, selectedNumber: nil)}
//                    if number > selectedNumber {
//                        number -= 1
//                    }
//                    return ImageData(image: $0.image, selectedNumber: number)
//                }
//            }
//
//            images[cell.index].selectedNumber = nil
//        } else {
//            ...
//        }
//        imageCollectionView.reloadData()
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
