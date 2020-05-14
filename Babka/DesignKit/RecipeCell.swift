//
//  RecipeCell.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import ComposableArchitecture
import SwiftUI


struct RecipeCell: View {
    var body: some View {
        HStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 10, style: .circular)
                .fill(Color.gray)
                .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("MAIN COURSE")
                        .font(.subtitleFont)
                        .foregroundColor(.primaryColor)
                    Text("Tomato Soup")
                        .font(.titleFont)
                        .foregroundColor(.textColor)
                }
                HStack(spacing: 24) {
                    InfoView(type: .timer, value: 35)
                    InfoView(type: .serving, value: 3)
                }
            }
        }.frame(height: 100)
    }
}

struct InfoView: View {
    var type: InfoType
    var value: Int
    
    enum InfoType {
        case timer
        case serving
        
        var iconName: String {
            switch self {
            case .timer:
                return "timer"
            case . serving:
                return "serving"
            }
        }
        
        var info: String {
            switch self {
            case .timer:
                return "min"
            case . serving:
                return "pers"
            }
        }
    }
    
    var body: some View {
        HStack {
            Image(type.iconName)
            Text("\(value)")
                .font(.infoFont)
                .foregroundColor(.textColor)
                + Text("\(type.info)")
                    .font(.subInfoFont)
                    .foregroundColor(.textColor)
        }
    }
}

struct RecipeCell_Previews: PreviewProvider {
    static var previews: some View {
        ElementPreview(RecipeCell())
    }
}
