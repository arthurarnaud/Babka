//
//  Ingredient.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import Foundation

struct Ingredient: Codable, Equatable {
    var name: String
    var quantity: Double
    var unit: String
}
