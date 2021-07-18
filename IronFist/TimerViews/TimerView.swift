//
//  TimerView.swift
//
//  Created by Marc Respass on 6/3/21.
//

import SwiftUI
import IronFistKit

struct RoundedButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(10)
            .background(self.color.cornerRadius(12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct TimerView: View {
    @EnvironmentObject var controller: IronFistController

    var body: some View {
        VStack {
            Button {
                self.controller.toggle()
            } label: {
                self.controller.buttonLabel()
            }
            .buttonStyle(RoundedButtonStyle(color: self.controller.timerRunning ? .red : .green))

            TimerProgressCircle()
            VStack(alignment: .leading) {
                HStack { // Iron fist title and instruction display
                    if let ironFist = controller.selectedIronFist {
                        Text("\(ironFist.id).")
                        Text(ironFist.title)
                    }
                }
                .foregroundColor(self.controller.circleState.titleColor)
                .font(.title.weight(.semibold))
                Text(controller.selectedIronFist?.instruction ?? "Finished…")
                    .font(.body.weight(.medium))
                if let motivation = controller.selectedIronFist?.motivation {
                    Text(motivation)
                        .font(.body.italic())
                }
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 4)
                    .foregroundColor(controller.circleState.timerCircleColor)
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
    static var previews: some View {
        Group {
            TimerView()
                .preferredColorScheme(.dark)
                .environmentObject(IronFistController.readyController)
        }
    }
}
