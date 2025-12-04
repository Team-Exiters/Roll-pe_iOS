//
//  PolicyModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 12/4/25.
//

import Foundation

struct PolicyModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: String
}
