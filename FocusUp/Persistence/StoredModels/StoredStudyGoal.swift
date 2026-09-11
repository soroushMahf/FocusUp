//
//  StoredStudyGoal.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 11/9/2026.
//

// This is the storage representation of the model StudyGoal.
// As final class is required by swiftData, this file is created to not alter domain architecture

import Foundation
import SwiftData

@Model
final class StoredStudyGoal {

    var id: UUID
    var goalTitle: String
    var goalTargetMinutes: Int
    var goalDeadline: Date
    var goalCompletedMinutes: Int

    init(
        id: UUID,
        goalTitle: String,
        goalTargetMinutes: Int,
        goalDeadline: Date,
        goalCompletedMinutes: Int
    ) {
        self.id = id
        self.goalTitle = goalTitle
        self.goalTargetMinutes = goalTargetMinutes
        self.goalDeadline = goalDeadline
        self.goalCompletedMinutes = goalCompletedMinutes
    }
}
