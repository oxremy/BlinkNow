//
//  BlinkNowApp.swift
//  BlinkNow
//
//  Created by oxremy on 2/12/25.
//

import SwiftUI

@main
struct BlinkNowApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
