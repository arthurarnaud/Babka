//
//  CookbookCell.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

enum CookbookCellAction: Equatable {
    case cellTapped
}

struct CookbookCellEnvironment {}

let cookbookCellReducer = Reducer<Cookbook, CookbookCellAction, CookbookCellEnvironment> { state, action, _ in
    switch action {
    case .cellTapped:
        state.selected = true
        return .none
    }
}

struct CookbookCell: View {
    let store: Store<Cookbook, CookbookCellAction>
    var minY: CGFloat = 0
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .center) {
                Image("lasagna")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .opacity(0.7)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                    
                Text(viewStore.name)
                    .font(.cookbookTitle)
                    .multilineTextAlignment(.center)
            }
            .onTapGesture {
                viewStore.send(.cellTapped)
            }
        }
        
    }
}

struct CookbookCell_Previews: PreviewProvider {
    static var previews: some View {
        ElementPreview(
            CookbookCell(
                store: Store(
                    initialState: Cookbook(),
                    reducer: cookbookCellReducer,
                    environment: CookbookCellEnvironment()
                )
            )
        )
    }
}

