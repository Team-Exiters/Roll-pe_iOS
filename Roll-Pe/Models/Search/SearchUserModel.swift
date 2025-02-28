//
//  SearchUserModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/25/25.
//

import Foundation

struct SearchUserModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: SearchUserDataModel
}

struct SearchUserDataModel: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [SearchUserResultModel]
}

struct SearchUserResultModel: Decodable {
    let identifyCode: String
    let name: String
    // let id: Int
    var isSelected: Bool? = false
}
