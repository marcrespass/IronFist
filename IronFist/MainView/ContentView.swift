//
//  ContentView.swift
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI
import IronFistKit

// https://www.avanderlee.com/swiftui/stateobject-observedobject-differences/
struct ContentView: View {
    @EnvironmentObject var controller: IronFistController
    @State private var showingSettings = false
    @State private var isShowingDetailView = false
    @State private var selection: IronFist?

    // https://sarunw.com/posts/what-is-keypath-in-swift/

    // SwiftUI has VSplitView, but it’s only available for Mac apps.
    // https://augmentedcode.io/2021/09/13/sidebar-layout-on-macos-in-swiftui

    // How to compose SwiftUI views with @ViewBuilder
    // https://www.fivestars.blog/articles/design-system-composing-views/

    // Programmatic navigation in SwiftUI
    // https://www.swiftbysundell.com/articles/swiftui-programmatic-navigation
    // How Sidebar works on iPad with SwiftUI
    // https://kristaps.me/blog/swiftui-sidebar/
    // How do I customize the NavigationView in SwiftUI?
    // https://www.bigmountainstudio.com/community/public/posts/80041-how-do-i-customize-the-navigationview-in-swiftui
    /*
     You could also use `let _ = Self._printChanges()` in the body of the view that you see loosing state to see what  is causing the re-rendering.
     */
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: TimerView(), isActive: $isShowingDetailView) { EmptyView() }
                GroupedListHeader()
                List {
                    ForEach(controller.ironFists) { ironFist in
                        // https://twitter.com/mhuletdev/status/1495123504366329859
                        // let horizontalMax = dump(geometry.size.width) + dump(geometry.frame(in: .global).maxX)
//                        let dmp = dump(ironFist)
//                        _ = print(ironFist)
                        IronFistRow(showAll: (selection != nil && selection == ironFist), ironFist: ironFist)
                            .onTapGesture {
                                selection = selection == ironFist ? nil : ironFist
                            }
                    }
                }
                .sheet(isPresented: $showingSettings, content: { SettingsView() })
                .listStyle(.automatic)
                .navigationTitle("Iron Fist")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    startStopToolbarItem
                    settingsToolbarItem
                }
            }
            TimerView()
        }
        .navigationViewStyle(.stack)
#if !targetEnvironment(macCatalyst)
        .dynamicTypeSize(.medium ... .accessibility3)
#endif
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
                //                    .previewInterfaceOrientation(.landscapeLeft)
            } else {
                // Fallback on earlier versions
            }
            // https://swiftwithmajid.com/2021/03/10/mastering-swiftui-previews/
            ContentView()
                .environmentObject(controller)
                .environmentObject(settingsController)
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .extraSmall)
        }
    }
}
#endif
