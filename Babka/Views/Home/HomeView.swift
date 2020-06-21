//
//  HomeView.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading, spacing: 20) {
                        HomeHeaderView(store: self.store)
                        IfLetStore(
                            self.store.scope(
                                state: { $0.lastRecipeAdded },
                                action: HomeAction.lastRecipeAdded
                            ),
                            then: { store in
                                VStack(alignment: .leading, spacing: 24) {
                                    Text("LAST ADDED").babkaSectionTitle()
                                    RecipeCell(store: store)
                                }.padding(.leading)
                            }
                        )
                        Text("COOKBOOKS")
                            .babkaSectionTitle()
                            .padding([.leading, .bottom])
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 30) {
                                ForEachStore(
                                    self.store.scope(state: { $0.cookbooks }, action: HomeAction.cookbook(id:action:))
                                ) { cookbookStore in
                                    CookbookCell(store: cookbookStore)
                                        .listRowBackground(Color.backgroundColor)
                                        .padding(.bottom, 20)
                                        .frame(width: 220, height: 300)
                                }
                            }
                            .padding(40)
                        }
                        .frame(height: 340)
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
                        .frame(width: 250)
                }
                Spacer()
                Image("search")
                    .renderingMode(.template)
                    .foregroundColor(.textColor)
                    .onTapGesture {
                        viewStore.send(.setSearch(isActive: true))
                }
            }
            .padding([.trailing, .top])
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
