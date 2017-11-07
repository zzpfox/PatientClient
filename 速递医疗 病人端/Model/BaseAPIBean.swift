//
//  BaseAPIBean.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/10/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import ObjectMapper

class BaseAPIBean:Mappable {
    var msg: String?
    var code: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        code <- map["code"]
    }
}

class BaseListBean<T>:BaseAPIBean {
    var dataList:[T]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dataList <- map["data"]
    }
}

class DoctorListBean:BaseAPIBean {
    var doctorDataList:[DoctorBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        doctorDataList <- map["data"]
    }
}

class DoctorBean:Mappable {
    var dept:String?
    var hospital:String?
    var allday: Bool = false
    var docId: Int = 0
    var distance:Int = 0
    var primary:String?
    var pix:String?
    var name:String?
    var hospitalLevel:String?
    var docLevel:String?
    var docexpert:String?
    var preordertypename:String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        dept <- map["docseconddept"]
        hospital <- map["dochosp"]
        allday <- map["docallday"]
        docId <- map["docloginid"]
        distance <- map["distance"]
        primary <- map["docprimarydept"]
        pix <- map["docloginpix"]
        name <- map["docname"]
        hospitalLevel <- map["hosplevel"]
        docLevel <- map["doctitle"]
        docexpert <- map["docexpert"]
        preordertypename <- map["preordertypename"]
    }
}

class OrderListBean:BaseAPIBean {
    var OrderDataList:[OrderBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        OrderDataList <- map["data"]
    }
}

class OrderBean: Mappable {
    var userorderappointment: String? // 订单预约医生时间
    var familyname: String? // 用户姓名
    var userorderid: Int = 0 //订单Id
    var usersickdesc: String? // 病情描述
    var userorderstateid: Int = 0 // 订单状态
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userorderappointment <- map["userorderappointment"]
        familyname <- map["familyname"]
        userorderid <- map["userorderid"]
        usersickdesc <- map["usersickdesc"]
        userorderstateid <- map["userorderstateid"]
    }
}



class familyListBean:BaseAPIBean {
    var familyDataList: [familyBean]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        familyDataList <- map["data"]
    }
    
}

class familyBean:Mappable {
    var familyid: Int = 0
    var familyname: String?
    var familymale: String?
    var familyage: Int = 0
    var userloginid:Int = 0
    var familytype:Bool = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        familyid <- map["familyid"]
        familyname <- map["familyname"]
        familymale <- map["familymale"]
        familyage <- map["familyage"]
        userloginid <- map["userloginid"]
        familytype <- map["familytype"]
    }
    
}

class sickListBean:BaseAPIBean {
    
    var sickDataList: [SickBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        sickDataList <- map["data"]
    }
    
}

//"familyid": 43,
//"usersickstateid": 4,
//"usersickseconddept": "呼吸内科",
//"familymale": "男",
//"userorderid": 22,
//"familyname": "王二",
//"usersickpic": "http://oytv6cmyw.bkt.clouddn.com/20171103055123751753.jpeg",
//"usersicktime": "Oct 16, 2017 5:12:03 PM",
//"usersickid": 81,
//"usersickprimarydept": "内科",
//"usersickdesc": "ghnhtffgtrghtdfb",
//"familyage": 23

class SickBean:Mappable {
    var familyid: Int = 0
    var usersickstateid:Int = 0
    var usersickseconddept:String?
    var familymale:String?
    var userorderid: Int = 0
    var familyname: String?
    var usersickpic:String?
    var usersicktime:String?
    var usersickid: Int = 0
    var usersickprimarydept:String?
    var usersickdesc: String?
    var familyage: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        familyid <- map["familyid"]
        usersickstateid <- map["usersickstateid"]
        usersickseconddept <- map["usersickseconddept"]
        familymale <- map["familymale"]
        userorderid <- map["userorderid"]
        familyname <- map["familyname"]
        usersickpic <- map["usersickpic"]
        usersicktime <- map["usersicktime"]
        usersickid <- map["usersickid"]
        usersickprimarydept <- map["usersickprimarydept"]
        usersickdesc <- map["usersickdesc"]
        familyage <- map["familyage"]
    }
    
}


