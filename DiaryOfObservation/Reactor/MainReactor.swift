//
//  MainReactor.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2022/03/12.
//

import Foundation
import ReactorKit
import RxDataSources

class MainReactor: Reactor {
    var scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .background)
    
    let dateMutation = DateFactory.shared.getDateEveryFiveSeconds()
        .flatMap { dateString -> Observable<Mutation> in
            return .just(.refreshDate(dateString))
        }
    
    enum Action {
        case saveMemo
        case setDiary(String?)
    }
    
    enum Mutation {
        case addMemoData
        case refreshDate(String)
        case setDiary(String)
    }
    
    struct State {
        var diaryList: [Diary] = []
        var date: String?
        var diary: String = ""
        var diarySectionList: [SectionModel<String, Diary>] = []
    }
    
    let initialState = State()
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(mutation, dateMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .saveMemo:
            return Observable.just(Mutation.addMemoData)
        case let .setDiary(diary):
            return Observable.just(Mutation.setDiary(diary ?? ""))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .addMemoData:
            heavyCalculation()
            newState.diarySectionList = getDataSourceMockData()
            let diary = Diary(content: state.diary, date: state.date ?? "")
            newState.diaryList.append(diary)
        case let .refreshDate(dateString):
            newState.date = dateString
        case let .setDiary(diary):
            newState.diary = diary
        }
        
        return newState
    }
    
    private func heavyCalculation() {
        for _ in 1...10 {
            print(Thread.isMainThread)
        }
    }
    
    private func getDataSourceMockData() -> [SectionModel<String, Diary>] {
        let mockData = [ SectionModel(model: "1월", items: [Diary(content: "fnfnfn", date: "2022.01.01"),
                                                             Diary(content: "fnfnfn", date: "2022.01.11"),
                                                             Diary(content: "fnfnfn", date: "2022.01.22")]),
                         SectionModel(model: "2월", items: [Diary(content: "fnfnfn", date: "2022.02.01"),
                                                             Diary(content: "fnfnfn", date: "2022.02.11"),
                                                             Diary(content: "fnfnfn", date: "2022.02.22")])
                         
        ]
        return mockData
    }
}
