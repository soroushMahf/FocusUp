//
//  StoredPlannedStudyBlock.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation
import SwiftData

@Model
final class StoredPlannedStudyBlock {
    
    var id: UUID
    var academicTaskID: UUID
    var scheduledDate: Date
    var plannedStudyMinutes: Int
    var isCompleted: Bool
    
    init(
        id: UUID,
        academicTaskID: UUID,
        scheduledDate: Date,
        plannedStudyMinutes: Int,
        isCompleted: Bool
    ) {
        self.id = id
        self.academicTaskID = academicTaskID
        self.scheduledDate = scheduledDate
        self.plannedStudyMinutes = plannedStudyMinutes
        self.isCompleted = isCompleted
    }
}
