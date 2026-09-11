//
//  AcademicTask.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import Foundation
import SwiftUI

struct AcademicTask: Identifiable, Hashable {
    let id: UUID
    let taskTitle: String
    let taskSubjectName: String
    let taskDeadline: Date
    let taskPriority: TaskPriority
    var isTaskCompleted: Bool
    
    init(
        id: UUID = UUID(),
        taskTitle: String,
        taskSubjectName: String,
        taskDeadline: Date,
        taskPriority: TaskPriority,
        isTaskCompleted: Bool = false
    ) {
        self.id = id
        self.taskTitle = taskTitle
        self.taskSubjectName = taskSubjectName
        self.taskDeadline = taskDeadline
        self.taskPriority = taskPriority
        self.isTaskCompleted = isTaskCompleted
    }
}

enum TaskPriority: String, CaseIterable, Hashable {
    case low = "Low Priority"
    case medium = "Medium Priority"
    case high = "High Priority"
    
    var color: Color {
        switch self {
        case .low:
            Color.green
        case.medium:
            Color.orange
        case .high:
            Color.red
        }
    }
}
