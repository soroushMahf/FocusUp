//
//  CreateAcademicTaskUseCase.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

// Creates a new academic task after validating the student's input
// Addresses all the errors that can occur as outlined within AcademicTaskError

import Foundation

struct CreateAcademicTaskUseCase {
    
    func execute(
        title: String,
        subjectName: String,
        deadline: Date,
        taskPriority: TaskPriority,
        currentDate: Date = Date()
    ) throws -> AcademicTask {
        
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let cleanedSubject = subjectName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedTitle.isEmpty else {
            throw AcademicTaskError.missingTitle
        }
        
        guard !cleanedSubject.isEmpty else {
            throw AcademicTaskError.missingSubject
        }
        
        guard deadline > currentDate else {
            throw AcademicTaskError.deadlineInPast
        }
        
        return AcademicTask(
            title: cleanedTitle,
            subjectName: cleanedSubject,
            deadline: deadline,
            taskPriority: taskPriority
        )
    }
}
