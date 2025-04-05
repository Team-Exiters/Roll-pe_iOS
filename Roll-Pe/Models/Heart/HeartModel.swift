//
//  HeartModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/20/25.
//

import Foundation

struct HeartResponseModel: Decodable {
    let count: Int
    let data: [HeartModel]
}

struct HeartModel: Decodable {
    let id: Int
    let code: String
    let index: Int
    let author: ReceiverDataModel;
    let content: String
    let createdAt: String
    let color: String
    let version: String
}
