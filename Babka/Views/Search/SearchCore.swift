//
//  SearchCore.swift
//  Babka
//
//  Created by Arthur ARNAUD on 21/06/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct SearchState: Equatable {
    var recipes: IdentifiedArrayOf<Recipe>
    
    var searchQuery = ""
    
    var filteredRecipes: IdentifiedArrayOf<Recipe> {
        guard !searchQuery.isEmpty else { return self.recipes }
        return self.recipes.filter { $0.name.range(of: searchQuery, options: .caseInsensitive) != nil }
    }
    
    public init(recipes: IdentifiedArrayOf<Recipe>) {
        self.recipes = recipes
    }
}

enum SearchAction: Equatable {
    case recipe(id: UUID, action: RecipeCellAction)
    case searchQueryChanged(String)
}

struct SearchEnvironment: Equatable {}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment>
    .combine(
        Reducer<SearchState, SearchAction, SearchEnvironment> {
            state, action, environment in
            switch action {
            case let .searchQueryChanged(query):
                state.searchQuery = query
                
                return .none
            case .recipe(id: let id, action: let action):
                return .none
            }
        },
        recipeCellReducer.forEach(
            state: \.recipes,
            action: /SearchAction.recipe(id:action:),
            environment: { _ in RecipeCellEnvironment(
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            ) }
        )
).debug()
