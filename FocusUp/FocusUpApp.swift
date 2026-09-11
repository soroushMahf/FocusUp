//
//  FocusUpApp.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI
import SwiftData

@main
struct FocusUpApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(
            persistenceController.container
        )
    }
}
