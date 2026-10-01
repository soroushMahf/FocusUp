//
//  ManageStudyAvailabilityUseCase.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

@MainActor
struct ManageStudyAvailabilityUseCase {
    
    private let repository: StudyAvailabilityRepository
    
    init(repository: StudyAvailabilityRepository) {
        self.repository = repository
    }
    
    func execute(weekday: Weekday, availableStudyMinutes: Int) throws {
        
        // first validating input
        guard availableStudyMinutes >= 0 else {
            throw StudyAvailabilityError.negativeStudyTime
        }
        
        guard availableStudyMinutes <= 720 else {
            throw StudyAvailabilityError.exceedsDailyLimit
        }
        
        // assess whether weekday already exists
        let weeklyAvailability = try repository.fetchWeeklyAvailability()
        
        // if availability exists (if monday exists) update it
        if let existingAvailability = weeklyAvailability.first(
            where: { $0.weekday == weekday }
        ) {
            
            var updatedAvailability = existingAvailability
            updatedAvailability.availableStudyMinutes = availableStudyMinutes
            
            try repository.updateAvailability(updatedAvailability)
        
        // else create a new availability
        } else {
            let newAvailability = StudyAvailability (weekday: weekday, availableStudyMinutes: availableStudyMinutes)
            
            try repository.saveAvailability(newAvailability)
        }
    }
}
