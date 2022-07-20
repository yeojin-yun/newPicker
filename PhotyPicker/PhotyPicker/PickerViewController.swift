//
//  PickerViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

class PickerViewController: UIViewController, UICollectionViewDelegate {
    private var albums: [PHAssetCollection] = []
    
    let topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        setPhotoAuthorization()
        fetchAlbum()
    }

    func setPhotoAuthorization() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            print("권한 받음")
        }
    }
}



extension PickerViewController {
    func fetchAlbum() {
        let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        result.enumerateObjects { collection, _, _ in
            if collection.hasAssets() {
                print(collection.localizedTitle)
                print(collection.hasAssets())
            }
        }
        
        let result2 = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        result2.enumerateObjects { collection, _, _ in
            if collection.hasAssets() {
                print("2: \(collection)")
            }
        }
    }
}


extension PickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return 5
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as? TopCollectionViewCell else { fatalError("No Cell") }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else { fatalError("No Cell") }
            return cell
        }
    }
}

extension PickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
            let width = UIScreen.main.bounds.width / 3
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
