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
        setConstraint()
        setDetail()
        addTarget()
    }
    @objc func buttonTapped(_ sender: UIButton) {
        let nextVC = PickerViewController()
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}

extension ViewController {
    func addTarget() {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func setDetail() {
        button.setTitleColor(.white, for: .normal)
        button.setTitle("사진 선택", for: .normal)
        button.backgroundColor = .black
    }
    
    func setConstraint() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
