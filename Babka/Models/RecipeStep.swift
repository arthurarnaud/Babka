//
//  RecipeStep.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import Foundation

enum RecipeStepState: Int, Codable {
    case done
    case next
    case todo
}

struct RecipeStep: Codable, Equatable {
    var number: Int
    var text: String
    var state: RecipeStepState
    var duration: Double?
}
