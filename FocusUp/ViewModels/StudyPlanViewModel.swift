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
    
    private let persistenceController = PersistenceController.shared
    private let createAcademicTaskUseCase = CreateAcademicTaskUseCase()
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        do {
            tasks = try persistenceController.fetchTasks()
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
                taskPriority: taskPriority
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
            try persistenceController.updateTask(updatedTask)
            
            loadTasks()
            
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteTask(_ task: AcademicTask) {
        do {
            try persistenceController.deleteTask(task)
            
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
    }
}
