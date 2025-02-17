//
//  SignUpModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/15/25.
//

import Foundation

struct SignUpModel: Codable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: String?
}
