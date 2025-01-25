//
//  RollpeItemModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import Foundation

struct RollpeItemModel: Codable {
    let theme: String?
    let dDay: String?
    let title: String?
    let subtitle: String?
    
    var id: UUID {
        UUID()
    }
}
