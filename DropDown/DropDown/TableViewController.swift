//
//  TableViewController.swift
//  DropDown
//
//  Created by 순진이 on 2022/07/18.
//

import UIKit

class TableViewController: UIViewController {
    
    let tableView = UITableView()

    
    var sections: [SectionData] = [
        SectionData(open: true, data: [CellData(title: "Instagram", featureImage: UIImage(named: "2")!)]),
        SectionData(open: true, data: [CellData(title: "Section", featureImage: UIImage(named: "1")!)]),
        SectionData(open: true, data: [CellData(title: "Twitter", featureImage: UIImage(named: "3")!), CellData(title: "Youtube", featureImage: UIImage(named: "1")!)])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "spots"
        setUI()
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.identifier)
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        let section = sections[indexPath.section]
        print(indexPath.section, indexPath.row)
        let sectionData = section.data[indexPath.row]
        cell.cellData = sectionData
//        cell.textLabel?.text = sectionData.title
//        cell.imageView?.image = sectionData.featureImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle("close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}

extension TableViewController {
    func setUI() {
        setConstraints()
    }
    
    func setConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
