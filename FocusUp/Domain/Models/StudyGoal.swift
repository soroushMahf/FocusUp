//
//  StudyGoal.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import Foundation

struct StudyGoal: Identifiable {
    let id: UUID = UUID()
    let title: String
    let targetMinutes: Int
    let deadline: Date
    var completedMinutes: Int = 0
    
    // computed property for progress
    var progress: Double {
        guard targetMinutes > 0 else { return 0 }
        return min(
            Double(completedMinutes) / Double(targetMinutes),
            1.0 // capping the progress at 100%s
        )
    }
}
