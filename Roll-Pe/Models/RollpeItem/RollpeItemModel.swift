//
//  RollpeItemModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/20/25.
//

import Foundation

struct RollpeItemModel: Decodable {
    let id: Int
    let title: String
    let viewStat: Bool
    let receivingStat: Int
    let receivingDate: String
    let hostName: String
    let code: String
    let theme: RollpeItemThemeModel
}

struct RollpeItemThemeModel: Decodable {
    let id: Int
    let name: String
    let type: String
    let is_vip: Bool
}
