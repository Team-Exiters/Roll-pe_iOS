//
//  ErrorModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/26/25.
//

import Foundation

struct ErrorModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
}
