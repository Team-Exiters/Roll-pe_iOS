//
//  RollpeListItemModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/28/25.
//

import Foundation

struct RollpeListItemModel: Identifiable, Codable {
    let id: Int
    let receiverDate: Date
    var theme: String
    let isPublic: Bool
    let dDay: String
    let title: String
    let createdUser: String
    let createdAt: Date
}

struct RollpeSearchListItemModel: Identifiable, Codable {
    let id: Int
    let receiverDate: Date
    var theme: String
    let dDay: String
    let title: String
    let createdUser: String
    let createdAt: Date
}
