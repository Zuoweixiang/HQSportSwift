//
//  File.swift
//  HQSportSwift
//
//  Created by jmf-mac on 2021/9/3.
//

import Foundation
import HandyJSON
struct XMUserModel:HandyJSON {
    var userName:String?
    var uid:UInt64 = 0
    var token:String?
    var ticket:String?
    var regTicket:String?
    var userSig:String?
    var mobile:String?
    var createTs:String?
    var nickName:String?
    var headImg:String?
    var userLevel:UInt64?
    var smAreaCode:String?
    var smAreaCodeId:String?
    var modifyPwd:Bool = false
}
