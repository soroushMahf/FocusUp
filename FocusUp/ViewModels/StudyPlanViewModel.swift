//
//  StudyPlanViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

// The viewmodel does not decide whether the task is valid as Use Case owns the logic

import Foundation

@Observable
final class StudyPlanViewModel {
    
    var tasks: [AcademicTask] = []
    
    var taskTitle = ""
    var taskSubjectName = ""
    var taskDeadline = Date()
    var taskPriority: TaskPriority = .medium
    
    var errorMessage: String?
    
    private let createAcademicTaskUseCase = CreateAcademicTaskUseCase()
    
    // returning a bool so that the new task sheet can be dismissed only if the task is added successfully
    func addTask() -> Bool {
        do {
            let newTask = try createAcademicTaskUseCase.execute(
                taskTitle: taskTitle,
                taskSubjectName: taskSubjectName,
                taskDeadline: taskDeadline,
                taskPriority: taskPriority
            )
            
            tasks.append(newTask)
            clearForm()
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    private func clearForm() {
        taskTitle = ""
        taskSubjectName = ""
        taskDeadline = Date()
        taskPriority = .medium
    }
    
    init() {
        let sampleTasks: [AcademicTask] = [
            AcademicTask(
                taskTitle: "Study for the exam",
                taskSubjectName: "Math",
                taskDeadline: Date(),
                taskPriority: .high
            ),
            AcademicTask(
                taskTitle: "Complete Assignment",
                taskSubjectName: "Science",
                taskDeadline: Date(),
                taskPriority: .low
            )
        ]
        
        self.tasks = sampleTasks
    }
}
