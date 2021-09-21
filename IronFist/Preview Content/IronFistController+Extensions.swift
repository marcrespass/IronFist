//
//  PreviewProviders.swift
//  IronFist
//
//  Created by Marc Respass on 7/28/21.
//

// https://www.avanderlee.com/xcode/development-assets-preview-catalog/

import SwiftUI
import IronFistKit

extension IronFistController {
    public var ironFistSample: IronFist {
        guard let sample = self.ironFists.first else { fatalError("There must be one but there isn't") }
        return sample
    }

    public static var readyController: IronFistController {
        let controller = IronFistController()
        controller.readyTimer()
        UserDefaults.standard.set(5, forKey: UserDefaults.Keys.kFistTime)
        UserDefaults.standard.set(3, forKey: UserDefaults.Keys.kRestTime)
        UserDefaults.standard.set(3, forKey: UserDefaults.Keys.kRepetition)

        return controller
    }
}
