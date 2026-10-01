//
//  StoredStudyAvailability.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation
import SwiftData

@Model
final class StoredStudyAvailability {
    
    var id: UUID
    var weekday: String
    var availableStudyMinutes: Int

    init(
        id: UUID,
        weekday: String,
        availableStudyMinutes: Int

    ) {
        self.id = id
        self.weekday = weekday
        self.availableStudyMinutes = availableStudyMinutes
    }
}
