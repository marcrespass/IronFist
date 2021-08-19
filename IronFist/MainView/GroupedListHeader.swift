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
        .font(.headline)
        .foregroundColor(.white)
        .padding([.leading, .trailing])
        .background(Color.gray)
    }
}

#if DEBUG
struct GroupedListHeader_Previews: PreviewProvider {
    static var controller = SettingsController()

    static var previews: some View {
        GroupedListHeader()
            .environmentObject(controller)
            .environment(\.locale, .init(identifier: "es"))
    }
}
#endif
