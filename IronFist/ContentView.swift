//
//  ContentView.swift
//  Shared
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI

struct GroupedListHeader: View {
    @EnvironmentObject var controller: IronFistController

    var body: some View {
        HStack {
            Text("Rice time: \(controller.fistTime)")
            Spacer()
            Text("Rest time: \(controller.restTime)")
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var controller: IronFistController
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            List {
                Section(header: GroupedListHeader()) {
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
            }
            // MER 2021-05-24 Consider .popover instead of a .sheet
            .sheet(isPresented: $showingSettings, content: {
                SettingsView()
            })
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Iron Fist")
            // https://www.appcoda.com/swiftui-toolbar/
            // https://swiftwithmajid.com/2020/07/15/mastering-toolbars-in-swiftui/
            .toolbar {
                settingsToolbarItem
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.controller.toggleRunning()
                    }, label: {
                        Text(self.controller.timerRunning ? "Stop" : "Start")
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text(self.controller.timerRunning ? "\(Int(controller.timerInterval))" : "")
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
            .disabled(self.controller.timerRunning)
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
