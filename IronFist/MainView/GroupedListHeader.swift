//
//  GroupedListHeader.swift
//
//  Created by Marc Respass on 5/28/21.
//

import SwiftUI
import IronFistKit

// https://thehappyprogrammer.com/custom-list-in-swiftui/
struct GroupedListHeader: View {
    @EnvironmentObject var settingsController: SettingsController
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        HStack {
            Text("Rice time:")
            Text("\(settingsController.fistTime)")
            Text("|")
            Text("Rest time:")
            Text("\(settingsController.restTime)")
            Spacer()
            Text("Repeat:")
            Text("\(settingsController.repetition)x")
        }
        .font(.subheadline)
#if !targetEnvironment(macCatalyst)
        .dynamicTypeSize(.medium ... .accessibility1)
#endif
        .padding([.leading, .trailing])
        .overlay(
            Rectangle()
                .stroke(lineWidth: 1)
                .foregroundColor(.gray)
        )
    }
}

#if DEBUG
struct GroupedListHeader_Previews: PreviewProvider {
    static var controller = SettingsController()

    static var previews: some View {
        GroupedListHeader()
            .previewLayout(.sizeThatFits)
            .previewDevice("iPhone 12 mini")
            .environmentObject(controller)
            .environment(\.locale, .init(identifier: "es"))
    }
}
#endif
