//
//  TimePicker.swift
//  Babka
//
//  Created by Arthur ARNAUD on 25/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct TimePickerState: Equatable {
    var hour: Int = 0
    var min: Int = 0
    var hourRange: Range<Int> = 0..<11
    var minRange: Array<Int> = Array(stride(from: 0, to: 60, by: 5))
}

enum TimePickerAction: Equatable {
    case pickHour(hour: Int)
    case pickMin(min: Int)
}

struct TimePickerEnvironment {}

let TimePickerReducer = Reducer<TimePickerState, TimePickerAction, TimePickerEnvironment>{ state, action, _ in
    switch action {
    case .pickHour(let hour):
        guard state.hourRange.contains(hour) else { return .none }
        state.hour = hour
        return .none
    case .pickMin(let min):
        guard state.minRange.contains(min) else { return .none }
        state.min = min
        return .none
    }
}

struct TimePicker: View {
    let store: Store<TimePickerState, TimePickerAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Picker(
                    selection: viewStore.binding(
                        get: { $0.hour },
                        send: TimePickerAction.pickHour(hour:)
                    ),
                    label: Text("")) {
                        ForEach(viewStore.hourRange) {
                            Text("\($0)")
                                .font(.timePickerFont)
                                .foregroundColor(.textColor)
                        }
                }
                .frame(width: 50)
                .clipped()
                Text("h")
                    .font(.timePickerFont)
                    .foregroundColor(.primaryColor)
                Picker(
                    selection: viewStore.binding(
                        get: { $0.min },
                        send: TimePickerAction.pickMin(min:)
                    ),
                    label: Text("")) {
                        ForEach(viewStore.minRange, id: \.self) {
                            Text("\($0)")
                                .font(.timePickerFont)
                                .foregroundColor(.textColor)
                        }
                }
                .frame(width: 50)
                .clipped()
                Text("min")
                    .font(.timePickerFont)
                    .foregroundColor(.primaryColor)
            }
        }
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        ElementPreview(
            TimePicker(
                store: Store(
                    initialState: TimePickerState(),
                    reducer: TimePickerReducer,
                    environment: TimePickerEnvironment()
                )
            )
        )
    }
}

