// MARK: IMPORTANT🚨
// https://swiftuiviews.dev/post/34/circle-graph
/* For easy of copy/pastability, all code is in one bug chunk.
 Be a dear and refactor this out any way you see fit 🤘 */


/* Idealy, you would NOT be using pre-defined constants or first view at all, only the code below the refactor line.
 I am leaving the initial view here just for easier usage example or possible extraction. Hope that works 👌 */

/*
 Awesome Sauce!
 Thank you for getting one of my views, hope you are happy with it 👌
 Consider helping this train rollin 🚂 on my Patreon -> https://www.patreon.com/swiftui

 If you have any suggestions for improvements,
 feel free to reach me at undead.pix3l@gmail.com
 */

import SwiftUI

struct TimerProgressCircle: View {

    private let baseSize: CGFloat = 220
    private let lineWidth: CGFloat = 20
    private let shadowRadius: CGFloat = 20
    private let imageFontSize: CGFloat = 50
    private let textFontSize: CGFloat = 80
    private let completionStart: CGFloat = 0

    @EnvironmentObject var controller: TimerController

    fileprivate func circleCenterView() -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: baseSize, height: baseSize)
                .shadow(color: self.controller.state.shadowColor, radius: shadowRadius)
            VStack {
                Text(self.controller.state.symbol)
                    .font(Font.system(size: imageFontSize, weight: .black, design: .rounded))
                Text("\(self.controller.countdownString)")
                    .font(Font.system(size: textFontSize, weight: .heavy, design: .rounded).monospacedDigit())
            }
            .foregroundColor(self.controller.state.baseAccentColor)
        }
    }

    fileprivate func progressCircle() -> some View {
        Circle()
            .trim(from: completionStart, to: self.controller.tenths)
            .stroke(self.controller.state.baseAccentColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
            .frame(width: baseSize + lineWidth, height: baseSize + lineWidth)
            .padding()
            .rotationEffect(.degrees(-90))
            .shadow(color: self.controller.state.shadowColor, radius: shadowRadius)
//            .animation(.easeOut) // MER 2021-06-01 animations don't work well and the leaping actually helps count the tenths
    }

    var body: some View {
        VStack {
            ZStack {
                circleCenterView()
                    .padding()
                progressCircle()
            }
        }
        .padding()
    }
}

struct CircleGraph_Previews: PreviewProvider {
    static var controller = TimerController()

    static var previews: some View {
        VStack {
            TimerProgressCircle()
                .previewDevice("iPhone SE (2nd generation)")
                .preferredColorScheme(.light)
                .environmentObject(controller)
            Spacer()
        }
    }
}
