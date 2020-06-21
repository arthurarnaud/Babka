//
//  HomeCore.swift
//  Babka
//
//  Created by Arthur ARNAUD on 21/06/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Domain

struct HomeState: Equatable {
    var recipes: IdentifiedArrayOf<Recipe> = [
        Recipe(name: "Lasagna"),
        Recipe(name: "Pasta"),
        Recipe(name: "Soup"),
        Recipe(name: "Beef"),
        Recipe(name: "Lasagna"),
        Recipe(name: "Pasta"),
        Recipe(name: "Soup"),
        Recipe(name: "Beef"),
        Recipe(name: "Lasagna"),
        Recipe(name: "Pasta"),
        Recipe(name: "Tomato Soup"),
    ]
    var lastRecipeAdded: Recipe?
    var cookbooks: IdentifiedArrayOf<Cookbook> = [Cookbook(), Cookbook(), Cookbook(), Cookbook()]
    
    var search: SearchState?
    var isSearchActive: Bool { self.search != nil }
}

enum HomeAction: Equatable {
    case search(SearchAction)
    case lastRecipeAdded(RecipeCellAction)
    case cookbook(id: UUID, action: CookbookCellAction)
    case onAppear
    case setSearch(isActive: Bool)
}

struct HomeEnvironment: Equatable {}

// MARK: - Reducer

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment>
    .combine(
        Reducer { state, action, environment in
            switch action {
            case .lastRecipeAdded:
                return .none
            case .cookbook:
                return .none
            case .onAppear:
                state.lastRecipeAdded = state.recipes.last
                return .none
            case .search:
                return .none
            case .setSearch(isActive: true):
                state.search = SearchState(recipes: state.recipes)
                return .none
            case .setSearch(isActive: false):
                state.search = nil
                return .none
            }
        },
        searchReducer.optional.pullback(
            state: \.search,
            action: /HomeAction.search,
            environment: { _ in SearchEnvironment() }
        ),
        recipeCellReducer.optional.pullback(
            state: \.lastRecipeAdded,
            action: /HomeAction.lastRecipeAdded,
            environment: { _ in RecipeCellEnvironment(mainQueue: DispatchQueue.main.eraseToAnyScheduler()) }
        ),
        cookbookCellReducer.forEach(
            state: \.cookbooks,
            action: /HomeAction.cookbook(id:action:),
            environment: { _ in CookbookCellEnvironment() }
        )
).debug()
