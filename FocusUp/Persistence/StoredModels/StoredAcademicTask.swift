//
//  StoredAcademicTask.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 11/9/2026.
//

// This is the storage representation of the model AcademicTask.
// As final class is required by swiftData, this file is created to not alter domain architecture

import Foundation
import SwiftData

@Model
final class StoredAcademicTask {
    var id: UUID
    var taskTitle: String
    var taskSubjectName: String
    var taskDeadline: Date
    var taskPriority: String // taskPriority is a string now to save raw value
    var isTaskCompleted: Bool
    
    init(
        id: UUID,
        taskTitle: String,
        taskSubjectName: String,
        taskDeadline: Date,
        taskPriority: String,
        isTaskCompleted: Bool
    ) {
        self.id = id
        self.taskTitle = taskTitle
        self.taskSubjectName = taskSubjectName
        self.taskDeadline = taskDeadline
        self.taskPriority = taskPriority
        self.isTaskCompleted = isTaskCompleted
    }
}
