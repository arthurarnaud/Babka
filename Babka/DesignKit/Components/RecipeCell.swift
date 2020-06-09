//
//  RecipeCell.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

enum RecipeCellAction: Equatable {
    case cellTapped
    case setNavigationActive(isActive: Bool)
}

struct RecipeCellEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let recipeCellReducer = Reducer<Recipe, RecipeCellAction, RecipeCellEnvironment>{ state, action, environment in
    switch action {
    case .cellTapped:
        state.isSelected = true
        return Effect(value: RecipeCellAction.setNavigationActive(isActive: true))
            .delay(for: 0.2, scheduler: environment.mainQueue)
            .eraseToEffect()
        
    case .setNavigationActive(isActive: true):
        state.isDetailShown = true
        return .none
        
    case .setNavigationActive(isActive: false):
        state.isSelected = false
        state.isDetailShown = false
        return .none
    }
}

struct RecipeCell: View {
    let store: Store<Recipe, RecipeCellAction>
    var minY: CGFloat = 0
    @State var show = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .leading) {
                NavigationLink(
                    destination: EmptyView(),
                    isActive: viewStore.binding(
                        get: { $0.isDetailShown },
                        send: RecipeCellAction.setNavigationActive(isActive:)
                    )
                ) {
                    EmptyView()
                }
                .isDetailLink(true)
                .disabled(true)
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(viewStore.isSelected ? .highlightedColor : .backgroundColor)
                HStack(spacing: 24) {
                    Image("lasagna")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .opacity(self.show ? 1 : 0)
                        .offset(x: self.show ? 0 : -20)
                        .animation(Animation.easeOut.delay(0.2))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading) {
                            Text(viewStore.type.name)
                                .font(.subtitleFont)
                                .foregroundColor(.primaryColor)
                                .opacity(self.show ? 1 : 0)
                                .offset(x: self.show ? 0 : 20)
                                .animation(Animation.easeOut.delay(0.3))
                            Text(viewStore.name)
                                .font(.titleFont)
                                .foregroundColor(.textColor)
                                .opacity(self.show ? 1 : 0)
                                .offset(x: self.show ? 0 : 20)
                                .animation(Animation.easeOut.delay(0.4))
                        }
                        HStack(spacing: 24) {
                            InfoView(type: .timer, value: viewStore.duration)
                            InfoView(type: .serving, value: viewStore.serving)
                        }
                        .opacity(self.show ? 1 : 0)
                        .offset(x: self.show ? 0 : 20)
                        .animation(Animation.easeOut.delay(0.5))
                    }
                }
                .padding()
            }
            .onAppear {
                self.show = true
            }
            .onTapGesture {
                viewStore.send(.cellTapped)
            }
            .scaleEffect(viewStore.isSelected ? 0.9 : 1)
            .animation(.easeInOut)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
              //  .shadow(color: .highlightedColor, radius: 10, x: 0, y: 4)
            .scaleEffect(self.minY < 0 ? self.minY / 500 + 1 : 1, anchor: .bottom)
            .opacity(Double(self.minY / 200 + 1))
            .offset(y: self.minY < 0 ? -self.minY : 0)
        }
    }
}

struct InfoView: View {
    var type: InfoType
    var value: Int
    
    enum InfoType {
        case timer
        case serving
        
        var iconName: String {
            switch self {
            case .timer:
                return "timer"
            case . serving:
                return "serving"
            }
        }
        
        var info: String {
            switch self {
            case .timer:
                return "min"
            case . serving:
                return "pers"
            }
        }
    }
    
    var body: some View {
        HStack {
            Image(type.iconName)
                .renderingMode(.original)
            Text("\(value)")
                .font(.infoFont)
                .foregroundColor(.textColor)
                + Text(" \(type.info)")
                    .font(.subInfoFont)
                    .foregroundColor(.textColor)
        }
    }
}

struct RecipeCell_Previews: PreviewProvider {
    static var previews: some View {
        ElementPreview(
            RecipeCell(
                store: Store(
                    initialState: Recipe(),
                    reducer: recipeCellReducer,
                    environment: RecipeCellEnvironment(
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                    )
                )
            )
        )
    }
}
