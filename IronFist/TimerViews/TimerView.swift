//
//  TimerView.swift
//
//  Created by Marc Respass on 6/3/21.
//

import SwiftUI
import IronFistKit

struct TimerView: View {
    @EnvironmentObject var controller: IronFistController

    var body: some View {
        VStack {
            HStack {
                self.timerButton()
                Spacer()
                Text("Repeat: \(controller.repeatCount)/\(controller.maxRepetitions)")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 4)
                            .foregroundColor(controller.circleState.timerCircleColor)
                    )

            }
            .padding([.leading, .trailing])

            TimerProgressCircle()
            if let ironFist = controller.selectedIronFist {
                self.ironFistText(ironFist)
            } else {
                self.finishedText()
            }
            Spacer()
        }
        .padding([.leading, .trailing])
        .onAppear(perform: {
            self.controller.readyTimer()
        })
        .onDisappear(perform: {
            self.controller.stopTimer()
        })
    }
}

// MARK: - Private View methods
extension TimerView {
    fileprivate func timerButton() -> some View {
        Button {
            self.controller.toggleTimer()
        } label: {
            self.controller.stopBeginButtonLabel()
        }
        .buttonStyle(RoundedButtonStyle(color: self.controller.timerRunning ? .red : .green))
    }

    fileprivate func ironFistText(_ ironFist: IronFist) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(ironFist.id).")
                Text(ironFist.title)
            }
            .foregroundColor(self.controller.circleState.titleColor)
            .font(.title.weight(.semibold))
            Text(ironFist.instruction)
                .font(.body.weight(.medium))
            Text(ironFist.motivation)
                .font(.body.italic())
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: 4)
                .foregroundColor(controller.circleState.timerCircleColor)
        )
    }

    fileprivate func finishedText() -> some View {
        Text("Finished.")
            .foregroundColor(self.controller.circleState.titleColor)
            .font(.title.weight(.semibold))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 4)
                    .foregroundColor(controller.circleState.timerCircleColor)
            )

    }
}

#if DEBUG
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
                .preferredColorScheme(.dark)
                .environmentObject(IronFistController())
        }
    }
}
#endif
