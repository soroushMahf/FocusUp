//
//  StoredStudentProgress.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 11/9/2026.
//

import Foundation
import SwiftData

@Model
final class StoredStudentProgress {

    var totalStudyMinutes: Int
    var completedSessions: Int

    init(
        totalStudyMinutes: Int = 0,
        completedSessions: Int = 0
    ) {
        self.totalStudyMinutes = totalStudyMinutes
        self.completedSessions = completedSessions
    }
}
