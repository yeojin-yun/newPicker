//
//  BottomCollectionViewCell.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import Photos

protocol BottomCellDelegate: AnyObject {
    func didPressCheckButton(_ cell: BottomCollectionViewCell)
}

class BottomCollectionViewCell: UICollectionViewCell {
    static let identifier = "BottomCollectionViewCell"
    let photo = UIImageView()
    let checkMark = UIButton()
    let viewModel = ViewModel()
    
    weak var delegate: BottomCellDelegate?

    var currentAsset: PHAsset = PHAsset() {
        didSet {
            //print("didSet asset: \(currentAsset)")
        }
    }
    
    var currentIndex: Int = 0 {
        didSet {
            //print("currentIndex: \(currentIndex)")
        }
    }

//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                setCheckMark(index: <#T##Int#>)
//            } else {
//
//            }
//        }
//    }
    
    @objc func checkMarkTapped(_ sender: UIButton) {
//        print("체크 박스가 눌렸슴돠", sender.isSelected)
//        print("---------",currentAsset, "---------", currentIndex)
        delegate?.didPressCheckButton(self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDetail()
        setConstraints()
    }
    
    func setDetail() {
        checkMark.roundedCorners(with: 25)
        checkMark.layer.borderColor = UIColor.darkGray.cgColor
        checkMark.layer.borderWidth = 2
        checkMark.backgroundColor = .lightGray
        checkMark.addTarget(self, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)
    }
    
    func resetCheckMark() {
        checkMark.setTitle("", for: .normal)
    }
    
    func setCheckMark(index: Int?) {
        if let index = index {
            checkMark.setTitle("\(index)", for: .normal)
        } else {
            checkMark.setTitle("", for: .normal)
        }
        checkMark.layer.borderColor = UIColor.darkGray.cgColor
        checkMark.layer.borderWidth = 2
        checkMark.backgroundColor = .lightGray
        checkMark.tintColor = .darkGray
//        checkMark.roundedCorners()
        
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
    
    var checkMarkButtonTapped: (BottomCollectionViewCell) -> Void = { (sender) in }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        checkMark.roundedCorners(with: 25)
        checkMark.setTitle(nil, for: .normal)
        self.photo.image = nil
        photo.contentMode = .scaleAspectFill
        self.photo.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkMark.roundedCorners(with: 25)
        photo.contentMode = .scaleAspectFill
        self.photo.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
