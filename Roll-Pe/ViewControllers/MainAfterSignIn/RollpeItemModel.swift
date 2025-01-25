//
//  RollpeItemModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import Foundation

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
