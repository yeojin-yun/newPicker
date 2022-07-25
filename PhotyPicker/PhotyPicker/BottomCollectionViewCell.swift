//
//  BottomCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

protocol CellDelegate {
    func didPressCheckButton(for index: Int, like: Bool)
}

class BottomCollectionViewCell: UICollectionViewCell {
    static let identifier = "BottomCollectionViewCell"
    let photo = UIImageView()
    let checkMark = UIButton()
    let viewModel = ViewModel()
    
    var delegate: CellDelegate?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkMark.backgroundColor = .red
                print("aaaa")
            }
        }
    }
    
    var indexPath: Int = 0 {
        didSet {
            setCheckMark(index: indexPath)
        }
    }
    
    var checkMarkButtonTapped: (BottomCollectionViewCell) -> Void = { (sender) in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setDetail()
    }
    
    func setDetail() {
        checkMark.layer.borderColor = UIColor.darkGray.cgColor
        checkMark.layer.borderWidth = 2
        checkMark.backgroundColor = .lightGray
        checkMark.addTarget(self, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)
    }
    
    func resetCheckMark() {
        checkMark.setTitle("", for: .normal)
    }
    
    func setCheckMark(index: Int) {
        checkMark.setTitle("\(index)", for: .normal)
        checkMark.layer.borderColor = UIColor.darkGray.cgColor
        checkMark.layer.borderWidth = 2
        checkMark.backgroundColor = .lightGray
        checkMark.tintColor = .darkGray
    }
    
    func check(asset: PHAsset) {
        
    }
    
    func setConstraints() {
        [photo, checkMark].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkMark.topAnchor.constraint(equalTo: photo.topAnchor, constant: 10),
            checkMark.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: -10),
            checkMark.widthAnchor.constraint(equalToConstant: 25),
            checkMark.heightAnchor.constraint(equalTo: checkMark.widthAnchor)
        ])
    }
    
    @objc func checkMarkTapped(_ sender: UIButton) {
        checkMarkButtonTapped(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photo.image = nil
        self.checkMark.setTitle("", for: .normal)
        photo.contentMode = .scaleAspectFill
        self.photo.clipsToBounds = true
        checkMark.roundedCorners()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photo.contentMode = .scaleAspectFill
        self.photo.clipsToBounds = true
        checkMark.roundedCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
