//
//  StudyAvailability.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

struct StudyAvailability: Identifiable {
    let id: UUID
    let weekday: Weekday
    var availableStudyMinutes: Int
    
    init(
        id: UUID = UUID(),
        weekday: Weekday,
        availableStudyMinutes: Int
    ) {
        self.id = id
        self.weekday = weekday
        self.availableStudyMinutes = availableStudyMinutes
    }
}

enum Weekday: String, CaseIterable, Codable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}
