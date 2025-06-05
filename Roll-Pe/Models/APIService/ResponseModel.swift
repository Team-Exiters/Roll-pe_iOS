//
//  ResponseModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/15/25.
//

import Foundation

struct ResponseNoDataModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
}

struct ResponseStringModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: String
}
