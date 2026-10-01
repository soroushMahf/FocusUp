//
//  ManageStudyAvailabilityUseCaseTests.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

// For each test, a new instance of repository is
// provided so each test starts with a completely empty repository

import Testing
@testable import FocusUp

@MainActor
struct ManageStudyAvailabilityUseCaseTests {
    @Test("A new study availability is created for a weekday")
    func newStudyAvailabilityIsCreated() throws {
        let repository = MockStudyAvailabilityRepository()
        let useCase = ManageStudyAvailabilityUseCase(
            repository: repository
        )
    
        try useCase.execute(
            weekday: .monday,
            availableStudyMinutes: 120
        )

        #expect(repository.availability.count == 1)
        #expect(repository.availability.first?.weekday == .monday)
        #expect(repository.availability.first?.availableStudyMinutes == 120)
    }

    @Test("Existing study availability is updated and not duplicated")
    func existingStudyAvailabilityIsUpdated() throws {

            let repository = MockStudyAvailabilityRepository()
        
            repository.availability = [
                StudyAvailability(
                    weekday: .monday,
                    availableStudyMinutes: 120
                )
            ]

            let useCase = ManageStudyAvailabilityUseCase(
                repository: repository
            )

            try useCase.execute(
                weekday: .monday,
                availableStudyMinutes: 180
            )

            #expect(repository.availability.count == 1)
            #expect(repository.availability.first?.availableStudyMinutes == 180)
    }


    @Test("Zero study availability is accepted for an unavailable day")
    func zeroStudyAvailabilityIsAccepted() throws {
        let repository = MockStudyAvailabilityRepository()
        let useCase = ManageStudyAvailabilityUseCase(
            repository: repository
        )
        
        try useCase.execute(
            weekday: .wednesday,
            availableStudyMinutes: 0
        )

        #expect(repository.availability.count == 1)
        #expect(repository.availability.first?.availableStudyMinutes == 0)
    }

    @Test("Negative study availability is rejected")
    func negativeStudyAvailabilityFails() {
        let repository = MockStudyAvailabilityRepository()
        let useCase = ManageStudyAvailabilityUseCase(
            repository: repository
        )
        #expect(throws: StudyAvailabilityError.negativeStudyTime) {

            try useCase.execute(
                weekday: .monday,
                availableStudyMinutes: -30
            )
        }
    }

    @Test("Study availability above twelve hours is rejected")
    func studyAvailabilityAboveDailyLimitFails() {
        let repository = MockStudyAvailabilityRepository()
        let useCase = ManageStudyAvailabilityUseCase(
            repository: repository
        )
        #expect(throws: StudyAvailabilityError.exceedsDailyLimit) {
            try useCase.execute(
                weekday: .monday,
                availableStudyMinutes: 750
            )
        }
    }
}
