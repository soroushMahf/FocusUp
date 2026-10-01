//
//  StudyAvailabilityViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import Foundation

@Observable
@MainActor
final class StudyAvailabilityViewModel {
    
    var weeklyAvailability: [StudyAvailability] = []
    var errorMessage: String?
    
    private let repository: StudyAvailabilityRepository
    private let manageStudyAvailabilityUseCase: ManageStudyAvailabilityUseCase
    
    init(repository: StudyAvailabilityRepository) {
        self.repository = repository
        self.manageStudyAvailabilityUseCase = ManageStudyAvailabilityUseCase(repository: repository)
        
        loadAvailability()
    }
    
    func loadAvailability() {
        do {
            weeklyAvailability = try repository.fetchWeeklyAvailability()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func availability(for weekday: Weekday) -> Int {
        weeklyAvailability.first {
            $0.weekday == weekday
        }?.availableStudyMinutes ?? 0
    }
    
    func setAvailability(for weekday: Weekday, minutes: Int) {
        do {
            try manageStudyAvailabilityUseCase.execute(
                weekday: weekday,
                availableStudyMinutes: minutes
            )
            
            loadAvailability()
            errorMessage = nil
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
