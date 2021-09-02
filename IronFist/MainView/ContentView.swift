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
                .navigationTitle("Iron Fist")
                .toolbar {
                    startStopToolbarItem
                    settingsToolbarItem
                }
            }
            TimerView()
        }
    }
}

// MARK: - ToolbarContent
extension ContentView {
    // https://www.appcoda.com/swiftui-toolbar/
    // https://swiftwithmajid.com/2020/07/15/mastering-toolbars-in-swiftui/
    var startStopToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Start") {
                self.controller.readyTimer()
                self.isShowingDetailView = true
            }
            .disabled(self.controller.timerRunning)
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

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var controller = IronFistController()
    static var settingsController = SettingsController()

    static var previews: some View {
        Group {
            if #available(iOS 15.0, *) {
                ContentView()
                    .environmentObject(controller)
                    .environmentObject(settingsController)
                    .environment(\.locale, .init(identifier: "es"))
                    .previewInterfaceOrientation(.landscapeLeft)
            } else {
                // Fallback on earlier versions
            }
            ContentView()
                .environmentObject(controller)
                .environmentObject(settingsController)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
