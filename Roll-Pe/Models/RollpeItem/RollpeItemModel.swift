//
//  RollpeItemModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import Foundation


// 절대 손대지말것 , 필요시 의논후 부탁
class RollpeItemModel {
    var theme: String?
    var dDay: String?
    var title: String?
    var subtitle: String?
    
    init(theme: String?, dDay: String?, title: String?, subtitle: String?) {
        self.theme = theme
        self.dDay = dDay
        self.title = title
        self.subtitle = subtitle
    }
}
