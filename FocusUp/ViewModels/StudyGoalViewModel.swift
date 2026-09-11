//
//  StudyGoalViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 10/9/2026.
//

import Foundation

@Observable
final class StudyGoalViewModel {
    
    var goals: [StudyGoal] = []
    
    var goalTitle = ""
    var goalTargetMinutes = 60
    var goalDeadline = Date()
    
    var errorMessage: String?
    
    var goalDueSoon: StudyGoal? {
        goals
            .filter { $0.goalDeadline >= Date() }
            .min { $0.goalDeadline < $1.goalDeadline }
    }
    
    private let persistenceController = PersistenceController.shared
    private let createStudyGoalUseCase = CreateStudyGoalUseCase()
    
    init() {
        loadGoals()
    }
    
    func loadGoals() {
        do {
            goals = try persistenceController.fetchGoals()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addGoal() -> Bool {
        do {
            _ = try createStudyGoalUseCase.execute(
                goalTitle: goalTitle,
                goalTargetMinutes: goalTargetMinutes,
                goalDeadline: goalDeadline
            )
            
            loadGoals()
            
            clearForm()
            
            errorMessage = nil
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteGoal(_ goal: StudyGoal) {
        do {
            try persistenceController.deleteGoal(goal)

            loadGoals()

            errorMessage = nil

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addStudyMinutes(_ minutes: Int, to goalID: UUID) {

        guard let goal = goals.first(where: { $0.id == goalID }) else { return }

        var updatedGoal = goal

        updatedGoal.goalCompletedMinutes += minutes

        do {
            try persistenceController.updateGoal(updatedGoal)

            loadGoals()

            errorMessage = nil

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func clearForm() {
        goalTitle = ""
        goalTargetMinutes = 60
        goalDeadline = Date()
    }
}

