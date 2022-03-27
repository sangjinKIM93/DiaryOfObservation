//
//  Date.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2021/07/10.
//

import Foundation
import RxSwift
import RxCocoa

class DateFactory {
    
    static let shared = DateFactory()
    
    private init() {}
    
    func getCurrentDate() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateString = df.string(from: date)
        return dateString
    }
    
    func getDateEveryFiveSeconds() -> Observable<String> {
        Observable<Int>
          .timer(.seconds(1), period: .seconds(5), scheduler: MainScheduler.asyncInstance)
          .map { _ in self.getCurrentDate() }
          .distinctUntilChanged()
    }
}
