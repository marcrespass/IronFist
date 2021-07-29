//
//  RoundedButtonStyle.swift
//  IronFist
//
//  Created by Marc Respass on 7/29/21.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(10)
            .background(self.color.cornerRadius(12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
