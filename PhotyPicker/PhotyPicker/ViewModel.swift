//
//  ViewModel.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/21.
//

import UIKit
import Photos
import PhotosUI


struct ImageData {
    var image: PHAsset
    var selectedNumber: Int?
//    var selectedIndexPath: Int
}

class ViewModel {
    var selectedImages = [PHAsset]()
    var images: [ImageData] = [] {
        willSet {
            //print("count", images)
        }
    }
    var selectedIndex: [Int] = [] {
        didSet {
            print(selectedIndex.count)
        }
    }
    
    var identifierArray: [String] = [String]()
    var indexPathArray: [IndexPath] = [IndexPath]() {
        didSet {
            //print("새로운 값: \(indexPathArray)")
        }
    }
    
    // 전체 앨범
    var albums: [PHAssetCollection] = [] {
        didSet {
            //print(albums)
        }
    }
    
    // 앨범뷰컨에서 선택된 앨범
    var selectedCollection: PHAssetCollection = PHAssetCollection() {
        didSet {
            //print("현재 선택된 앨범입니다. \(selectedCollection.localizedTitle)")
            fetchImageFromCollection()
        }
    }
    
    //  앨범뷰컨에서 선택된 앨범에 들어있는 사진 (bottom collectionView를 구성함)
    var photosFromCollection: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>() {
        didSet {
            //print("값 들어옴\(photosFromCollection)", photosFromCollection.count)

        }
    }
    //  bottomCollectionView에서 선택된 사진이 들어가는 배열 (top CollectionView를 구성함)
    
    var selectedAsset: [PHAsset] = [] {
        didSet {
            //print("배열에 사진 담김")
        }
    }
    
    func checkHasAsset(indexPath: Int) -> Bool {
        return !selectedAsset.contains(photosFromCollection.object(at: indexPath)) ? true : false
    }
    
    func getIndexFromSelectedAssets(asset: PHAsset) -> Int {
        identifierArray.append(asset.localIdentifier)
        guard let indexOfPHAsset = identifierArray.firstIndex(of: asset.localIdentifier) else { return 0 }
        return indexOfPHAsset
    }
    
    // 사진첩에 있는 모든 앨범 불러오기
    func fetchCollection() {
        self.albums.removeAll()
        let fetchCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: .none)
        fetchCollection.enumerateObjects { collection, _, _ in
            if collection.hasAssets() {
                self.albums.append(collection)
            }
        }
    }
    
    //선택된 앨범의 사진 모두 불러오기
    func fetchImageFromCollection() {
        let fetchOption = PHFetchOptions()
        fetchOption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        self.photosFromCollection = PHAsset.fetchAssets(in: selectedCollection, options: fetchOption)
    }
}
