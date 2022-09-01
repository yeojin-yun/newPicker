//
//  ViewModel.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/21.
//

import UIKit
import Photos
import PhotosUI




class PickerViewModel {
    init() {
        print("viewModel init")
    }


    
    var selectedImages = [PHAsset]()
    
    var images: [ImageData] = [] {
        willSet {
            //print("count", images)
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
            print("viewModel의 selectedAsset", selectedAsset.count)
        }
    }

    //선택된 앨범의 사진 모두 불러오기
    func fetchImageFromCollection() {
        let fetchOption = PHFetchOptions()
        fetchOption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        self.photosFromCollection = PHAsset.fetchAssets(in: selectedCollection, options: fetchOption)
    }
}
