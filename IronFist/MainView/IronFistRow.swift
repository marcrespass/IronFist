//
//  IronFistRow.swift
//
//  Created by Marc Respass on 5/28/21.
//

import SwiftUI
import IronFistKit

struct IronFistRow: View {
    var showAll: Bool = false
    let ironFist: IronFist

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(ironFist.id).")
                Text(ironFist.title)
            }
            .font(showAll ? .title : .body.bold())

            Text(ironFist.instruction)
                .fontWeight(showAll ? .medium : .regular)
                .lineLimit(showAll ? nil : 1)
            if showAll {
                Text(ironFist.motivation)
                    .fontWeight(.light)
                    .lineLimit(showAll ? nil : 1)
            }
        }
    }
}

#if DEBUG
struct IronFistRow_Previews: PreviewProvider {
    static var controller = IronFistController()
    static var previews: some View {
        IronFistRow(showAll: false, ironFist: controller.ironFistSample)
            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
#endif
