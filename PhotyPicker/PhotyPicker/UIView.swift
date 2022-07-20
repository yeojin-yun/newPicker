//
//  UIView.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/20.
//

import UIKit

extension UIView {
    
    // MARK: - Public methods
    
    func roundedCorners() {
        self.layer.cornerRadius = self.bounds.size.height/2
        self.clipsToBounds = true
    }
}
