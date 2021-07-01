//
//  IronFistRow.swift
//  IronFist
//
//  Created by Marc Respass on 5/28/21.
//

import SwiftUI

struct IronFistRow: View {
    let ironFist: IronFist

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(ironFist.id).")
                Text(ironFist.title)
            }
            Text(ironFist.instruction)
                .lineLimit(1)
        }
    }
}

struct IronFistRow_Previews: PreviewProvider {
    static var controller = IronFistController()
    static var previews: some View {
        IronFistRow(ironFist: IronFistController.ironFistSample)
            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
