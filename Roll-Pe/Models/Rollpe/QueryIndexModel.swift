//
//  QueryIndexModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/27/25.
//

import Foundation

struct QueryIndexModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: [QueryIndexDataModel]
}

struct QueryIndexDataModel: Decodable, Equatable {
    let id: Int
    let name: String
    let type: String
    let is_vip: Bool
}
