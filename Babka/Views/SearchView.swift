//
//  SearchView.swift
//  Babka
//
//  Created by Arthur ARNAUD on 19/05/2020.
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

struct SearchView: View {
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    HStack(spacing: 20) {
                        Spacer()
                        Image("search")
                            .renderingMode(.template)
                            .foregroundColor(.primaryColor)
                        TextField(
                            "Find your recipe",
                            text: viewStore.binding(
                                get: { $0.searchQuery }, send: SearchAction.searchQueryChanged)
                        )
                        .font(.searchText)
                        .foregroundColor(.primaryColor)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }.padding()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEachStore(
                                self.store.scope(state: { $0.filteredRecipes }, action: SearchAction.recipe(id:action:))
                            ) { recipeStore in
                                GeometryReader { geometry in
                                    RecipeCell(store: recipeStore, minY: geometry.frame(in: .global).minY - 120)
                                    .padding()
                                }
                                .frame(height: 120)
                            }
                        }
                    }
                }
                .fillWithBackgroundColor()
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }.onAppear {
                UITableView.appearance().separatorStyle = .none
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            store: Store(
                initialState: SearchState(recipes: [
                    Recipe(name: "Lasagna"),
                    Recipe(name: "Pasta"),
                ]),
                reducer: searchReducer,
                environment: SearchEnvironment()
            )
        )
    }
}
