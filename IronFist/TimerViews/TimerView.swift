//
//  TimerView.swift
//  IronFist
//
//  Created by Marc Respass on 6/3/21.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var controller: IronFistController

    var body: some View {
        VStack {
            Button {
                self.controller.toggle()
            } label: {
                Text(self.controller.timerRunning ? "Stop" : "Begin")
//                    .fontWeight(.bold)
                    .font(.title)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(self.controller.timerRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }

            TimerProgressCircle()
            VStack(alignment: .leading) { // Iron fist title and instruction display
                HStack {
                    if let ironFist = controller.selectedIronFist {
                        Text("\(ironFist.id).")
                        Text(ironFist.title)
                    }
                }
                .foregroundColor(self.controller.circleState.baseAccentColor)
                .font(.title.weight(.semibold))
                Text(controller.selectedIronFist?.instruction ?? "Finished…")
                    .font(.body)
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 4)
                    .foregroundColor(controller.circleState.baseAccentColor)
            )
            Spacer()
        }
        .padding([.leading, .trailing])
        .onAppear(perform: {
            self.controller.ready()
        })
        .onDisappear(perform: {
            self.controller.stop()
        })
    }
}

struct TimerView_Previews: PreviewProvider {
    static var controller = IronFistController()

    static var previews: some View {
        Group {
            TimerView()
                .environmentObject(controller)
//            TimerView()
//                .preferredColorScheme(.dark)
//                .environmentObject(controller)
        }
    }
}
