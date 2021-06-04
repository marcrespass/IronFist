//
//  ContentView.swift
//  Shared
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: TimerController
    @State private var showingSettings = false
    @State private var isShowingDetailView = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: TimerView(), isActive: $isShowingDetailView) { EmptyView() }

                List {
                    Section(header: GroupedListHeader()) {
                        ForEach (controller.ironFists) { ironFist in
                            IronFistRow(ironFist: ironFist)
                        }
                    }
                }
                // MER 2021-05-24 Consider .popover instead of a .sheet
                .sheet(isPresented: $showingSettings, content: { SettingsView() })
                .listStyle(InsetListStyle())

                .navigationTitle(controller.timerRunning ? "Cancel" : "Iron Fist")
                .toolbar {
                    startStopToolbarItem
                    //                timerValueToolbarItem
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

    var timerValueToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(controller.countdownString)
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
    static var controller = TimerController()

    static var previews: some View {
        ContentView()
            //            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
