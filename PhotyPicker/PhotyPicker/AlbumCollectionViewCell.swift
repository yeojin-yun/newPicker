//
//  AlbumCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/19.
//

import UIKit
import SwiftUI
import Photos

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumCollectionViewCell"
    
    let mainImageView = UIImageView()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setDetail()
    }
    
    func setAlbum(collection: PHAssetCollection) {
        mainImageView.image = collection.getCoverImgWithSize(mainImageView.frame.size)
        mainLabel.text = collection.localizedTitle
        subLabel.text = collection.assetCount()
        
    }
    
    func setDetail() {
        mainLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    func setConstraints() {
        [mainImageView, mainLabel, subLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            
            mainLabel.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
//            mainLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 5),
            mainLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            mainLabel.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -5),
            
//            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 5),
            subLabel.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            subLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainImageView.clipsToBounds = true
        mainImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
