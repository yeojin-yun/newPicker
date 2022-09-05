//
//  PickerViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos
import CloudKit

class PickerViewController: UIViewController {

    var viewModel = PickerViewModel() {
        didSet {
            print("viewModel 값 들어옴")
        }
    }
    
    let topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let tempView = AlbumsCollectionView()
    var tempAnchor: NSLayoutConstraint?
    let button = UIButton(type: .custom)
    var navTitle = ""
    
    lazy var rightBarButton = UIBarButtonItem(title: "전송", style: .plain, target: self, action: #selector(rightBarButtonTapped(_:)))
    
    lazy var leftBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftBarButtonTapped(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        setPhotoAuthorization()
        view.backgroundColor = .yellow
        
    }

    func setPhotoAuthorization() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            //print("권한 받음")
        }
    }
    
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        // phasset 배열 -> identifier로 만들기
        let identifierArray = viewModel.selectedAsset.map { $0.localIdentifier }

    }
    @objc func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

extension PickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return viewModel.selectedAsset.count
        } else {
            return viewModel.photosFromCollection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            guard let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as? TopCollectionViewCell else { fatalError("No Cell") }
            let image = viewModel.selectedAsset[indexPath.item]
            topCell.setImage(asset: image)
            topCell.currentIndex = indexPath.item
            topCell.delegate = self
            return topCell
        } else {
            guard let bottomCell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as? BottomCollectionViewCell else { fatalError("No Cell") }
            bottomCell.photo.image = viewModel.photosFromCollection.object(at: indexPath.item).getAssetThumbnail(size: bottomCell.photo.frame.size)
            bottomCell.currentAsset = viewModel.photosFromCollection.object(at: indexPath.item)
            bottomCell.currentIndex = indexPath.item
            bottomCell.delegate = self
            bottomCell.setCheckMark(index: viewModel.images[bottomCell.currentIndex].selectedNumber)
            return bottomCell
        }
    }
}

extension PickerViewController: BottomCellDelegate {
    func didPressCheckButton(_ cell: BottomCollectionViewCell) {

        if viewModel.images[cell.currentIndex].selectedNumber != nil {
            viewModel.addImageInBottomCell(at: cell.currentIndex)
            cell.setCheckMark(index: viewModel.images[cell.currentIndex].selectedNumber)
            rightBarButton.title = "\(viewModel.selectedAsset.count) 예약"
        } else {
            if viewModel.deleteImageInBottomCell(at: cell.currentIndex) {
                cell.setCheckMark(index: viewModel.selectedAsset.count)
                rightBarButton.title = "\(viewModel.selectedAsset.count) 예약"
            } else {
                addAlert()
            }
        }
        bottomCollectionView.reloadData()
        topCollectionView.reloadData()
        
    }
    
    
    func addAlert() -> UIAlertController {
        let alert = UIAlertController(title: "", message: "사진은 5장까지 선택할 수 있습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
        return alert
    }
}

extension PickerViewController: TopCellDelegate {
    func didPressDeleteButton(_ cell: TopCollectionViewCell) {
        viewModel.changeTopAsset(cell)
        rightBarButton.title = "\(viewModel.selectedAsset.count) 예약"
        topCollectionView.reloadData()
        bottomCollectionView.reloadData()
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
            let width = UIScreen.main.bounds.width / 5.5
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
        setNavBar()
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
        [topCollectionView, bottomCollectionView, tempView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let topWidth = UIScreen.main.bounds.width / 5
        let bottomWidth = UIScreen.main.bounds.width / 3
        
        tempAnchor = tempView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        tempAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: topWidth),
            
            bottomCollectionView.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 10),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tempView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tempView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func setNavBar() {
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.isEnabled = false
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.navigationController?.navigationBar.tintColor = .black
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 200, height: 40)

        
        button.setTitle("앨범▾", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.frame = container.frame
        button.addTarget(self, action: #selector(navBarTapped(_:)), for: .touchUpInside)
        container.addSubview(button)
        navigationItem.titleView = container
    }
    
    @objc func navBarTapped(_ sender: UIButton) {
        print(#function)
        button.setTitle("앨범 ▴", for: .normal)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {
            self.tempView.isHidden = false
            self.tempView.isOpaque = false
            self.tempAnchor?.constant = UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


