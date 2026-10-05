//
//  SwiftDataStudyGoalRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 5/10/2026.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataStudyGoalRepository: StudyGoalRepository {
    
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

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
}
