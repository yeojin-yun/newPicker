//
//  PickerViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

class PickerViewController: UIViewController {
    var selectedCollection: PHAssetCollection = PHAssetCollection() {
        didSet {
            viewModel.selectedCollection = selectedCollection
        }
    }
//    var photosFromCollection: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
//    var selectedAsset: [PHAsset] = []
    
    let viewModel = ViewModel()
    
    let topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var checkSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        setPhotoAuthorization()
        DispatchQueue.main.async {
            self.bottomCollectionView.reloadData()
        }
    }

    func setPhotoAuthorization() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            //print("권한 받음")
        }
    }
}

extension PickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return viewModel.selectedAsset.count
        } else {
            //print(viewModel.photosFromCollection.count)
            return viewModel.photosFromCollection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            guard let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as? TopCollectionViewCell else { fatalError("No Cell") }
            let image = viewModel.selectedAsset[indexPath.item]
            topCell.setImage(asset: image)
            topCell.deleteButtonTapped = { [weak self] _ in
                guard let `self` = self else { return }
                guard let index = self.viewModel.selectedAsset.firstIndex(of: image) else { return }
                self.viewModel.selectedAsset.remove(at: index)

                DispatchQueue.main.async {
                    self.topCollectionView.reloadData()
                }
            }
            return topCell
        } else {
            guard let bottomCell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else { fatalError("No Cell") }
            bottomCell.photo.image = viewModel.photosFromCollection.object(at: indexPath.item).getAssetThumbnail(size: bottomCell.photo.frame.size)
            
            bottomCell.checkMarkButtonTapped = { [weak self] _ in
                guard let self = self else { return }
                //cell.indexPath = indexPath.item + 1

                if self.viewModel.checkHasAsset(indexPath: indexPath.item) {
                    print("-------\(indexPath.item)")
                    self.viewModel.selectedAsset.append(self.viewModel.photosFromCollection.object(at: indexPath.item))
                    self.viewModel.indexPathArray.append(indexPath)
//                    print(self.viewModel.selectedAsset.firstIndex(of: self.viewModel.photosFromCollection.object(at: indexPath.item)))
                    guard let index = self.viewModel.selectedAsset.firstIndex(of: self.viewModel.photosFromCollection.object(at: indexPath.item)) else { return }

                    DispatchQueue.main.async {
                        self.topCollectionView.reloadData()
                    }
                    //self.bottomCollectionView.reloadSections(IndexSet.init(integer: 0))
                } else {
                    print("========\(indexPath.item)")
                    
                    guard let index = self.viewModel.selectedAsset.firstIndex(of: self.viewModel.photosFromCollection.object(at: indexPath.item)) else { return }
                    print("⭐️\(index)")
                    bottomCell.resetCheckMark()
                    self.viewModel.selectedAsset.remove(at: index)
                    self.viewModel.indexPathArray.remove(at: index)
                    DispatchQueue.main.async {
                        self.topCollectionView.reloadData()
                    }
                }
                // 항상 불리기 때문에 여기서 선택되지 않은 셀들에 대해서 숫자 표시할 것
                // bottomCell.setCheckMark(index: <#T##Int#>)
                for myIndex in self.viewModel.indexPathArray {
//                    print("✏️\(index)") // 선택된 indexPath 배열의 개별 요소
                    print("✏️✏️",self.viewModel.indexPathArray.firstIndex(of: myIndex))
                    guard let result = self.viewModel.indexPathArray.firstIndex(of: myIndex) else { return }// 현재 눌린 셀이 인덱스 모음 배열에서 몇 번째? 이걸 셀의 체크 박스 버튼에 나타내야 함
                    bottomCell.indexPath = result + 1
                    
                    // 배열에서 해당 요소(=indexPath)가 몇 번째 요소인지
                }
                DispatchQueue.main.async {
                    self.bottomCollectionView.reloadData()
                }
            }
            return bottomCell
        }
    }
}


extension PickerViewController: UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            
        } else {
            print("➡️",indexPath, indexPath.item)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            
        } else {
            print("➡️➡️",indexPath, indexPath.item)
            
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
