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
    
    private let notificationService = StudyNotificationService()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .task { // for notifications
                    notificationService.registerStudyReminderCategory()
                    await notificationService.requestPermission()
                }
        }
        .modelContainer(
            persistenceController.container
        )
    }
}
