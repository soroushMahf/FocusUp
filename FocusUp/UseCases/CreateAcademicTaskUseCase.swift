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
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    init() {
        self.persistenceController = .shared
    }
    
    func execute(
        taskTitle: String,
        taskSubjectName: String,
        taskDeadline: Date,
        taskPriority: TaskPriority,
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
        
        let newTask = AcademicTask(
            taskTitle: cleanedTaskTitle,
            taskSubjectName: cleanedTaskSubject,
            taskDeadline: taskDeadline,
            taskPriority: taskPriority
        )
        
        try persistenceController.saveTask(newTask)
        
        return newTask
    }
}
