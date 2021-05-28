//
//  GroupedListHeader.swift
//  IronFist
//
//  Created by Marc Respass on 5/28/21.
//

import SwiftUI

// https://thehappyprogrammer.com/custom-list-in-swiftui/
struct GroupedListHeader: View {
    @EnvironmentObject var controller: IronFistController
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Text("Rice time: \(controller.fistTime)")
            Spacer()
            Text("Rest time: \(controller.restTime)")
        }
    }
}
