//
//  StudyAvailabilityRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

@MainActor
protocol StudyAvailabilityRepository {
    func fetchWeeklyAvailability() throws -> [StudyAvailability]
    func saveAvailability(_ availability: StudyAvailability) throws
    func updateAvailability(_ availability: StudyAvailability) throws
}
