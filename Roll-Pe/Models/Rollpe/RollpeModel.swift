//
//  RollpeModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/3/25.
//

import Foundation

// 롤페 목록 모델
struct RollpeResponseListModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: [RollpeListDataModel]
}

// 롤페 페이지네이션 적용된 목록 모델
struct RollpeResponsePagenationListModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: RollpeResponsePagenationListDataModel
}

struct RollpeResponsePagenationListDataModel: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RollpeListDataModel]
}

// 롤페 목록 data 모델
struct RollpeListDataModel: Decodable {
    let id: Int
    let code: String
    let title: String
    let host: RollpeUserModel
    let receive: RollpeReceiveDataModel
    let viewStat: Bool
    let theme: String
    let size: String
    let ratio: String
    let createdAt: String
}

// 롤페 상세 모델
struct RollpeV1ResponseModel: Decodable {
    let status_code: Int
    let message: String
    let code: String
    let link: String?
    let data: RollpeV1DataModel
}

// 롤페 상세 data 모델
struct RollpeV1DataModel: Decodable {
    let id: Int
    let code: String
    var title: String
    let host: RollpeUserModel
    let receive: RollpeReceiveDataModel
    let viewStat: Bool
    let theme: String
    let size: String
    let ratio: String
    let maxHeartLength: Int
    let hearts: HeartResponseModel
    let invitingUser: [RollpeUserModel]
    let createdAt: String
}

// 수신자
struct RollpeReceiveDataModel: Decodable {
    let receiver: RollpeUserModel
    let receivingDate: String
    let receivingStat: Int
}

// 타 유저모델
struct RollpeUserModel: Decodable {
    let id: Int
    let identifyCode: String
    let name: String
}
