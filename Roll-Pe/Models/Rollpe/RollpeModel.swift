//
//  RollpeModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/3/25.
//

import Foundation


struct RollpeModel {
    // api값 저장만하고 화면에 뿌려주는 용도라 id추가 필요없음
    // 변수들 작명,타입은 임의, 추후에 최종수정
    let host : String //host는 임의로 넣어둠
    let title : String
    var writers : [UserDataModel]
    var participants : [UserDataModel]
    var isPublic : Bool
    var date : Date
    var password : String?
}

struct RollpeResponseListModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: [RollpeDataModel]
}

struct RollpeDataModel: Decodable {
    let id: Int
    let code: String
    let title: String
    let host: RollpeHostDataModel
    let viewStat: Bool
    let receivingDate: String
    let receivingStat: Int
    let theme: String
    let size: String
    let ratio: String
    let createdAt: String
}

struct RollpeHostDataModel: Decodable {
    let id: Int
    let code: String
    let identifyCode: String
    let name: String
}
