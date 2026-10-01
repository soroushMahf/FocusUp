//
//  StudyAvailabilityError.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

enum StudyAvailabilityError: LocalizedError, Equatable {
    case negativeStudyTime
    case exceedsDailyLimit
    
    var errorDescription: String? {
        switch self {
        case .negativeStudyTime:
            return "Study availability cannot be less than 0 minutes"
            
        case .exceedsDailyLimit:
            return "Study availability cannot exceed 12 hours per day"
        }
    }
}
