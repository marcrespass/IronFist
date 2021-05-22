//
//  ContentView.swift
//  Shared
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: IronFistController

    var body: some View {
        NavigationView {
            List {
                ForEach (controller.ironFists) { ironFist in
                    let highlight = ironFist == self.controller.selectedIronFist
                    VStack(alignment: .leading) {
                        HStack {
                            if highlight {
                                Image(systemName: "chevron.forward.circle.fill")
                            }
                            Text("\(ironFist.id)")
                            Text(ironFist.title)
                        }
                        Text(highlight ? ironFist.exercise : ironFist.shortExercise)
                            .font(.caption)
                    }
                    .listRowBackground(highlight ? Color.green: Color.clear)
                }
            }
            .navigationTitle("Iron Fist")
            // https://www.appcoda.com/swiftui-toolbar/
            // https://swiftwithmajid.com/2020/07/15/mastering-toolbars-in-swiftui/
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        self.controller.startIronFist()
                    }, label: {
                        Text("Start")
                    })
                    Spacer()
                    Text("\(controller.timerInterval)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var controller = IronFistController()

    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
