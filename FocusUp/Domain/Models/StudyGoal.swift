//
//  StudyGoal.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import Foundation

struct StudyGoal: Identifiable, Hashable {
    let id: UUID
    let goalTitle: String
    let goalTargetMinutes: Int
    let goalDeadline: Date
    var goalCompletedMinutes: Int = 0
    
    init(
        id: UUID = UUID(),
        goalTitle: String,
        goalTargetMinutes: Int,
        goalDeadline: Date,
        goalCompletedMinutes: Int = 0
    ) {
        self.id = id
        self.goalTitle = goalTitle
        self.goalTargetMinutes = goalTargetMinutes
        self.goalDeadline = goalDeadline
        self.goalCompletedMinutes = goalCompletedMinutes
    }
    
    // computed property for progress
    var progress: Double {
        guard goalTargetMinutes > 0 else { return 0 }
        return min(
            Double(goalCompletedMinutes) / Double(goalTargetMinutes),
            1.0 // capping the progress at 100%s
        )
    }
}
