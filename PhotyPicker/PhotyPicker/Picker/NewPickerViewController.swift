//
//  NewPickerViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/08/24.
//

import UIKit
import Photos

class NewPickerViewController: UIViewController {
 
    
    let viewModel = PickerViewModel()
    
    
    lazy var bottomCollectionView = BottomCollectionView(phAsset: viewModel.photosFromCollection)
    lazy var topCollectionView = TopCollectionView(asset: viewModel.selectedAsset)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureUI()
        print("NewPickerVC", #function)
//        viewModel.delegate = self
        bottomCollectionView.delegate = topCollectionView
        
    }
}


//MARK: -UI
extension NewPickerViewController {
    final private func configureUI() {
        setAttributes()
        addTarget()
        setConstraints()
    }
    
    final private func setAttributes() {
        
    }
    
    final private func addTarget() {
        
    }
    
    final private func setConstraints() {

        view.addSubview(bottomCollectionView)
        view.addSubview(topCollectionView)
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5),

            bottomCollectionView.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 10),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

