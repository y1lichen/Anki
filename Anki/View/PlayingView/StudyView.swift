//
//  StudyView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct StudyView: View {
	
    let items: [Item]
    let goBackAndAddItem: () -> Void

//	@State private var infiniteItem: [Item]
	
	init(items: [Item], goBackAndAddItem: @escaping () -> Void) {
		self.items = items
		self.goBackAndAddItem = goBackAndAddItem
	}
	
    var body: some View {
        if items.isEmpty {
            AltView(goBackAndAddItem: goBackAndAddItem)
        } else {
            VStack {
                Spacer().frame(height: 65)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 350) {
                        ForEach(items) { item in
                            GeometryReader { geometryProxy in
                                let scale = getScale(proxy: geometryProxy)
								CardView(front: item.front!, back: item.back!, note: item.note!)
									.scaleEffect(CGSize(width: scale, height: scale))
									.animation(.easeOut(duration: 0.5), value: 1)
                            }
                        }
					}.padding(32)
                }
            }
        }
    }

    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1.0
        let coordinationX = proxy.frame(in: .global).minX
        let diff = abs(coordinationX - 80)
        if diff < 100 {
            scale = 1 + (diff / 400)
        }
        return scale
    }

    struct AltView: View {
        let goBackAndAddItem: () -> Void
        var body: some View {
            Text("No item found.")
                .fontWeight(.bold)
            Button {
                goBackAndAddItem()
            } label: {
                Text("Click to create.")
            }
        }
    }
}
