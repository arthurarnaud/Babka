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
            VStack {
                Image("lasagna")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(20, corners: [.topLeft, .topRight])

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewStore.name)
                        .font(.titleFont)
                        .padding([.leading, .trailing])
                    InfoView(type: .recipeCount, value: viewStore.recipes.count)
                        .padding([.leading, .bottom, .trailing])
                }
            }
                
            .background(Color.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(radius: 10)
            .onTapGesture {
                viewStore.send(.cellTapped)
            }
        }.padding([.top, .bottom])
        
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
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
            .frame(width: 220, height: 300)
            .padding()
        )
    }
}

