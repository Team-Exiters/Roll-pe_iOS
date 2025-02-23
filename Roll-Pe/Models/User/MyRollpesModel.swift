//
//  MyRollpesModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/19/25.
//

import Foundation

struct MyRollpesModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: MyRollpesDataModel
}

struct MyRollpesDataModel: Decodable {
    let count: Int
    let next: String?
    let previous: String?
}
