//
//  MockStudyAvailabilityRepository.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation
@testable import FocusUp

@MainActor
final class MockStudyAvailabilityRepository: StudyAvailabilityRepository {

    var availability: [StudyAvailability] = []

    func saveAvailability(_ studyAvailability: StudyAvailability) throws {
        availability.append(studyAvailability)
    }

    func fetchWeeklyAvailability() throws -> [StudyAvailability] {
        return availability
    }

    func updateAvailability(_ studyAvailability: StudyAvailability) throws {
        guard let index = availability.firstIndex(
            where: { $0.id == studyAvailability.id }
        ) else {
            return
        }

        availability[index] = studyAvailability
    }

    func deleteAvailability(_ studyAvailability: StudyAvailability) throws {
        availability.removeAll {
            $0.id == studyAvailability.id
        }
    }
}
