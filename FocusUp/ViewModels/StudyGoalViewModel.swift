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
    
    private let createStudyGoalUseCase = CreateStudyGoalUseCase()
    
    func addGoal() -> Bool {
        do {
            let newGoal = try createStudyGoalUseCase.execute(
                goalTitle: goalTitle,
                goalTargetMinutes: goalTargetMinutes,
                goalDeadline: goalDeadline
            )
            
            goals.append(newGoal)
            clearForm()
            
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func addStudyMinutes(_ minutes: Int) {
        guard !goals.isEmpty else { return }
        
        goals[0].goalCompletedMinutes += minutes
    }
    
    private func clearForm() {
        goalTitle = ""
        goalTargetMinutes = 60
        goalDeadline = Date()
    }
    
    init() {
        let sampleGoals: [StudyGoal] = [
            StudyGoal(
                goalTitle: "Keep Studies Up",
                goalTargetMinutes: 60,
                goalDeadline: Date(),
                goalCompletedMinutes: 30
            ),
            StudyGoal(
                goalTitle: "Weekly Study",
                goalTargetMinutes: 360,
                goalDeadline: Date(),
                goalCompletedMinutes: 0
            )
        ]
        
        self.goals = sampleGoals
    }
}

