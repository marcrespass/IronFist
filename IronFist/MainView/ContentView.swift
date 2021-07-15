//
//  ContentView.swift
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI
import IronFistKit

struct ContentView: View {
    @EnvironmentObject var controller: IronFistController
    @State private var showingSettings = false
    @State private var isShowingDetailView = false
    @State private var selection: IronFist?

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: TimerView(), isActive: $isShowingDetailView) { EmptyView() }
                GroupedListHeader()
                List {
                    ForEach(controller.ironFists) { ironFist in
                        IronFistRow(showAll: (selection != nil && selection == ironFist), ironFist: ironFist)
                            .onTapGesture {
                                selection = selection == ironFist ? nil : ironFist
                            }
                    }
                }
                .sheet(isPresented: $showingSettings, content: { SettingsView() })
                .listStyle(DefaultListStyle())
                .navigationTitle(controller.timerRunning ? "Cancel" : "Iron Fist")
                .toolbar {
                    startStopToolbarItem
                    settingsToolbarItem
                }
            }
        }
    }
}

// MARK: - ToolbarContent
extension ContentView {
    // https://www.appcoda.com/swiftui-toolbar/
    // https://swiftwithmajid.com/2020/07/15/mastering-toolbars-in-swiftui/
    var startStopToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(self.controller.timerRunning ? "Stop" : "Start") {
                self.isShowingDetailView = true
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
        Group {
            ContentView()
                .environmentObject(controller)
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(controller)
        }
    }
}
