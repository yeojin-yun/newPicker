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
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setImageView()
        setConstraints()
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
            featureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            featureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            featureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            featureImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

}
