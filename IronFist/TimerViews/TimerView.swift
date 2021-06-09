//
//  TimerView.swift
//  IronFist
//
//  Created by Marc Respass on 6/3/21.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var controller: TimerController

    var body: some View {
        VStack {
            TimerProgressCircle()
            VStack(alignment: .leading) { // Iron fist title and instruction display
                HStack {
                    if let ironFist = controller.selectedIronFist {
                        Text("\(ironFist.id).")
                        Text(ironFist.title)
                    }
                }
                .foregroundColor(self.controller.state.baseAccentColor)
                .font(.title.weight(.semibold))
                Text(controller.selectedIronFist?.instruction ?? "Finished…")
                    .font(.body)
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 4)
                    .foregroundColor(controller.state.baseAccentColor)
            )
            Spacer()
        }
        .padding([.leading, .trailing])
        .onAppear(perform: {
            self.controller.start()
        })
        .onDisappear(perform: {
            self.controller.stop()
        })
    }
}

struct TimerView_Previews: PreviewProvider {
    static var controller = TimerController()

    static var previews: some View {
        Group {
            TimerView()
                .environmentObject(controller)
            TimerView()
                .preferredColorScheme(.dark)
                .environmentObject(controller)
        }
    }
}
