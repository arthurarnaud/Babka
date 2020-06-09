//
//  CardView.swift
//  Babka
//
//  Created by Arthur ARNAUD on 18/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import SwiftUI


struct CardView: View {
    var minY: CGFloat = 100
    
    var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.red)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .shadow(radius: 20)
            .scaleEffect(self.minY < 0 ? self.minY / 1000 + 1 : 1, anchor: .bottom)
            .opacity(Double(self.minY / 300 + 1))
            .offset(y: self.minY < 0 ? -self.minY : 0)
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach((1...10).reversed(), id: \.self) { _ in
                    GeometryReader { geometry in
                        CardView(minY: geometry.frame(in: .global).minY - 100)
                    }.frame(height: 150)
                }
            }
            .padding()
        }
    }
}
