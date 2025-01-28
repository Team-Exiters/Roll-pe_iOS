//
//  UserModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/27/25.
//

import Foundation

class UserDataModel {
    var nickname : String?
    var login : [String]?
    
    init(nickname: String? = nil, login: [String]? = nil) {
        self.nickname = nickname
        self.login = login
    }
}
