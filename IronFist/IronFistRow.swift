//
//  IronFistRow.swift
//  IronFist
//
//  Created by Marc Respass on 5/28/21.
//

import SwiftUI

struct IronFistRow: View {
    @EnvironmentObject var controller: TimerController

    let ironFist: IronFist

    var body: some View {
        let highlight = ironFist == self.controller.selectedIronFist
        VStack(alignment: .leading) {
            HStack {
                if highlight {
                    Image(systemName: "chevron.forward.circle.fill")
                }
                Text("\(ironFist.id).")
                Text(ironFist.title)
            }
            Text(highlight ? ironFist.instruction : ironFist.instructionTruncated)
                .font(highlight ? .body : .caption)
        }
        .listRowBackground(highlight ? Color.green: Color.clear)
    }
}

struct IronFistRow_Previews: PreviewProvider {
    static var controller = TimerController()
    static var previews: some View {
        IronFistRow(ironFist: controller.ironFists[5])
            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
