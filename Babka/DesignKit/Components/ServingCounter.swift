//
//  ServingCounter.swift
//  Babka
//
//  Created by Arthur ARNAUD on 15/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ServingCounterState: Equatable {
    var serving: Int = 1
    var upperLimit: Int = 20
    var lowerLimit: Int = 1
}

enum ServingCounterAction: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
}

struct ServingCounterEnvironment {}

let servingCounterReducer = Reducer<ServingCounterState, ServingCounterAction, ServingCounterEnvironment>{ state, action, _ in
    switch action {
    case .decrementButtonTapped:
        guard state.serving > state.lowerLimit else { return .none }
        state.serving -= 1
        return .none
    case .incrementButtonTapped:
        guard state.serving < state.upperLimit else { return .none }
        state.serving += 1
        return .none
    }
}

struct ServingCounter: View {
    let store: Store<ServingCounterState, ServingCounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button(action: {
                    viewStore.send(.decrementButtonTapped)
                }) {
                    Image("minus")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.backgroundColor)
                        .scaledToFit()
                        .padding(5)
                }
                .frame(width: 17, height: 17)
                .background(
                    Circle()
                        .fill(Color.primaryColor)
                )
                Text("\(viewStore.serving)")
                    .font(.infoFont)
                    .foregroundColor(.textColor)
                    + Text(" pers")
                        .font(.subInfoFont)
                        .foregroundColor(.textColor)
                Button(action: {
                    viewStore.send(.incrementButtonTapped)
                }) {
                    Image("plus")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.backgroundColor)
                        .scaledToFit()
                        .padding(5)
                }
                .frame(width: 17, height: 17)
                .background(
                    Circle()
                        .fill(Color.primaryColor)
                )
            }
        }
    }
}

struct ServingCounter_Previews: PreviewProvider {
    static var previews: some View {
        ElementPreview(
            ServingCounter(
                store: Store(
                    initialState: ServingCounterState(),
                    reducer: servingCounterReducer,
                    environment: ServingCounterEnvironment()
                )
            )
        )
    }
}
