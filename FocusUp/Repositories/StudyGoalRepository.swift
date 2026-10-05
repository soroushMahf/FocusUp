//
//  StudyGoalRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 5/10/2026.
//

import Foundation

@MainActor
protocol StudyGoalRepository {
    func saveGoal(_ goal: StudyGoal) throws
    func fetchGoals() throws -> [StudyGoal]
    func updateGoal(_ goal: StudyGoal) throws
    func deleteGoal(_ goal: StudyGoal) throws
}
