//
//  SwiftDataAcademicTaskRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataAcademicTaskRepository: AcademicTaskRepository {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    convenience init(){
        self.init(context: PersistenceController.shared.context)
    }
    
    func saveTask(_ task: AcademicTask) throws {
        
        let storedTask = StoredAcademicTask(
            id: task.id,
            taskTitle: task.taskTitle,
            taskSubjectName: task.taskSubjectName,
            taskDeadline: task.taskDeadline,
            taskPriority: task.taskPriority.rawValue,
            estimatedStudyMinutes: task.estimatedStudyMinutes,
            completedStudyMinutes: task.completedStudyMinutes,
            isTaskCompleted: task.isTaskCompleted
        )
        
        context.insert(storedTask)
        
        try context.save()
    }
    
    func fetchTasks() throws -> [AcademicTask] {

        let descriptor = FetchDescriptor<StoredAcademicTask>(
            sortBy: [
                SortDescriptor(\.taskDeadline)
            ]
        )

        let storedTasks = try context.fetch(descriptor)

        return storedTasks.compactMap { storedTask in

            guard let priority =
                TaskPriority(rawValue: storedTask.taskPriority)
            else {
                return nil
            }

            return AcademicTask(
                id: storedTask.id,
                taskTitle: storedTask.taskTitle,
                taskSubjectName: storedTask.taskSubjectName,
                taskDeadline: storedTask.taskDeadline,
                taskPriority: priority,
                estimatedStudyMinutes: storedTask.estimatedStudyMinutes,
                completedStudyMinutes: storedTask.completedStudyMinutes,
                isTaskCompleted: storedTask.isTaskCompleted
            )
        }
    }
    
    func fetchIncompleteTasks() throws -> [AcademicTask] {
        let descriptor = FetchDescriptor<StoredAcademicTask>(
            predicate: #Predicate<StoredAcademicTask> { task in
                task.isTaskCompleted == false
            },
            sortBy: [
                SortDescriptor(\.taskDeadline)
            ]
        )

        let storedTasks = try context.fetch(descriptor)

        return storedTasks.compactMap { storedTask in
            guard let priority = TaskPriority(
                rawValue: storedTask.taskPriority
            ) else {
                return nil
            }

            return AcademicTask(
                id: storedTask.id,
                taskTitle: storedTask.taskTitle,
                taskSubjectName: storedTask.taskSubjectName,
                taskDeadline: storedTask.taskDeadline,
                taskPriority: priority,
                estimatedStudyMinutes: storedTask.estimatedStudyMinutes,
                completedStudyMinutes: storedTask.completedStudyMinutes,
                isTaskCompleted: storedTask.isTaskCompleted
            )
        }
    }
    
    func deleteTask(_ task: AcademicTask) throws {
        
        let taskID = task.id
        
        let descriptor = FetchDescriptor<StoredAcademicTask>(
            predicate: #Predicate {
                $0.id == taskID
            }
        )
        
        guard let storedTask = try context.fetch(descriptor).first else { return }
        
        context.delete(storedTask)
        
        try context.save()
    }
    
    func updateTask(_ task: AcademicTask) throws {

        let taskID = task.id

        let descriptor = FetchDescriptor<StoredAcademicTask>(
            predicate: #Predicate {
                $0.id == taskID
            }
        )

        guard let storedTask = try context.fetch(descriptor).first else {
            return
        }

        storedTask.taskTitle = task.taskTitle
        storedTask.taskSubjectName = task.taskSubjectName
        storedTask.taskDeadline = task.taskDeadline
        storedTask.taskPriority = task.taskPriority.rawValue
        storedTask.estimatedStudyMinutes = task.estimatedStudyMinutes
        storedTask.completedStudyMinutes = task.completedStudyMinutes
        storedTask.isTaskCompleted = task.isTaskCompleted

        try context.save()
    }
    
}
