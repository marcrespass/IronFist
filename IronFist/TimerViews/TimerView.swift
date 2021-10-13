//
//  TimerView.swift
//
//  Created by Marc Respass on 6/3/21.
//

import SwiftUI
import IronFistKit

// https://useyourloaf.com/blog/swiftui-custom-view-modifiers/
// That’s a bit ugly. A better way is to add our custom modifier as an extension on View:
struct RepeatCaption: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    func body(content: Content) -> some View {
        content
            .font(.title)
            .dynamicTypeSize(.medium ... .accessibility1)
            .padding([.leading, .trailing], 8)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.yellow)
            )
    }

}

struct RoundedButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding([.leading, .trailing], 8)
            .background(self.color.cornerRadius(12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// https://www.fivestars.blog/articles/adaptive-swiftui-views/
struct TimerView: View {
    @EnvironmentObject var controller: IronFistController
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    @ViewBuilder
    func RepeatText(label: String) -> some View {
        ButtonLabelText(label: label)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 4)
                    .foregroundColor(controller.circleState.timerCircleColor)
            )
    }

    fileprivate func ButtonLabelText(label: String) -> Text {
        return Text(label)
            .fontWeight(.bold)
            .font(.title)
    }

    var body: some View {
        VStack {
            VStack {
                Button {
                    self.controller.toggleTimer()
                } label: {
                    ButtonLabelText(label: self.controller.timerRunning ? "Stop" : "Begin")
                        .padding(8)
                }
                .buttonStyle(RoundedButtonStyle(color: self.controller.timerRunning ? .red : .green))
                .dynamicTypeSize(.medium ... .accessibility1)
            }

            TimerProgressCircle()
            HStack {
                Text("Repeat: \(controller.maxRepetitions)X")
                Spacer()
                Text("\(controller.repeatCount) of \(controller.maxRepetitions)")
            }
            .font(.title3)
            .overlay(Divider().background(Color.black), alignment: .bottom) // https://stackoverflow.com/a/64921380

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
            if sizeCategory < .extraExtraExtraLarge {
                Text(ironFist.motivation)
                    .font(.body.italic())
            }
        }
        .dynamicTypeSize(.medium ... .accessibility1)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(lineWidth: 4)
                .foregroundColor(controller.circleState.timerCircleColor)
        )
    }

    fileprivate func finishedText() -> some View {
        Text("Finished")
            .foregroundColor(self.controller.circleState.titleColor)
            .font(.title.weight(.semibold))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 4)
                    .foregroundColor(controller.circleState.timerCircleColor)
            )
            .dynamicTypeSize(.medium ... .accessibility1)
    }
}

#if DEBUG
// extraSmall
// small
// medium
// large
// extraLarge
// extraExtraLarge
// extraExtraExtraLarge
// accessibilityMedium
// accessibilityLarge
// accessibilityExtraLarge
// accessibilityExtraExtraLarge
// accessibilityExtraExtraExtraLarge

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
//                .preferredColorScheme(.dark)
                .environmentObject(IronFistController.readyController)
                .environment(\.sizeCategory, .large) // normal is .large
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
#endif
