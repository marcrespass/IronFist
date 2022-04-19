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
#if targetEnvironment(macCatalyst)
    struct StackNavigationView<Content: View>: View {
        @ViewBuilder let content: () -> Content

        var body: some View {
            VStack(spacing: 0, content: content)
        }
    }
#else
    struct StackNavigationView<Content: View>: View {
        @ViewBuilder let content: () -> Content

        var body: some View {
            NavigationView(content: content)
                .navigationViewStyle(.stack)
        }
    }
#endif

    var body: some View {
        StackNavigationView {
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
//                .listStyle(.automatic)
                .navigationTitle("Iron Fist")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    startStopToolbarItem
                    settingsToolbarItem
                }
            }
//            TimerView()
        } // https://swiftwithmajid.com/2021/11/03/managing-safe-area-in-swiftui/
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
            Color.clear
                .frame(height: 0)
                .background(Material.bar)
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
// https://swiftwithmajid.com/2021/03/10/mastering-swiftui-previews/
// https://www.swiftjectivec.com/design-ios-apps-using-minimum-middle-maxiumum-environments/
extension PreviewDevice: Hashable { }

struct ContentView_Previews: PreviewProvider {
    static var controller = IronFistController()
    static var settingsController = SettingsController()

    static let sizes: [ContentSizeCategory] = [.extraSmall, .large, .accessibilityExtraExtraExtraLarge]
    static let mmmDesigns: [PreviewDevice] = [.init(stringLiteral: "iPhone 13 Mini"),
                                              .init(stringLiteral: "iPhone 13"),
                                              .init(stringLiteral: "iPhone 13 Pro Max")]

    static var previews: some View {
        ForEach(mmmDesigns, id: \.self) { deviceName in
            ForEach(sizes, id: \.self) { contentSize in
                ContentView()
                    .environmentObject(controller)
                    .environmentObject(settingsController)
                    .environment(\.locale, .init(identifier: "es"))
                    .environment(\.sizeCategory, contentSize)
                    .previewDevice(deviceName)
                    .previewDisplayName("\(deviceName.rawValue)-\(contentSize)")
            }
        }
    }
}

#endif
