//
//  RecipeTypePicker.swift
//  Babka
//
//  Created by Arthur ARNAUD on 22/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct RecipeTypePickerState: Equatable {
    var selectedType: Int = 0
}

enum RecipeTypePickerAction: Equatable {
    case selectType(index: Int)
}

struct RecipeTypePickerEnvironment {}

let recipeTypePickerReducer = Reducer<RecipeTypePickerState, RecipeTypePickerAction, RecipeTypePickerEnvironment>{ state, action, _ in
    switch action {
    case .selectType(let index):
        state.selectedType = index
        return .none
    }
}

struct MyTextPreferenceData {
    let viewIdx: Int
    let bounds: Anchor<CGRect>
}

struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]
    
    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct RecipeTypeView: View {
    @Binding var activeType: Int
    let label: String
    let idx: Int
    
    var body: some View {
        Text(label)
            .font(.sectionTitle)
            .foregroundColor(.textColor)
            .padding(10)
            .anchorPreference(key: MyTextPreferenceKey.self, value: .bounds, transform: { [MyTextPreferenceData(viewIdx: self.idx, bounds: $0)]
            })
            .onTapGesture {
                self.activeType = self.idx
            }
    }
}


struct RecipeTypePicker : View {
    let store: Store<RecipeTypePickerState, RecipeTypePickerAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                VStack(spacing: 20) {
                    ForEach(RecipeType.allCases, id: \.self) { type in
                        RecipeTypeView(
                            activeType: viewStore.binding(
                                get: { $0.selectedType },
                                send: RecipeTypePickerAction.selectType(index:)
                            ),
                            label: type.name,
                            idx: type.rawValue)
                    }
                }
            }.backgroundPreferenceValue(MyTextPreferenceKey.self) { preferences in
                GeometryReader { geometry in
                    self.createBorder(geometry, preferences, viewStore.selectedType)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
        }
    }
    
    func createBorder(_ geometry: GeometryProxy, _ preferences: [MyTextPreferenceData], _ selectedType: Int) -> some View {
        
        let p = preferences.first(where: { $0.viewIdx == selectedType })
        
        let bounds = p != nil ? geometry[p!.bounds] : .zero
                
        return RoundedRectangle(cornerRadius: .infinity)
                .foregroundColor(Color.primaryColor)
                .frame(width: bounds.size.width, height: bounds.size.height)
                .fixedSize()
                .offset(x: bounds.minX, y: bounds.minY)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 1))
    }
}

struct RecipeTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTypePicker(
            store: Store(
                initialState: RecipeTypePickerState(),
                reducer: recipeTypePickerReducer,
                environment: RecipeTypePickerEnvironment()
            )
        )
    }
}
