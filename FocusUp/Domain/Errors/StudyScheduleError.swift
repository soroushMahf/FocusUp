//
//  StudyScheduleError.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import Foundation

enum StudyScheduleError: LocalizedError, Equatable {
    
    case noIncompleteTasks
    case noStudyAvailability
    case insufficientStudyAvailability
    
    var errorDescription: String? {
        switch self {
        case .noIncompleteTasks:
            return "There are no incomplete academic tasks to schedule."
            
        case .noStudyAvailability:
            return "Add some weekly study availability before generating your study plan."
            
        case .insufficientStudyAvailability:
            return "There is not enough study availability to complete all tasks before their deadlines. Try increasing your availability or adjusting your tasks."
        }
    }
}
