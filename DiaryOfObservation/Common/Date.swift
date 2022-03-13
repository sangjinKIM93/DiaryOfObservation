//
//  Date.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2021/07/10.
//

import Foundation

class DateFactory {
    
    static func getCurrentDate() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: date)
        return dateString
    }
}
