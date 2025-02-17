//
//  SignInModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/14/25.
//

import Foundation

struct SignInModel: Codable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: SignInDataStructure?
}

struct SignInDataStructure: Codable {
    let refresh: String
    let access: String
    let user: SignIngDataUserStructure?
}

struct SignIngDataUserStructure: Codable {
    let name: String
    let email: String
}
