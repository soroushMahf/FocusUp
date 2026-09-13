//
//  CreateStudyGoalUseCaseTests.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 13/9/2026.
//

import Testing
@testable import FocusUp
import Foundation

@MainActor
struct CreateStudyGoalUseCaseTests {

    let persistenceController: PersistenceController
    let useCase: CreateStudyGoalUseCase
    
    let currentDate = Date()
    let futureDeadline = Date().addingTimeInterval(60 * 60 * 24 * 7) // making the deadline one week later
    
    init() {
        persistenceController = PersistenceController(inMemory: true)
        useCase = CreateStudyGoalUseCase(
            persistenceController: persistenceController
        )
    }
    
    @Test("Study goal is created when all required details are valid")
    func valudStudyGoalIsCreated() throws {
        let goal = try useCase.execute(
            goalTitle: "Study 10 Hours This Week",
            goalTargetMinutes: 600,
            goalDeadline: futureDeadline,
            currentDate: currentDate
        )
        
        #expect(goal.goalTitle == "Study 10 Hours This Week")
        #expect(goal.goalTargetMinutes == 600)
        #expect(goal.goalDeadline == futureDeadline)
        #expect(goal.goalCompletedMinutes == 0)
    }

    @Test("Study goal fails when the goal title is empty")
    func emptyGoalTitleFails() {
        #expect(throws: StudyGoalError.missingTitle) {
            try useCase.execute(
                goalTitle: "",
                goalTargetMinutes: 600,
                goalDeadline: futureDeadline,
                currentDate: currentDate
            )
        }
    }
    
    @Test("Study goal fails when the target duration is zero minutes")
    func zeroTargetDurationFails() {
        #expect(throws: StudyGoalError.invalidTargetDuration) {
            try useCase.execute(
                goalTitle: "Study 10 Hours This Week",
                goalTargetMinutes: 0,
                goalDeadline: futureDeadline,
                currentDate: currentDate
            )
        }
    }
    
    @Test("Study goal fails when the deadline is in the past")
    func goal_deadlineIsInPastFails() {
        let pastDeadline = currentDate.addingTimeInterval(-(60 * 60 * 24))
        
        #expect(throws: StudyGoalError.deadlineInPast) {
            try useCase.execute(
                goalTitle: "Study 10 Hours This Week",
                goalTargetMinutes: 600,
                goalDeadline: pastDeadline,
                currentDate: currentDate
            )
        }
    }
    
    @Test("Study goal fails when the deadline is equal to the current date")
    func goal_deadlineEqualToCurrentDateFails() {
        #expect(throws: StudyGoalError.deadlineInPast) {
            try useCase.execute(
                goalTitle: "Study 10 Hours This Week",
                goalTargetMinutes: 600,
                goalDeadline: currentDate,
                currentDate: currentDate
            )
        }
    }
}
