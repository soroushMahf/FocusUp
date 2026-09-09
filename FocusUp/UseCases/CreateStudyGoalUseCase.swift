//
//  CreateStudyGoalUseCase.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

// Creates a new study goal after validating the student's input
// Addresses all the errors that can occur as outlined within StudyGoalError

import Foundation

struct CreateStudyGoalUseCase {
    
    func execute(
        title: String,
        targetMinutes: Int,
        deadline: Date,
        currentDate: Date = Date()
    ) throws -> StudyGoal {
        
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedTitle.isEmpty else {
            throw StudyGoalError.missingTitle
        }
        
        guard targetMinutes > 0 else {
            throw StudyGoalError.invalidTargetDuration
        }
        
        guard deadline > currentDate else {
            throw StudyGoalError.deadlineInPast
        }
        
        return StudyGoal (
            title: cleanedTitle,
            targetMinutes: targetMinutes,
            deadline: deadline
        )
    }
}
