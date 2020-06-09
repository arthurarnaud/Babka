//
//  Recipe.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import Foundation

enum RecipeType: Int, Codable, CaseIterable {
    case starter
    case mainCourse
    case dessert
    
    var name: String {
        switch self {
        case .starter:
            return "STARTER"
        case .mainCourse:
            return "MAIN COURSE"
        case .dessert:
            return "DESSERT"
        }
    }
}

struct Recipe: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String = "Lasagna"
    var type: RecipeType = .mainCourse
    var duration: Int = 35
    var serving: Int = 3
    var picture: String = "lasagna"
    var ingredients: [Ingredient] = []
    var detail: [RecipeStep] = []
    var isSelected: Bool = false
    var isDetailShown: Bool = false
}
