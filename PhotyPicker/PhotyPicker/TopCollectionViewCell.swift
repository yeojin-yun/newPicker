//
//  TopCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

class TopCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopCollectionViewCell"
    let photo = UIImageView()
    let minusButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setDetail()
    }
    
    func setImage(asset: PHAsset) {
        photo.image = asset.getImageFromPHAsset()
    }
    
    func setDetail() {
        minusButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        minusButton.setTitleColor(.darkGray, for: .normal)
        minusButton.tintColor = .lightGray.withAlphaComponent(1.0)
    }
    
    func setConstraints() {
        [photo, minusButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            minusButton.topAnchor.constraint(equalTo: photo.topAnchor, constant: -8),
            minusButton.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photo.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photo.contentMode = .scaleAspectFill
        self.photo.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

