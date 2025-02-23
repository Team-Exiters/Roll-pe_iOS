//
//  HotRollpeModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/20/25.
//

import Foundation

struct HotRollpeModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: [RollpeItemModel]
}
