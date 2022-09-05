//
//  AlbumCollectionView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/09/05.
//

import Foundation
import UIKit


class AlbumsCollectionView: UIView {
    let tempView = UIView()
    
    let viewModel = AlbumViewModel()
    
    let albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        viewModel.fetchCollection()
        DispatchQueue.main.async {
            self.albumCollectionView.reloadData()
        }
        self.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension AlbumsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.setAlbum(collection: viewModel.albums[indexPath.item])
        return cell
    }
}

extension AlbumsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var topVC = UIApplication.shared.keyWindow?.rootViewController
//        while((topVC!.presentedViewController) != nil) {
//            topVC = topVC!.presentedViewController
//        }
//        let pickerVC = PickerViewController()
//        let navController = UINavigationController(rootViewController: pickerVC)
//
//        pickerVC.button.setTitle(viewModel.albums[indexPath.item].localizedTitle, for: .normal)
//        pickerVC.viewModel.selectedCollection = viewModel.albums[indexPath.item]
//        navController.modalPresentationStyle = .fullScreen
//        topVC?.present(navController, animated: true, completion: nil)
//
//        pickerVC.title = viewModel.albums[indexPath.item].localizedTitle
        
        // -----
        
        UIView.animate(withDuration: 2, delay: 0.3, options: .curveEaseOut) {
            self.isOpaque = true
            self.layoutIfNeeded()
        } completion: { _ in
            self.isHidden = true
        }

    }
}

extension AlbumsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 2
        let height = width * 1.3
        let size = CGSize(width: width, height: height)
        return size
    }
}


extension AlbumsCollectionView {
    func setUI() {
        setCollectionView()
        setConstraint()
    }
    
    func setCollectionView() {
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
    
    func setConstraint() {
        [albumCollectionView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        
        NSLayoutConstraint.activate([
            albumCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            albumCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            albumCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            albumCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
