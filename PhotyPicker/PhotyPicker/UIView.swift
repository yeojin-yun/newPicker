//
//  UIView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/20.
//

import UIKit

extension UIView {
    
    // MARK: - Public methods
    
    func roundedCorners(with width: CGFloat) {
        self.layer.cornerRadius = width / 2
        self.clipsToBounds = true
    }
    
    func roudedCorners() {
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.clipsToBounds = true
    }
}
