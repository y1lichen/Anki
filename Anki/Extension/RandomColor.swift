//
//  RandomColor.swift
//  Anki
//
//  Created by 陳奕利 on 2022/2/21.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0 ... 1),
                     green: .random(in: 0 ... 1),
                     blue: .random(in: 0 ... 1)
        )
    }
}
