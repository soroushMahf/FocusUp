//
//  SwiftDataAcademicTaskRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

@MainActor
final class SwiftDataAcademicTaskRepository: AcademicTaskRepository {
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    init(){
        self.persistenceController = PersistenceController.shared
    }
    
    func saveTask(_ task: AcademicTask) throws {
        try persistenceController.saveTask(task)
    }
    
    func fetchTasks() throws -> [AcademicTask] {
        try persistenceController.fetchTasks()
    }
    
    func fetchIncompleteTasks() throws -> [AcademicTask] {
        try persistenceController.fetchIncompleteTasks()
    }
    
    func updateTask(_ task: AcademicTask) throws {
        try persistenceController.updateTask(task)
    }
    
    func deleteTask(_ task: AcademicTask) throws {
        try persistenceController.deleteTask(task)
    }
    
}
