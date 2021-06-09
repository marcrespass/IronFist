//
//  GroupedListHeader.swift
//  IronFist
//
//  Created by Marc Respass on 5/28/21.
//

import SwiftUI

// https://thehappyprogrammer.com/custom-list-in-swiftui/
struct GroupedListHeader: View {
    @EnvironmentObject var controller: TimerController

    var body: some View {
        HStack {
            Text("Rice time: \(controller.fistTime)")
            Spacer()
            Text("Rest time: \(controller.restTime)")
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding([.leading, .trailing])
        .background(Color.gray)
    }
}

struct GroupedListHeader_Previews: PreviewProvider {
    static var controller = TimerController()

    static var previews: some View {
        GroupedListHeader()
            .environmentObject(controller)
    }
}
