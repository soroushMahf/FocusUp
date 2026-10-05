//
//  MockAcademicTaskRepository.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation
@testable import FocusUp

final class MockAcademicTaskRepository: AcademicTaskRepository {
    
    var tasks: [AcademicTask] = []
    private(set) var incompleteTaskQueryCount = 0
    
    func saveTask(_ task: AcademicTask) throws {
        tasks.append(task)
    }
    
    func fetchTasks() throws -> [AcademicTask] {
        tasks
    }

    func fetchIncompleteTasks() throws -> [AcademicTask] {
        incompleteTaskQueryCount += 1

        return tasks.filter { !$0.isTaskCompleted }
    }
    
    func updateTask(_ task: AcademicTask) throws {
        guard let index = tasks.firstIndex(
            where: { $0.id == task.id }
        ) else {
            return
        }
        
        tasks[index] = task
    }
    
    func deleteTask(_ task: AcademicTask) throws {
        tasks.removeAll {
            $0.id == task.id
        }
    }
}
