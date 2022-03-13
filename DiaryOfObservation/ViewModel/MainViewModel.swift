//
//  MainViewModel.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2021/07/10.
//

import Foundation

class MainViewModel {
    
    var diaryList: [Diary]
    
    init() {
        diaryList = DiaryStore.shared.getMockData()
    }
    
    func saveDiary(diary: Diary) {
        DiaryStore.shared.appendMockData(diary: diary)
        refreshDiaryList()
    }
    
    private func refreshDiaryList() {
        diaryList = DiaryStore.shared.getMockData()
    }
}
