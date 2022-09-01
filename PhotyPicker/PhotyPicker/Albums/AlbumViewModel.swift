//
//  AlbumViewModel.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/08/31.
//

import UIKit
import Photos


class AlbumViewModel {
    
    // 전체 앨범
    var albums: [PHAssetCollection] = [] {
        didSet {
            //print(albums)
        }
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
}
