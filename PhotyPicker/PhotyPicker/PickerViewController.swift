//
//  PickerViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

class PickerViewController: UIViewController {
    var selectedCollection: PHAssetCollection = PHAssetCollection()
    var photosFromCollection: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    var selectedAsset: [PHAsset] = []
    
    let topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var checkSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        setPhotoAuthorization()
        fetchImageFromCollection(collection: self.selectedCollection)
    }

    func setPhotoAuthorization() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            print("권한 받음")
        }
    }
    
//    func checkSelectedBefore(image: UIImage) -> Bool {
//        print(selectedAsset)
//        if selectedAsset.contains(image) {
//            print("true")
//            return true
//        } else {
//            print("false")
//            return false
//        }
//    }
}

extension PickerViewController {
    func fetchImageFromCollection(collection: PHAssetCollection) {
        let fetchOption = PHFetchOptions()
        fetchOption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        self.photosFromCollection = PHAsset.fetchAssets(in: collection, options: fetchOption)
        DispatchQueue.main.async {
            self.bottomCollectionView.reloadData()
        }
    }
}


extension PickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return selectedAsset.count
        } else {
            return photosFromCollection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as? TopCollectionViewCell else { fatalError("No Cell") }
            let image = selectedAsset[indexPath.item]
            cell.setImage(asset: image)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else { fatalError("No Cell") }
            cell.photo.image = photosFromCollection.object(at: indexPath.item).getAssetThumbnail(size: cell.photo.frame.size)
            cell.checkMarkButtonTapped = { [weak self] _ in
                guard let self = self else { return }
                if !self.selectedAsset.contains(self.photosFromCollection.object(at: indexPath.item)) {
                    print("-------")
                    self.selectedAsset.append(self.photosFromCollection.object(at: indexPath.item))
                    print(self.selectedAsset.firstIndex(of: self.photosFromCollection.object(at: indexPath.item)))
                    guard let index = self.selectedAsset.firstIndex(of: self.photosFromCollection.object(at: indexPath.item)) else { return }
                    cell.index = index + 1
                    print(true)
                    DispatchQueue.main.async {
                        self.topCollectionView.reloadData()
                    }
                } else {
                    print("========")
                    guard let index = self.selectedAsset.firstIndex(of: self.photosFromCollection.object(at: indexPath.item)) else { return }
                    self.selectedAsset.remove(at: index)
                    DispatchQueue.main.async {
                        self.topCollectionView.reloadData()
                    }
                    guard let index = self.selectedAsset.firstIndex(of: self.photosFromCollection.object(at: indexPath.item)) else { return }
                    cell.index = index + 1
                }
            }
            return cell
        }
    }
}


extension PickerViewController: UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            
        } else {
            
            
        }
    }
}

extension PickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewCell.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            let width = UIScreen.main.bounds.width / 5
            let size = CGSize(width: width, height: width)
            return size
        } else {
            let width = (CollectionViewCell.viewWidth - CollectionViewCell.cellSpacing * (CollectionViewCell.cellColumns - 1)) / CollectionViewCell.cellColumns
            let size = CGSize(width: width, height: width)
            return size
        }
    }
}

extension PickerViewController {
    func setUI() {
        setCollectionView()
        setConstraint()
    }
    
    func setCollectionView() {
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.identifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        topCollectionView.collectionViewLayout = flowLayout
        
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
    }
    
    func setConstraint() {
        [topCollectionView, bottomCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let topWidth = UIScreen.main.bounds.width / 5
        let bottomWidth = UIScreen.main.bounds.width / 3
        
        NSLayoutConstraint.activate([
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: topWidth),
            
            bottomCollectionView.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 10),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
