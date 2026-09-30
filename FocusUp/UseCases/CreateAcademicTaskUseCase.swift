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
    
    private let repository: AcademicTaskRepository
    
    init(repository: AcademicTaskRepository) {
        self.repository = repository
    }
    
    @MainActor
    init() {
        self.repository = SwiftDataAcademicTaskRepository()
    }
    
    func execute(
        taskTitle: String,
        taskSubjectName: String,
        taskDeadline: Date,
        taskPriority: TaskPriority,
        estimatedStudyMinutes: Int,
        currentDate: Date = Date()
    ) throws -> AcademicTask {
        
        let cleanedTaskTitle = taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let cleanedTaskSubject = taskSubjectName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedTaskTitle.isEmpty else {
            throw AcademicTaskError.missingTitle
        }
        
        guard !cleanedTaskSubject.isEmpty else {
            throw AcademicTaskError.missingSubject
        }
        
        guard taskDeadline > currentDate else {
            throw AcademicTaskError.deadlineInPast
        }
        
        guard estimatedStudyMinutes > 0 else {
            throw AcademicTaskError.invalidEstimatedStudy
        }
        
        let newTask = AcademicTask(
            taskTitle: cleanedTaskTitle,
            taskSubjectName: cleanedTaskSubject,
            taskDeadline: taskDeadline,
            taskPriority: taskPriority,
            estimatedStudyMinutes: estimatedStudyMinutes
        )
        
        try repository.saveTask(newTask)
        
        return newTask
    }
}
