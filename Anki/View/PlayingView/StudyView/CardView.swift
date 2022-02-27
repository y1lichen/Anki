//
//  CardView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct CardView: View {
    @State private var showBack: Bool = false
    let front: String
    let back: String
    let note: String

    var body: some View {
        FlipView(front: FrontCardView(front: front),
				 back: BackCardView(back: back, note: note),
				 showBack: $showBack)
    }
}

struct FrontCardView: View {
    let front: String
    var body: some View {
        Text(front)
            .fontWeight(.bold)
            .font(.system(size: 50))
            .minimumScaleFactor(0.4)
            .frame(width: 300, height: 400)
            .background(Color(UIColor.systemBackground))
            .overlay(RoundedRectangle(cornerRadius: 25.0, style: .circular)
                .stroke(.blue, lineWidth: 8))
    }
}

struct BackCardView: View {
    let back: String
    let note: String
    var body: some View {
        VStack {
            Text(back)
                .fontWeight(.bold)
                .font(.system(size: 50))
                .minimumScaleFactor(0.4)
            Spacer()
                .frame(height: 30)
            Text(note)
                .font(.system(size: 30))
                .minimumScaleFactor(0.2)
                .padding(.horizontal, 10)
        }
        .padding(15)
		.frame(width: 300, height: 400)
		.background(Color(UIColor.systemBackground))
		.overlay(RoundedRectangle(cornerRadius: 25.0, style: .circular)
			.stroke(.blue, lineWidth: 8))
    }
}

struct FlipView<SomeTypeOfViewA: View, SomeTypeOfViewB: View>: View {
    var front: SomeTypeOfViewA
    var back: SomeTypeOfViewB

    @State private var flipped = false
    @Binding var showBack: Bool

    var body: some View {
        VStack {
            ZStack {
                front.opacity(flipped ? 0.0 : 1.0)
                back.opacity(flipped ? 1.0 : 0.0)
            }
            .modifier(FlipEffect(flipped: $flipped, angle: showBack ? 180 : 0, axis: (x: 1, y: 0)))
            .onTapGesture {
                withAnimation(Animation.linear(duration: 0.4)) {
                    self.showBack.toggle()
                }
            }
            Spacer()
        }
    }
}

struct FlipEffect: GeometryEffect {
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)

    func effectValue(size: CGSize) -> ProjectionTransform {
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270
        }

        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)

        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1 / max(size.width, size.height)

        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width / 2.0, -size.height / 2.0, 0)

        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0))

        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}
