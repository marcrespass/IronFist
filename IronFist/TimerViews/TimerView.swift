//
//  TimerView.swift
//  IronFist
//
//  Created by Marc Respass on 6/3/21.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var controller: TimerController
    let ironFist: IronFist

    var body: some View {
        VStack {
            TimerProgressCircle()
            VStack(alignment: .leading) {
                HStack {
                    Text("\(ironFist.id).")
                    Text(ironFist.title)
                }
                .foregroundColor(self.controller.state.baseAccentColor)
                .font(.title.weight(.semibold))
                Text(ironFist.instruction)
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
    }
}

struct TimerView_Previews: PreviewProvider {
    static var controller = TimerController()

    static var previews: some View {
        TimerView(ironFist: IronFistController.sampleIronFist)
            .environmentObject(controller)
    }
}
