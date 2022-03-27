//
//  MainReactor.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2022/03/12.
//

import Foundation
import ReactorKit

class MainReactor: Reactor {
    enum Action {
        case saveMemo(Diary)
    }
    
    enum Mutation {
        case addMemoData(Diary)
        case refreshDate(String)
    }
    
    struct State {
        var diaryList: [Diary] = []
        var date: String?
    }
    
    let initialState = State()
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        // Util 함수 느낌인 DateFactory도 주입해서 써야할까?
        let dateMutation = DateFactory.shared.getDateEveryFiveSeconds()
            .flatMap { dateString -> Observable<Mutation> in
                return .just(.refreshDate(dateString))
            }
        return Observable.merge(mutation, dateMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .saveMemo(diary):
            return Observable.just(Mutation.addMemoData(diary))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .addMemoData(diary):
            newState.diaryList.append(diary)
        case let .refreshDate(dateString):
            newState.date = dateString
        }
        
        return newState
    }
}
