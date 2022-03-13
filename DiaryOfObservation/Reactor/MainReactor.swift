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
    }
    
    struct State {
        var diaryList: [Diary] = []
    }
    
    let initialState = State()
    
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
            // 배운거1 - 파라미터를 넘기기 위해서는 enum의 파라미터를 활용한다.
            newState.diaryList.append(diary)
        }
        
        return newState
    }
}
