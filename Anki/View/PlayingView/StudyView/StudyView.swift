//
//  StudyView.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/18.
//

import SwiftUI

struct StudyView: View {
    var items: [Item]
	@State var genericItems: [Item] = []
    @State var fakeIndex = 0
    let goBackAndAddItem: () -> Void

    @State var offset: CGFloat = 0

    init(items: [Item], goBackAndAddItem: @escaping () -> Void) {
        self.items = items
        self.goBackAndAddItem = goBackAndAddItem
    }

    var body: some View {
        if items.isEmpty {
            AltView(goBackAndAddItem: goBackAndAddItem)
        } else {
            VStack(alignment: .center) {
                TabView(selection: $fakeIndex) {
                    ForEach(items.indices, id: \.self) { idx in
                        let item = items[idx]
                        GeometryReader { geometryProxy in
                            let scale = getScale(proxy: geometryProxy)
                            CardView(front: item.front!, back: item.back!, note: item.note!)
                                .padding(.horizontal, 50)
                                .frame(height: geometryProxy.size.height)
                                .scaleEffect(CGSize(width: scale, height: scale))
                                .animation(.easeOut(duration: 0.5), value: 1)
                        }
                        .overlay(
                            GeometryReader { proxy in
                                Color.clear.preference(key: OffSetKey.self,
                                                       value: proxy.frame(in: .global).minX)
                            })
                        .onPreferenceChange(OffSetKey.self, perform: { offset in
                            self.offset = offset
                        })
                        .tag(getIndex(item: item))
                    }.padding(.top, 120)
                }
                .padding()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: offset) { _ in
                if fakeIndex == 0 && offset == 0 {
                    fakeIndex = genericItems.count - 2
                }
                if fakeIndex == genericItems.count - 1 && offset == 0 {
                    fakeIndex = 1
                }
            }
			.onChange(of: items, perform: { _ in
				genericItems = items
				guard let first = genericItems.first else { return }
				guard let last = genericItems.last else { return }
				genericItems.append(first)
				genericItems.insert(last, at: 0)
			})
            .onAppear {
				genericItems = items
                guard let first = genericItems.first else { return }
                guard let last = genericItems.last else { return }
                genericItems.append(first)
                genericItems.insert(last, at: 0)
                fakeIndex = 1
            }
        }
    }

    private func getIndex(item: Item) -> Int {
        let index = genericItems.firstIndex(of: item) ?? 0
        return index
    }

    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1.0
        let coordinationX = proxy.frame(in: .global).minX
        let diff = abs(coordinationX - 70)
        if diff < 100 {
            scale = 1 + (diff / 425)
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

struct OffSetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout Value, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
