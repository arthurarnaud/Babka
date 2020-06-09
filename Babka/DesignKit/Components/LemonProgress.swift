//
//  LemonProgress.swift
//  Babka
//
//  Created by Arthur ARNAUD on 15/05/2020.
//  Copyright © 2020 Arthur ARNAUD. All rights reserved.
//

import SwiftUI

struct LemonProgress: View {
    var steps: Int
    var currentSteps: Int = 3
    var selected = true
    var animationDuration: Double = 0.6
    
    var primaryColor: Color {
        return selected ? Color.primaryColor : Color.highlightedColor
    }

    @State private var show = false

    var body: some View {
        let petalWidth = Angle(degrees: (360 / Double(self.steps)))
        
        return GeometryReader { proxy in
            ZStack {
                Circle()
                    .strokeBorder(self.primaryColor, lineWidth: 3)
                
                ForEach(0..<self.steps) { i in
                    VStack {
                        LemonSlice(
                            angle: Angle(degrees: Double(i) * 360 / Double(self.steps)),
                            arc: petalWidth,
                            length: 0.9)
                            .stroke(i < self.currentSteps ? self.primaryColor : Color.highlightedColor,
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    }
                }
                
                ForEach(0..<self.steps) { i in
                    VStack {
                        LemonSlice(
                            angle: Angle(degrees: Double(i) * 360 / Double(self.steps)),
                            arc: petalWidth,
                            length: 0.9)
                            .foregroundColor(i < self.currentSteps - 1 ? self.primaryColor : Color.clear)
                    }
                }
                
            }
            .rotationEffect(Angle(degrees: -90))
        }
        .onAppear {
            self.show = true
        }
    }
}

struct LemonSlice: Shape {
    let angle: Angle
    var arc: Angle
    var length: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(arc.degrees, length) }
        set {
            arc = Angle(degrees: newValue.first)
            length = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let hypotenuse = Double(min(rect.width, rect.height)) / 2.0 * length
        
        let sep = arc / 2.2
        
        let newCenter = CGPoint(x: CGFloat(cos(angle.radians) * Double(hypotenuse / 6)) + center.x,
                                y: CGFloat(sin(angle.radians) * Double(hypotenuse / 6)) + center.y)
        
        let offset = Double(rect.width) / 25
        
        let to = CGPoint(x: CGFloat(cos(angle.radians) * Double(hypotenuse - offset)) + center.x,
                         y: CGFloat(sin(angle.radians) * Double(hypotenuse - offset)) + center.y)
        
        let ctrl1 = CGPoint(x: CGFloat(cos((angle + sep).radians) * Double(hypotenuse)) + center.x,
                            y: CGFloat(sin((angle + sep).radians) * Double(hypotenuse)) + center.y)
        
        let ctrl2 = CGPoint(x: CGFloat(cos((angle - sep).radians) * Double(hypotenuse)) + center.x,
                            y: CGFloat(sin((angle - sep).radians) * Double(hypotenuse)) + center.y)
        
        
        let test1 = midpoint(a: newCenter, b: ctrl1)
        let test2 = midpoint(a: newCenter, b: ctrl2)
        
        var path = Path()
        
        path.move(to: newCenter)
        path.addLine(to: test1)
        path.addQuadCurve(to: to, control: ctrl1)
        path.move(to: to)
        path.addQuadCurve(to: test2, control: ctrl2)
        path.addLine(to: newCenter)

        return path
    }
    
    func midpoint(a: CGPoint, b: CGPoint) -> CGPoint {
        var ret = CGPoint()
        ret.x = (a.x + b.x) / 2;
        ret.y = (a.y + b.y) / 2;
        return ret
    }
}

struct DemoView: View{
    @State private var steps: Int = 8
    var body: some View {
        VStack {
            LemonProgress(steps: self.steps)
                .animation(.easeInOut)
                .layoutPriority(1)
            HStack(spacing: 20) {
                Button(action: {
                    self.steps = 6
                }) {
                    Text("6")
                }
                Button(action: {
                    self.steps = 8
                }) {
                    Text("8")
                }
                Button(action: {
                    self.steps = 15
                }) {
                    Text("15")
                }
            }
            
        }
    }
}

struct LemonProgress_Previews: PreviewProvider {
    static var previews: some View {
        ElementPreview(
             LemonProgress(steps: 8, currentSteps: 5)
        )
    }
}

