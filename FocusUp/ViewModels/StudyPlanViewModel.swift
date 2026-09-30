//
//  StudyPlanViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

// The viewmodel does not decide whether the task is valid as Use Case owns the logic

import Foundation

@Observable
@MainActor
final class StudyPlanViewModel {
    
    var tasks: [AcademicTask] = []
    
    var taskTitle = ""
    var taskSubjectName = ""
    var taskDeadline = Date()
    var taskPriority: TaskPriority = .medium
    var estimatedStudyMinutes = 240
    
    var errorMessage: String?
    
    private let repository: AcademicTaskRepository
    private let createAcademicTaskUseCase: CreateAcademicTaskUseCase
    
    init(repository: AcademicTaskRepository) {
        self.repository = repository
        self.createAcademicTaskUseCase = CreateAcademicTaskUseCase(repository: repository)
        
        loadTasks()
    }
    
    func loadTasks() {
        do {
            tasks = try repository.fetchTasks()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // returning a bool so that the new task sheet can be dismissed only if the task is added successfully
    func addTask() -> Bool {
        do {
            // as the task is being added through the execute function, it does not need to be appended here
            _ = try createAcademicTaskUseCase.execute(
                taskTitle: taskTitle,
                taskSubjectName: taskSubjectName,
                taskDeadline: taskDeadline,
                taskPriority: taskPriority,
                estimatedStudyMinutes: estimatedStudyMinutes
            )
            
            loadTasks()
            
            clearForm()
            
            errorMessage = nil
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func completeTask(_ task: AcademicTask) {
        var updatedTask = task
        
        updatedTask.isTaskCompleted.toggle()
        
        do {
            try repository.updateTask(updatedTask)
            
            loadTasks()
            
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteTask(_ task: AcademicTask) {
        do {
            try repository.deleteTask(task)
            
            loadTasks()
            
            errorMessage = nil
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func clearForm() {
        taskTitle = ""
        taskSubjectName = ""
        taskDeadline = Date()
        taskPriority = .medium
        estimatedStudyMinutes = 240
    }
    
    var estimatedStudyTimeText: String {
        let hours = estimatedStudyMinutes / 60
        let minutes = estimatedStudyMinutes % 60
        
        if hours == 0 {
            return "\(minutes) min"
        } else {
            return "\(hours) hr \(minutes) min"
        }
    }
}
