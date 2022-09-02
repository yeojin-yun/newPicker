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
            photosFromCollection.enumerateObjects { asset, index, _ in
                let sample = ImageData(image: asset)
                self.images.append(sample)
            }
        }
    }
    
    //  bottomCollectionView에서 선택된 사진이 들어가는 배열 (top CollectionView를 구성함)
    var selectedAsset: [PHAsset] = [] {
        didSet {
            print("🐽viewModel의 selectedAsset", selectedAsset.count)
            if selectedAsset.count > 5 {
                print("다섯개 초과")
            }
        }
    }

    //선택된 앨범의 사진 모두 불러오기
    func fetchImageFromCollection() {
        let fetchOption = PHFetchOptions()
        fetchOption.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        self.photosFromCollection = PHAsset.fetchAssets(in: selectedCollection, options: fetchOption)
    }
    
    //셀을 넣으면 몇 번째 인덱스인지 나오는 함수
    var checkAssetCountUnder5: Bool {
        return selectedAsset.count < 5 ? true : false
    }
    
    //문제점 1) 6개가 되어야 얼럿이 뜨는 현상
    //문제점 2) 6개가 된 후에는 아래에서 선택해제해도 얼럿만 뜨고 해제가 안되는 상황
    
    func changeBottomAsset(_ cell: BottomCollectionViewCell) {
        if images[cell.currentIndex].selectedNumber != nil {
            // 이미 배열 속에 들어있다면? 제거돼야지!!
            guard let selectedNumber = images[cell.currentIndex].selectedNumber else { return }
            selectedAsset.remove(at: selectedNumber - 1)
            images[cell.currentIndex].selectedNumber = nil
            
            images = images.map {
                guard var number = $0.selectedNumber else { return ImageData(image: $0.image, selectedNumber: nil) }
                
                if number > selectedNumber {
                    number -= 1
                }
                return ImageData(image: $0.image, selectedNumber: number)
            }
            cell.setCheckMark(index: images[cell.currentIndex].selectedNumber)
        } else {
            // 선택된 적이 없으면
            if selectedAsset.count < 5 {
                selectedAsset.append(images[cell.currentIndex].image)
                images[cell.currentIndex].selectedNumber = selectedAsset.count
                cell.setCheckMark(index: selectedAsset.count)
            } else {
                print("count가 6개가 되어버림. 그러면 Alert를 줘야함. 어떤 트리거로 주는 가?Notification")
//                addAlert()
            }
        }
    }
    
    func addImageInBottomCell(at currentIndex: Int) {
        guard let selectedNumber = images[currentIndex].selectedNumber else { return }
        selectedAsset.remove(at: selectedNumber - 1)
        images[currentIndex].selectedNumber = nil
        
        images = images.map {
            guard var number = $0.selectedNumber else { return ImageData(image: $0.image, selectedNumber: nil) }
            
            if number > selectedNumber {
                number -= 1
            }
            return ImageData(image: $0.image, selectedNumber: number)
        }
    }
    
    func deleteImageInBottomCell(at currentIndex: Int) -> Bool {
        // 선택된 적이 없으면
        if selectedAsset.count < 5 {
            selectedAsset.append(images[currentIndex].image)
            images[currentIndex].selectedNumber = selectedAsset.count
            return true
        } else {
            return false
        }
    }
    

    
    func changeTopAsset(_ cell: TopCollectionViewCell) {
        // TopCell에서 삭제를 누르면 발생할 일
        // 1. Top - dataSource에서 해당 이미지 remove
        // Bottom - dataSource에도 적용되도록
        // 현재 삭제된 TopCell의 이미지가 BottomCell에서 몇 번째 인덱스인지 알아냄
        guard let deletedImage = images.filter { $0.image == selectedAsset[cell.currentIndex] }.first else { return }
        guard let deletedImageIndex = images.firstIndex(of: deletedImage) else { return }
        print(deletedImageIndex)
        
        guard let deletedNumber = images[deletedImageIndex].selectedNumber else { return }
        images[deletedImageIndex].selectedNumber = nil
        selectedAsset.remove(at: cell.currentIndex)
        
        images = images.map {
            guard var number = $0.selectedNumber else { return ImageData(image: $0.image, selectedNumber: nil) }

            if number > deletedNumber {
                number -= 1

            }
            return ImageData(image: $0.image, selectedNumber: number)
        }
    }
    

}
