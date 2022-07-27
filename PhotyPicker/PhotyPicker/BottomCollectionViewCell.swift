//
//  BottomCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

protocol CellDelegate {
    func didPressCheckButton(for index: Int, asset: PHAsset)
}

class BottomCollectionViewCell: UICollectionViewCell {
    static let identifier = "BottomCollectionViewCell"
    let photo = UIImageView()
    let checkMark = UIButton()
    let viewModel = ViewModel()
    
    var delegate: CellDelegate?
    
    var index: Int? {
        didSet {
            print("didSet index: \(index)")
        }
    }
    
    var asset: PHAsset = PHAsset() {
        didSet {
            print("didSet asset: \(asset)")
            
        }
    }
    
    @objc func checkMarkTapped(_ sender: UIButton) {
        guard let idx = index else { return }
        print("idx: \(idx)")
        if sender.isSelected {
//            isTouched = true
            checkMark.setTitle("\(idx)", for: .normal)
            delegate?.didPressCheckButton(for: idx, asset: asset)
        } else {
            checkMark.setTitle("", for: .normal)
//            isTouched = false
            delegate?.didPressCheckButton(for: idx, asset: asset)
        }
        sender.isSelected = !sender.isSelected
    }
    
    var isTouched: Bool? {
        didSet {
            if isTouched == true {
                checkMark.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                checkMark.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                checkMark.backgroundColor = .red
//                print("aaaa")
//            }
//        }
//    }
    

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
    
    var indexPath: Int = 0 {
        didSet {
            setCheckMark(index: indexPath)
        }
    }
    
    var checkMarkButtonTapped: (BottomCollectionViewCell) -> Void = { (sender) in }
    
    
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
