//
//  AlbumCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/19.
//

import UIKit
import SwiftUI

class AlbumCollectionViewCell: UICollectionViewCell {
    
    let mainImageView = UIImageView()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            
            mainLabel.leadingAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
