//
//  StartStudySessionUseCaseTests.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 13/9/2026.
//

import Testing
@testable import FocusUp

struct StartStudySessionUseCaseTests {
    
    let useCase = StartStudySessionUseCase()

    @Test("Valid focus and break durations successfully create a study session")
    func validDurationsCreateStudySession() throws {
        let session = try useCase.execute(
            focusMinutes: 45,
            breakMinutes: 10)
        
        #expect(session.focusMinutes == 45)
        #expect(session.breakMinutes == 10)
    }
    
    @Test("Focus session fails when study duration is less than 10 minutes")
    func focusDurationBelowMinimumFails() {
        #expect(throws: StudySessionError.invalidFocusDuration) {
            try useCase.execute(
                focusMinutes: 9,
                breakMinutes: 0
            )
        }
    }
    
    @Test("Study sessions 60-minutes or longer fail when no break is provided")
    func sixtyMinuteSessionWithoutBreakFails() {
        #expect(throws: StudySessionError.breakRequired) {
            try useCase.execute(
                focusMinutes: 60,
                breakMinutes: 0
            )
        }
    }
    
    @Test("Study session fails when break duration exceeds 30 minutes")
    func breakDurationExceedingMaximumFails() {
        #expect(throws: StudySessionError.invalidBreakDuration) {
            try useCase.execute(
                focusMinutes: 30,
                breakMinutes: 31
            )
        }
    }
}
