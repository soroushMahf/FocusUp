//
//  SwiftDataStudyAvailabilityRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

// SwiftData functions are saved within this repository rather the Persistence like it was originally

import Foundation
import SwiftData

@MainActor
final class SwiftDataStudyAvailabilityRepository: StudyAvailabilityRepository {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func saveAvailability(_ availability: StudyAvailability) throws {
        let storedAvailability = StoredStudyAvailability(
            id: availability.id,
            weekday: availability.weekday.rawValue,
            availableStudyMinutes: availability.availableStudyMinutes
        )
        
        context.insert(storedAvailability)
        
        try context.save()
    }
    
    func fetchWeeklyAvailability() throws -> [StudyAvailability] {
        let descriptor = FetchDescriptor<StoredStudyAvailability>()
        
        let storedAvailability = try context.fetch(descriptor)
        
        return storedAvailability.compactMap { stored in
            guard let weekday = Weekday(rawValue: stored.weekday) else {
                return nil
            }
            
            return StudyAvailability(
                id: stored.id,
                weekday: weekday,
                availableStudyMinutes: stored.availableStudyMinutes
            )
        }
    }
    
    func updateAvailability(_ availability: StudyAvailability) throws {
            let availabilityID = availability.id

            let descriptor = FetchDescriptor<StoredStudyAvailability>(
                predicate: #Predicate {
                    $0.id == availabilityID
                }
            )
        
            guard let storedAvailability = try context.fetch(descriptor).first else {
                return
            }
        
            storedAvailability.weekday = availability.weekday.rawValue
            storedAvailability.availableStudyMinutes = availability.availableStudyMinutes

            try context.save()
        }

        func deleteAvailability(_ availability: StudyAvailability) throws {
            let availabilityID = availability.id
            
            let descriptor = FetchDescriptor<StoredStudyAvailability>(
                predicate: #Predicate {
                    $0.id == availabilityID
                }
            )

            guard let storedAvailability = try context.fetch(descriptor).first else {
                return
            }
    
            context.delete(storedAvailability)

            try context.save()
        }
}
