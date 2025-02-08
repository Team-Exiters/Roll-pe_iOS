//
//  RollpeModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/3/25.
//

import Foundation


struct RollpeModel {
    let host : String
    let title : String
    var writers : [UserDataModel]
    var participants : [UserDataModel]
    var isPublic : Bool
    var date : Date
    var password : String?
}



