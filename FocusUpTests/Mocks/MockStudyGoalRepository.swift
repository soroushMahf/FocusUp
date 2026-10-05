//
//  MockStudyGoalRepository.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 5/10/2026.
//

import Foundation
@testable import FocusUp

@MainActor
final class MockStudyGoalRepository: StudyGoalRepository {
    var goals: [StudyGoal] = []

    func saveGoal(_ goal: StudyGoal) throws {
        goals.append(goal)
    }

    func fetchGoals() throws -> [StudyGoal] {
        goals
    }

    func updateGoal(_ goal: StudyGoal) throws {
        guard let index = goals.firstIndex(
            where: { $0.id == goal.id }
        ) else {
            return
        }

        goals[index] = goal
    }

    func deleteGoal(_ goal: StudyGoal) throws {
        goals.removeAll { $0.id == goal.id }
    }
}
