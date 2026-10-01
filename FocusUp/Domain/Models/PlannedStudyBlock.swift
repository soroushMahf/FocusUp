//
//  PlannedStudyBlock.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

struct PlannedStudyBlock: Identifiable {
    let id: UUID
    let academicTaskID: UUID
    var scheduledDate: Date
    var plannedStudyMinutes: Int
    var isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        academicTaskID: UUID,
        scheduledDate: Date,
        plannedStudyMinutes: Int,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.academicTaskID = academicTaskID
        self.scheduledDate = scheduledDate
        self.plannedStudyMinutes = plannedStudyMinutes
        self.isCompleted = isCompleted
    }
}
