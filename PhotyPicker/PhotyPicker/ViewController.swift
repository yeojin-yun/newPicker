//
//  ViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit
import FirebaseRemoteConfig
import SwiftUI

class ViewController: UIViewController {
    
    let button = UIButton()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
    var content: (main: String, sub: String)?
    
    var remoteConfig: RemoteConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        setDetail()
        addTarget()
        setRemoteConfig()
        getNotice()
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let nextVC = AlbumsViewController()
        let nav = UINavigationController(rootViewController: nextVC)
//        self.navigationController?.pushViewController(nextVC, animated: true)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}

extension ViewController {
    func setRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 1
        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "Property List")
    }
    
    func getNotice() {
        guard let remoteConfig = remoteConfig else { return }
        remoteConfig.fetch { [weak self] status, error in
            if status == .success {
                print("-----")
                remoteConfig.activate(completion: nil)
            } else {
                print(error)
            }
            
            guard let self = self else { return }
            if !self.isNoticeHidded(remoteConfig) {
                
                
                
                let mainContent = (remoteConfig["mainText"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let subContent = (remoteConfig["subText"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                self.content = (main: mainContent, sub: subContent)
                self.mainLabel.text = self.content?.main
                self.subLabel.text = self.content?.sub
            }
        }
    }
    
    func isNoticeHidded(_ remoteConfig: RemoteConfig) -> Bool {
        print(remoteConfig["isHidden"].boolValue)
        return remoteConfig["isHidden"].boolValue
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
        
        [mainLabel].forEach {
            $0.numberOfLines = 0
            $0.textColor = .blue
        }
        
        [subLabel].forEach {
            $0.numberOfLines = 0
            $0.textColor = .lightGray
        }
    }
    
    func setConstraint() {
        [button, mainLabel, subLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            subLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
