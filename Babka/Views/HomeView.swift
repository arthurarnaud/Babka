//
//  HomeView.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

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
        Recipe(name: "Soup"),
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

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment>
    .combine(
        Reducer { state, action, environment in
            switch action {
            case .lastRecipeAdded:
                return .none
            case .cookbook:
                return .none
            case .onAppear:
                UITableView.appearance().separatorStyle = .none
                UITableView.appearance().backgroundColor = UIColor.clear
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

struct HomeView: View {
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack(alignment: .bottomTrailing) {
                    VStack {
                        HomeHeaderView(store: self.store)
                        List {
                            IfLetStore(
                                self.store.scope(
                                    state: { $0.lastRecipeAdded },
                                    action: HomeAction.lastRecipeAdded
                                ),
                                then: { store in
                                    VStack(alignment: .leading, spacing: 24) {
                                        Text("LAST ADDED").babkaSectionTitle()
                                        RecipeCell(store: store)
                                    }.listRowBackground(Color.backgroundColor)
                            }
                            )
                            Text("COOKBOOKS")
                                .listRowBackground(Color.backgroundColor)
                                .babkaSectionTitle()
                            // TODO: Fix design by using some kind of UICollectionView
                            ForEachStore(
                                self.store.scope(state: { $0.cookbooks }, action: HomeAction.cookbook(id:action:))
                            ) { cookbookStore in
                                CookbookCell(store: cookbookStore)
                                    .listRowBackground(Color.backgroundColor)
                                    .padding(.bottom, 20)
                            }
                        }
                    }
                    .fillWithBackgroundColor()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    
                    Button(action: { }, label: {
                      Image("plus")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.primaryColor)
                        .cornerRadius(.infinity)
                        .shadow(radius: 10)
                        .frame(width: 60, height: 60)
                        .offset(x: -20, y: -20)
                    })
                }
            }
            .onAppear { viewStore.send(.onAppear) }
            .sheet(
                isPresented: viewStore.binding(
                    get: { $0.isSearchActive },
                    send: HomeAction.setSearch(isActive:)
                )
            ) {
                IfLetStore(
                    self.store.scope(
                        state: \.search,
                        action: HomeAction.search
                    ),
                    then: SearchView.init(store:)
                )
            }
            
        }
    }
}

struct HomeHeaderView: View {
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Recipes")
                        .font(.homeTitle)
                        .foregroundColor(.textColor)
                        .lineLimit(1)
                        .frame(width: 200)
                }
                Spacer()
                Image("search")
                    .renderingMode(.template)
                    .foregroundColor(.textColor)
                    .onTapGesture {
                        viewStore.send(.setSearch(isActive: true))
                }
            }
            .padding()
        }
    }
}

struct FillWithBackgroundColorModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

extension View {
    func fillWithBackgroundColor() -> ModifiedContent<Self, FillWithBackgroundColorModifier> {
        return modifier(FillWithBackgroundColorModifier())
    }
}

struct BabkaSectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.sectionTitle)
            .foregroundColor(.textColor)
    }
}

extension View {
    func babkaSectionTitle() -> ModifiedContent<Self, BabkaSectionTitleModifier> {
        return modifier(BabkaSectionTitleModifier())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: Store(
                initialState: HomeState(),
                reducer: homeReducer,
                environment: HomeEnvironment()
            )
        )
    }
}
