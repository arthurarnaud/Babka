//
//  ServingCounterTests.swift
//  BabkaTests
//
//  Created by Arthur ARNAUD on 11/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import XCTest
@testable import Babka

class ServingCounterTests: XCTestCase {

    func testIncrementCounterLimit() {
        let store = TestStore(
            initialState: ServingCounterState(
                serving: 19,
                upperLimit: 20,
                lowerLimit: 1
            ),
            reducer: servingCounterReducer,
            environment: ServingCounterEnvironment()
        )
        
        store.assert(
            .send(.incrementButtonTapped) {
                $0.serving = 20
            },
            .send(.incrementButtonTapped) {
                $0.serving = 20
            }
        )
    }
    
    func testDecrementCounterLimit() {
        let store = TestStore(
            initialState: ServingCounterState(
                serving: 2
            ),
            reducer: servingCounterReducer,
            environment: ServingCounterEnvironment()
        )
        
        store.assert(
            .send(.decrementButtonTapped) {
                $0.serving = 1
            },
            .send(.decrementButtonTapped) {
                $0.serving = 1
            }
        )
    }

}
