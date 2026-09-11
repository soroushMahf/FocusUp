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
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    init() {
        self.persistenceController = .shared
    }
    
    func execute(
        goalTitle: String,
        goalTargetMinutes: Int,
        goalDeadline: Date,
        currentDate: Date = Date()
    ) throws -> StudyGoal {
        
        let cleanedTitle = goalTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedTitle.isEmpty else {
            throw StudyGoalError.missingTitle
        }
        
        guard goalTargetMinutes > 0 else {
            throw StudyGoalError.invalidTargetDuration
        }
        
        guard goalDeadline > currentDate else {
            throw StudyGoalError.deadlineInPast
        }
        
        let newGoal = StudyGoal (
            goalTitle: cleanedTitle,
            goalTargetMinutes: goalTargetMinutes,
            goalDeadline: goalDeadline
        )
        
        try persistenceController.saveGoal(newGoal)
        
        return newGoal
    }
}
