//
//  PersistenceController.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 11/9/2026.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: ModelContainer
    
    var context: ModelContext {
        container.mainContext
    }
    
    private init() {
        do {
            container = try ModelContainer(
                for:
                    StoredAcademicTask.self,
                    StoredStudyGoal.self,
                    StoredStudentProgress.self
            )
        } catch {
            fatalError(
                "Unable to initialise FocusUp data storage: \(error)"
            )
        }
    }
    
    // MARK: - functions for Academic Task
    
    func saveTask(_ task: AcademicTask) throws {
        
        let storedTask = StoredAcademicTask(
            id: task.id,
            taskTitle: task.taskTitle,
            taskSubjectName: task.taskSubjectName,
            taskDeadline: task.taskDeadline,
            taskPriority: task.taskPriority.rawValue,
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
        storedTask.isTaskCompleted = task.isTaskCompleted

        try context.save()
    }
    
    // MARK: - functions for Study Goal
    
    func saveGoal(_ goal: StudyGoal) throws {
        let storedGoal = StoredStudyGoal(
            id: goal.id,
            goalTitle: goal.goalTitle,
            goalTargetMinutes: goal.goalTargetMinutes,
            goalDeadline: goal.goalDeadline,
            goalCompletedMinutes: goal.goalCompletedMinutes
        )
        
        context.insert(storedGoal)
        
        try context.save()
    }
    
    func fetchGoals() throws -> [StudyGoal] {
        
        let descriptor = FetchDescriptor<StoredStudyGoal>(
            sortBy: [
                SortDescriptor(\.goalDeadline)
            ]
        )
        
        let storedGoals = try context.fetch(descriptor)
        
        return storedGoals.map { storedGoal in
            StudyGoal(
                id: storedGoal.id,
                goalTitle: storedGoal.goalTitle,
                goalTargetMinutes: storedGoal.goalTargetMinutes,
                goalDeadline: storedGoal.goalDeadline,
                goalCompletedMinutes: storedGoal.goalCompletedMinutes
            )
        }
    }
    
    func deleteGoal(_ goal: StudyGoal) throws {

        let goalID = goal.id

        let descriptor = FetchDescriptor<StoredStudyGoal>(
            predicate: #Predicate {
                $0.id == goalID
            }
        )
        guard let storedGoal = try context.fetch(descriptor).first else {
            return
        }

        context.delete(storedGoal)

        try context.save()
    }
    
    func updateGoal(_ goal: StudyGoal) throws {
        
        let goalID = goal.id
        
        let descriptor = FetchDescriptor<StoredStudyGoal>(
            predicate: #Predicate {
                $0.id == goalID
            }
        )
        
        guard let storedGoal = try context.fetch(descriptor).first else { return }
        storedGoal.goalTitle = goal.goalTitle
        storedGoal.goalTargetMinutes = goal.goalTargetMinutes
        storedGoal.goalDeadline = goal.goalDeadline
        storedGoal.goalCompletedMinutes = goal.goalCompletedMinutes
        
        try context.save()
    }
    
    // MARK: - Functions for Student Progress

    func fetchStudentProgress() throws -> StudentProgress {

        let descriptor = FetchDescriptor<StoredStudentProgress>()

        let storedProgress = try context.fetch(descriptor)

        if let progress = storedProgress.first {
            return StudentProgress(
                totalStudyMinutes: progress.totalStudyMinutes,
                completedSessions: progress.completedSessions
            )
        }

        let newProgress = StoredStudentProgress()

        context.insert(newProgress)

        try context.save()

        return StudentProgress()
    }
    
    // if the student already has progress, fetch it, else create new progress
    func updateStudentProgress(_ progress: StudentProgress) throws {
        let descriptor = FetchDescriptor<StoredStudentProgress>()
        
        let storedProgress = try context.fetch(descriptor)
        
        if let existingProgress = storedProgress.first {
            existingProgress.totalStudyMinutes = progress.totalStudyMinutes
            existingProgress.completedSessions = progress.completedSessions
        } else {
            let newProgress = StoredStudentProgress(
                totalStudyMinutes: progress.totalStudyMinutes,
                completedSessions: progress.completedSessions
            )
            context.insert(newProgress)
        }
        
        try context.save()
    }
    
}
