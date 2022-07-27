//
//  CollectionViewController.swift
//  PhotyPicker
//
//  Created by 순진이 on 2022/07/27.
//

import UIKit

class CollectionViewController: UIViewController {
    
    let urlArray: [String] = []
    private let memoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return urlArray.count
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = memoryCollectionView.dequeueReusableCell(withReuseIdentifier: MemoryCollectionViewCell.identifier, for: indexPath) as? MemoryCollectionViewCell else { fatalError() }

        let urlArray = orderViewModel.userMemory[indexPath.section].photos
        cell.imageUrl = urlArray[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = memoryCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MemoryHeaderCollectionReusableView.identifier, for: indexPath) as? MemoryHeaderCollectionReusableView else { fatalError() }
        let productName = orderViewModel.userMemory[indexPath.section].productName
        let invoice = orderViewModel.userMemory[indexPath.section].invoiceNumber
        
        if orderViewModel.checkGift(productName: productName) {
            header.titleLabel.text = "가입선물"
        } else {
            if orderViewModel.checkTrackingStart(invoice: invoice) {
                header.titleLabel.text = "\(orderViewModel.userMemory[indexPath.section].month)월의 사진"
            } else {
                header.titleLabel.text = "\(orderViewModel.userMemory[indexPath.section].month)월 받아볼 사진"
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: MemoryCell.headerHeight)
    }
}

extension MemoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}


// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellWidth = (UIScreen.main.bounds.width - MemoryCell.spacingWidth * (MemoryCell.cellColumns - 1)) / MemoryCell.cellColumns
        return CGSize(width: collectionCellWidth, height: collectionCellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return MemoryCell.spacingWidth
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return MemoryCell.spacingWidth
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
    }
}

// MARK: - Set UI
extension CollectionViewController {
    final private func setUI() {
        setCollectionView()
        setCollectViewLayout()

    }

    final private func setCollectionView() {
        memoryCollectionView.delegate = self
        memoryCollectionView.dataSource = self
        memoryCollectionView.register(MemoryCollectionViewCell.self, forCellWithReuseIdentifier: MemoryCollectionViewCell.identifier)
        memoryCollectionView.register(MemoryHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MemoryHeaderCollectionReusableView.identifier)
    }

    final private func setCollectViewLayout() {
        view.addSubview(memoryCollectionView)
        
        memoryCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}
