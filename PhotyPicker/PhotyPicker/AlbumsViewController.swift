//
//  AlbumsViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/20.
//

import UIKit
import Photos

class AlbumsViewController: UIViewController {
//    var albums: [PHAssetCollection] = [] {
//        didSet {
//            print(albums)
//        }
//    }
    let viewModel = ViewModel()
    
    let albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("AlbumsVC", #function)
        setUI()
        viewModel.fetchCollection()
        DispatchQueue.main.async {
            self.albumCollectionView.reloadData()
        }
    }
}


extension AlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.setAlbum(collection: viewModel.albums[indexPath.item])
        return cell
    }
}

extension AlbumsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = NewPickerViewController()
        nextVC.title = viewModel.albums[indexPath.item].localizedTitle
        nextVC.selectingPhasset = viewModel.albums[indexPath.item]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
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


extension AlbumsViewController {
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
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        
        NSLayoutConstraint.activate([
            albumCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            albumCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            albumCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
