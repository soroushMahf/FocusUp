//
//  AcademicTaskError.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import Foundation

enum AcademicTaskError: LocalizedError {
    case missingTitle
    case deadlineInPast
    case missingSubject
    
    var errorDescription: String? {
        switch self {
        case .missingTitle:
            return "Enter a name for your academic task."
            
        case .deadlineInPast:
            return "The deadline is already passed. Choose an upcoming date."
            
        case .missingSubject:
            return "Enter the subject this task belongs to."
        }
    }
}
