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
    
    var title = ""
    var subjectName = ""
    var deadline = Date()
    var taskPriority: TaskPriority = .medium
    
    var errorMessage: String?
    
    private let createAcademicTaskUseCase = CreateAcademicTaskUseCase()
    
    // returning a bool so that the new task sheet can be dismissed only if the task is added successfully
    func addTask() -> Bool {
        do {
            let newTask = try createAcademicTaskUseCase.execute(
                title: title,
                subjectName: subjectName,
                deadline: deadline,
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
        title = ""
        subjectName = ""
        deadline = Date()
        taskPriority = .medium
    }
    
    init() {
        let sampleTasks: [AcademicTask] = [
            AcademicTask(
                title: "Study for the exam",
                subjectName: "Math",
                deadline: Date(),
                taskPriority: .high
            ),
            AcademicTask(
                title: "Complete Assignment",
                subjectName: "Science",
                deadline: Date(),
                taskPriority: .low
            )
        ]
        
        self.tasks = sampleTasks
    }
}
