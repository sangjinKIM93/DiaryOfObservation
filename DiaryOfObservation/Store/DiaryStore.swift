//
//  DiaryStore.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2021/07/10.
//

import Foundation
import RxSwift
import RxCocoa

struct Diary {
    let content: String
    let date: String
}

class DiaryStore {
    
    static let shared = DiaryStore()
    private var mockData: [Diary] = []
    
    private init() {
        setDefaultMockData()
    }
    
    func setDefaultMockData() {
        for _ in 0..<5 {
            mockData.append(Diary(content: "안녕하세요 저는 김상진입니다. 앞으로 잘 부탁드립니다.", date: "2017.06.11"))
        }
    }
    
    func getMockData() -> [Diary] {
        return self.mockData
    }
    
    func appendMockData(diary: Diary) {
        mockData.append(diary)
    }
}
