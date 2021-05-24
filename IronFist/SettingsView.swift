//
//  SettingsView.swift
//  IronFist
//
//  Created by Marc Respass on 5/24/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var fistTime: String
    @State private var restTime: String

    init() {
        let t = UserDefaults.standard.integer(forKey: "FistTime")
        let r = UserDefaults.standard.integer(forKey: "RestTime")

        _fistTime = State(wrappedValue: String(t))
        _restTime = State(wrappedValue: String(r))
    }

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Settings", comment: ""))) {
                TextField("Item name", text: $fistTime)
                TextField("Description", text: $restTime)
            }
            Section {
                Button("Done") { presentationMode.wrappedValue.dismiss() }
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: save)
    }

    func save() {
        if let title = Int(fistTime) {
            UserDefaults.standard.set(title, forKey: "FistTime")
        }
        if let detail = Int(restTime) {
            UserDefaults.standard.set(detail, forKey: "RestTime")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
