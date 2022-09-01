//
//  TopCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

protocol TopCellDelegate: AnyObject {
    func didPressDeleteButton(_ cell: TopCollectionViewCell)
}

class TopCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopCollectionViewCell"
    let photo = UIImageView()
    let deleteButton = UIButton()
    
    var deleteButtonTapped: (TopCollectionViewCell) -> Void = { (sender) in }
    
    weak var delegate: TopCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setDetail()
    }
    
    @objc func deleteBtnTapped(_ sender: UIButton) {
//        deleteButtonTapped(self)
        print("TopCell X버튼 눌림")
        delegate?.didPressDeleteButton(self)
    }
    
    
    var currentIndex: Int = 0 {
        didSet {
            print("currentIndex: \(currentIndex)")
        }
    }
    
    func setImage(asset: PHAsset) {
        photo.image = asset.getImageFromPHAsset()
    }
    
    func setDetail() {
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.setTitleColor(.darkGray, for: .normal)
        deleteButton.tintColor = .lightGray.withAlphaComponent(1.0)
        deleteButton.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)
    }
    
    func setConstraints() {
        [photo, deleteButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            deleteButton.topAnchor.constraint(equalTo: photo.topAnchor, constant: -8),
            deleteButton.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photo.image = nil
//        self.deleteButton.setImage(nil, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.photo.contentMode = .scaleAspectFill
        self.photo.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

