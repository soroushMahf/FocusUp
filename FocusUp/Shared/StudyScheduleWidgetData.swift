//
//  StudyScheduleWidgetData.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 2/10/2026.
//

// This file is the small representation of schedule
// information that the main app shares with the widget

import Foundation

struct StudyScheduleWidgetData: Codable {
    let taskTitle: String
    let subjectName: String
    let scheduledDate: Date
    let remainingStudyMinutes: Int
}
