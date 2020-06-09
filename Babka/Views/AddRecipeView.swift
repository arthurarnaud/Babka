//
//  AddRecipeView.swift
//  Babka
//
//  Created by Arthur ARNAUD on 23/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

enum AddRecipeStep: Int, Codable, CaseIterable {
    case name
    case type
    case serving
    case time
    case ingredients
    case recipe
    case picture
    case preview
    
    var title: String? {
        switch self {
        case .name: return "What do we eat?"
        case .type: return "What type of meal?"
        case .serving: return "How many are we?"
        case .time: return "How long does it take?"
        case .ingredients: return "What are the ingredients ?"
        case .recipe: return "So, How do we cook it?"
        case .picture: return "What does it look like?"
        case .preview: return nil
        }
    }
}

struct AddRecipeState: Equatable {
    var currentStep: AddRecipeStep = .name
    var recipeSteps: [AddRecipeStep] = [
        .name,
        .type,
        .serving,
        .time,
        .ingredients,
        .recipe,
        .picture,
        .preview
    ]
    var serving: ServingCounterState = ServingCounterState()
}

enum AddRecipeAction: Equatable {
    case tapContinue
    case tapBack
    case name
    case type
    case serving(ServingCounterAction)
    case time
    case ingredients
    case recipe
    case picture
    case preview
}

struct AddRecipeEnvironment {}

let addRecipeReducer: Reducer<AddRecipeState, AddRecipeAction, AddRecipeEnvironment> = Reducer.combine(
    Reducer { state, action, _ in
        switch action {
        case .tapContinue:
            guard state.currentStep.rawValue + 1 < state.recipeSteps.count else { return .none }
            state.currentStep = state.recipeSteps[state.currentStep.rawValue + 1]
            return .none
        case .tapBack:
            guard state.currentStep.rawValue > 0 else { return .none }
            state.currentStep = state.recipeSteps[state.currentStep.rawValue - 1]
            return .none
        default:
            return .none
        }
    },
    servingCounterReducer.pullback(
        state: \.serving,
        action: /AddRecipeAction.serving,
        environment: { _ in ServingCounterEnvironment() }
    ).debug()
)

struct AddRecipeView: View {
    let store: Store<AddRecipeState, AddRecipeAction>
    
    @State var animateNext = false
    @State var animateBack = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack() {
                ZStack {
                    if (viewStore.currentStep.rawValue > 0) {
                        LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1, selected: false)
                            .frame(width: 100, height: 100, alignment: .leading)
                            .offset(x: self.animateNext ? -300 : -120)
                            .animation(.easeOut(duration: 0.4))
                            .opacity(self.animateNext ? 1 : 0)
                        
                        LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1, selected: false)
                            .frame(width: 100, height: 100, alignment: .leading)
                            .offset(x: self.animateBack ? -120 : -300)
                            .animation(.easeOut(duration: 0.4))
                            .opacity(self.animateBack ? 1 : 0)


                        
                        LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1, selected: false)
                            .frame(width: 100, height: 100, alignment: .leading)
                            .opacity(self.animateNext || self.animateBack ? 0 : 1)
                            .offset(x: -120)
                            .onTapGesture {
                                self.animateBack.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.animateBack.toggle()
                                }
                                viewStore.send(.tapBack)
                        }
                    }
                    
                    LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1, selected: true)
                        .frame(width: 100, height: 100, alignment: .leading)
                        .scaleEffect(self.animateBack ? 1.25 : 1)
                        .offset(x: self.animateBack ? 0 : -120)
                        .animation(.easeOut(duration: 0.4))
                        .opacity(self.animateBack ? 1 : 0)

                    LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1, selected: true)
                        .frame(width: 125, height: 125)
                        .scaleEffect(self.animateNext ? 1 : 0)
                        .rotationEffect(Angle(degrees: self.animateNext ? 0 : -180))
                        .offset(y: self.animateNext ? 0 : -200)
                        .animation(.easeOut(duration: 0.4))
                        .opacity(self.animateNext ? 1 : 0)
                    
                    LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1, selected: false)
                        .frame(width: 125, height: 125)
                        .scaleEffect(self.animateBack ? 0 : 1)
                        .rotationEffect(Angle(degrees: self.animateBack ? -180 : 0))
                        .offset(y: self.animateBack ? -200 : 0)
                        .animation(.easeOut(duration: 0.4))
                        .opacity(self.animateBack ? 1 : 0)
                    
                    LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1, selected: false)
                        .frame(width: 125, height: 125)
                        .scaleEffect(self.animateNext ? 0.8 : 1)
                        .animation(.easeOut(duration: 0.4))
                        .offset(x: self.animateNext ? -120 : 0)
                        .opacity(self.animateNext ? 1 : 0)

                    LemonProgress(steps: viewStore.recipeSteps.count, currentSteps: viewStore.currentStep.rawValue + 1)
                        .frame(width: 125, height: 125)
                        .opacity(self.animateNext || self.animateBack ? 0 : 1)

                }.frame(maxWidth: .infinity, alignment: .center)
                
                ServingCounter(store:  self.store.scope(
                    state: { $0.serving },
                    action: AddRecipeAction.serving
                    )
                )
                Text(viewStore.currentStep.title ?? "")
                Button(action: {
                    self.animateNext.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.animateNext.toggle()
                    }
                    viewStore.send(.tapContinue)
                }) {
                    Text("Next")
                }
                Button(action: {
                    self.animateBack.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.animateBack.toggle()
                    }
                    viewStore.send(.tapBack)
                }) {
                    Text("Back")
                }
            }
        }
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(store: Store(
            initialState: AddRecipeState(),
            reducer: addRecipeReducer,
            environment: AddRecipeEnvironment())
        )
    }
}
