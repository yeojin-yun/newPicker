//
//  PHAssetCollection.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/19.
//

import UIKit
import Photos


extension PHAssetCollection {
    
    // MARK: - Public methods
    
//    func getCoverImgWithSize(_ size: CGSize) -> UIImage! {
//        let assets = PHAsset.fetchAssets(in: self, options: nil)
//        let asset = assets.firstObject
//        return asset?.getAssetThumbnail(size: size)
//    }
    
    func hasAssets() -> Bool {
        let assets = PHAsset.fetchAssets(in: self, options: nil)
        return assets.count > 0
    }
    
    func assetCount() -> String {
        let assets = PHAsset.fetchAssets(in: self, options: nil)
        return String(assets.count)
    }
    
    func getCoverImgWithSize(_ size: CGSize) -> UIImage! {
        let assets = PHAsset.fetchAssets(in: self, options: nil)
        let asset = assets.firstObject
        return asset?.getAssetThumbnail(size: size)
    }
}


