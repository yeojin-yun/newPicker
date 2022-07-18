//
//  ViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit

class ViewController: UIViewController {
    
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setConstraint() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

}

