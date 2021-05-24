//
//  ContentView.swift
//  Shared
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: IronFistController
    @State private var showingSettings = false

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
                            Text("\(ironFist.id).")
                            Text(ironFist.title)
                        }
                        Text(highlight ? ironFist.exercise : ironFist.exerciseTruncated)
                            .font(highlight ? .body : .caption)
                    }
                    .listRowBackground(highlight ? Color.green: Color.clear)
                }
            }
            // MER 2021-05-24 Consider .popover instead of a .sheet
            .sheet(isPresented: $showingSettings, content: {
                SettingsView()
            })
            .navigationTitle("Iron Fist")
            // https://www.appcoda.com/swiftui-toolbar/
            // https://swiftwithmajid.com/2020/07/15/mastering-toolbars-in-swiftui/
            .toolbar {
                settingsToolbarItem
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        self.controller.toggleRunning()
                    }, label: {
                        Text(self.controller.timerRunning ? "Stop" : "Start")
                    })
                    Spacer()
                    if self.controller.timerRunning {
                        Text("\(controller.timerInterval)")
                    } else {
                        HStack {
                            Text("Fist: \(controller.fistTime)")
                            Text("Rest: \(controller.restTime)")
                        }
                    }
                }
            }
        }
    }

    var settingsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showingSettings.toggle()
            } label: {
                Label("Settings", systemImage: "gear")
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
