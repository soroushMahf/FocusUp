//
//  StudyGoalError.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import Foundation

enum StudyGoalError: LocalizedError {
    case missingTitle
    case invalidTargetDuration
    case deadlineInPast
    
    var errorDescription: String? {
        switch self {
        case .missingTitle:
            return "Enter a name for your study goal."
            
        case .deadlineInPast:
            return "The study goal requires an upcoming deadline. Choose an upcoming date."
            
        case .invalidTargetDuration:
            return "Choose a study target of greater than zero minutes."
        }
    }
}
