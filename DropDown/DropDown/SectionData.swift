//
//  SectionData.swift
//  DropDown
//
//  Created by 순진이 on 2022/07/19.
//

import UIKit

struct SectionData {
    var open: Bool
    var data: [CellData]
}

struct CellData {
    let title: String
    let featureImage: UIImage
}
