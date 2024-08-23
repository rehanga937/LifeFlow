//
//  BloodAppointment.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-26.
//

import Foundation

struct BloodAppointment: Codable {
    
    var NIC: String = ""
    var locationName: String = ""
    var FW: String = ""
    var UWL: String = ""
    var RD: String = ""
    var SG: String = ""
    var appointmentDateTime: SmallDateTimeObject
    
}

struct SmallDateTimeObject: Codable {
    
    var date: String
    var timezone_type: Int
    var timezone: String
    
}
