//
//  MainReactor.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2022/03/12.
//

import Foundation
import ReactorKit

class MainReactor: Reactor {
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
            let diary = Diary(content: state.diary, date: state.date ?? "")
            newState.diaryList.append(diary)
        case let .refreshDate(dateString):
            newState.date = dateString
        case let .setDiary(diary):
            newState.diary = diary
        }
        
        return newState
    }
}
