//
//  CheckboxToggleStyle.swift
//  IronFist
//
//  Created by Marc Respass on 7/29/21.
//

import SwiftUI

// https://swiftwithmajid.com/2020/03/04/customizing-toggle-in-swiftui/
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
