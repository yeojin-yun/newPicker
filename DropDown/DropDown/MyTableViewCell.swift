//
//  MyTableViewCell.swift
//  DropDown
//
//  Created by 순진이 on 2022/07/19.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    let featureImageView = UIImageView()
    let titleLabel = UILabel()
    let infoText = UILabel()
    
    var cellData: CellData? {
        didSet {
            guard let cellData = cellData else {
                return
            }
//            self.textLabel?.text = cellData.title
//            self.imageView?.image = cellData.featureImage
            featureImageView.image = cellData.featureImage
            titleLabel.text = cellData.title
//            infoText.text = cellD
        }
    }
    
    func setImageView() {
        featureImageView.contentMode = .scaleAspectFit
        featureImageView.layer.masksToBounds = true
        featureImageView.layer.cornerRadius = 2
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
        
        infoText.font = UIFont.systemFont(ofSize: 12, weight: .light)
        infoText.textColor = .darkGray
        infoText.text = "뭉치는 아주 귀여운 강아지입니다. 뭉치를 한 번 만나면 빠져서 헤어나오기 힘들죠."
        infoText.numberOfLines = 0
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setImageView()
        setConstraints()
        contentView.backgroundColor = .white
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setConstraints() {
        [featureImageView, titleLabel, infoText].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            featureImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            featureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            featureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            featureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            featureImageView.heightAnchor.constraint(equalToConstant: 140),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: featureImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            
            infoText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            infoText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            infoText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30))
    }

}
