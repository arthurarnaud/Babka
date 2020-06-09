//
//  RecipeTypePickerTests.swift
//  BabkaTests
//
//  Created by Arthur ARNAUD on 25/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import XCTest
@testable import Babka

class RecipeTypePickerTests: XCTestCase {

    func testSelectRecipeType() {
        let store = TestStore(
            initialState: RecipeTypePickerState(
                selectedType: 0
            ),
            reducer: recipeTypePickerReducer,
            environment: RecipeTypePickerEnvironment()
        )
        
        store.assert(
            .send(.selectType(index: 2)) {
                $0.selectedType = 2
            }
        )
    }
}
