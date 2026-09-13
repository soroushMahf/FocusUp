//
//  StudySessionError.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import Foundation

enum StudySessionError: LocalizedError, Equatable {
    case invalidFocusDuration
    case breakRequired
    case invalidBreakDuration
    
    var errorDescription: String? {
        switch self {
        case .invalidFocusDuration:
            return "Focus Sessions must be between 10 and 240 minutes long"
            
        case .breakRequired:
            return "Focus Sessions 60 minutes or longer require a break"
            
        case .invalidBreakDuration:
            return "Choose a break duration between 0 and 30 minutes"
        }
    }
}
