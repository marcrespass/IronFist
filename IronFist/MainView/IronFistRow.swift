//
//  IronFistRow.swift
//  IronFist
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
            .font(showAll ? .title : .body)
            Text(ironFist.instruction)
                .fontWeight(showAll ? .bold : .regular)
                .lineLimit(showAll ? nil : 1)
        }
    }
}

struct IronFistRow_Previews: PreviewProvider {
    static var controller = IronFistController()
    static var previews: some View {
        IronFistRow(showAll: false, ironFist: IronFistController.ironFistSample)
            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
