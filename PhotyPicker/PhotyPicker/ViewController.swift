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
    let button2 = UIButton()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
    var content: (main: String, sub: String)?
    
    var remoteConfig: RemoteConfig?
    
    var urlArray = [
        "https://photypeta1.s3.ap-northeast-2.amazonaws.com/original/0000008/1/윤여진/1658732562644/4497328bytes.jpg",
        "https://photypeta1.s3.ap-northeast-2.amazonaws.com/original/0000008/3/윤여진/1658732563283/4632754bytes.jpg",
        "https://photypeta1.s3.ap-northeast-2.amazonaws.com/original/0000008/2/윤여진/1658732563012/6746963bytes.jpg",
        "https://photypeta1.s3.ap-northeast-2.amazonaws.com/original/0000008/4/윤여진/1658732563579/6086719bytes.jpg",
        "https://photypeta1.s3.ap-northeast-2.amazonaws.com/original/0000008/5/윤여진/1658732563939/821163bytes.jpg"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        setDetail()
        addTarget()
        setRemoteConfig()
        getNotice()
        
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender {
        case button:
            let nextVC = AlbumsViewController()
            let nav = UINavigationController(rootViewController: nextVC)
    //        self.navigationController?.pushViewController(nextVC, animated: true)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case button2:
            let nextVC = CollectionViewController()
            let nav = UINavigationController(rootViewController: nextVC)
    //        self.navigationController?.pushViewController(nextVC, animated: true)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        default:
            break
        }
        
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
        return remoteConfig["isHidden"].boolValue
    }
}

extension ViewController {
    func addTarget() {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func setDetail() {
        button.setTitleColor(.white, for: .normal)
        button.setTitle("사진 선택", for: .normal)
        button.backgroundColor = .black
        
        button2.setTitleColor(.white, for: .normal)
        button2.setTitle("컬렉션뷰", for: .normal)
        button2.backgroundColor = .black
        
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
        [button, mainLabel, subLabel, button2].forEach {
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
            button.widthAnchor.constraint(equalToConstant: 200),
            
//            button2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 30),
            button2.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}
