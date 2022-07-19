//
//  BottomCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    static let identifier = "BottomCollectionViewCell"
    let photo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        photo.backgroundColor = .yellow
    }
    
    
    func setConstraints() {
        contentView.addSubview(photo)
        photo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
