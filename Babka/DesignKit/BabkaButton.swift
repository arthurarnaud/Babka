//
//  BabkaButton.swift
//  Babka
//
//  Created by Arthur ARNAUD on 14/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import Foundation
import SwiftUI

struct BabkaButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 50, style: .circular)
                    .fill(Color.primaryColor)
            )
            .padding(.bottom, 8)
    }
}

extension View {
    func babkaButton() -> ModifiedContent<Self, BabkaButtonModifier> {
        return modifier(BabkaButtonModifier())
    }
}


struct BabkaButton_Previews: PreviewProvider {
    static var previews: some View {
        ElementPreview(Text("Continue").babkaButton())
    }
}
