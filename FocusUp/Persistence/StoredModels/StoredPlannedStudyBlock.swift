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
    
    @Attribute(.unique)
    var id: UUID
    
    var academicTaskID: UUID
    var scheduledDate: Date
    var plannedStudyMinutes: Int
    var completedStudyMinutes: Int
    
    init(
        id: UUID,
        academicTaskID: UUID,
        scheduledDate: Date,
        plannedStudyMinutes: Int,
        completedStudyMinutes: Int,
    ) {
        self.id = id
        self.academicTaskID = academicTaskID
        self.scheduledDate = scheduledDate
        self.plannedStudyMinutes = plannedStudyMinutes
        self.completedStudyMinutes = completedStudyMinutes
    }
}
