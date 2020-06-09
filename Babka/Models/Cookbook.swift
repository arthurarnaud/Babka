//
//  Cookbook.swift
//  Babka
//
//  Created by Arthur ARNAUD on 18/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import Foundation

struct Cookbook: Identifiable ,Codable, Equatable {
    var id: UUID = UUID()
    var name: String = "Main Course"
    var picture: String = "lasagna"
    var recipes: [Recipe] = []
    var selected: Bool = false
}
