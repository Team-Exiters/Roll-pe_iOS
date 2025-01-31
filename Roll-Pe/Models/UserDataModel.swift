//
//  UserModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/27/25.
//

import Foundation

class UserDataModel {
    var password : String?
    var nickname : String?
    var login : [String]?
    var userUID : String?
    var rollpeCount : Int?
    var heartCount : Int?
    
    init(password: String? = nil,nickname: String? = nil, login: [String]? = nil, userUID: String? = nil,rollpeCount: Int? = nil,heartCount : Int? = nil) {
        self.password = password
        self.nickname = nickname
        self.login = login
        self.userUID = userUID
        self.rollpeCount = rollpeCount
        self.heartCount = heartCount
    }
}
