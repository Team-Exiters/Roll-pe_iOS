//
//  MyStatusModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/19/25.
//

import Foundation

struct MyStatusModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: MyStatusDataModel
}

struct MyStatusDataModel: Decodable {
    let host: Int
    let heart: Int
}
