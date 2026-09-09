//
//  StudySession.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import Foundation

struct StudySession: Identifiable {
    let id: UUID = UUID()
    let focusMinutes: Int
    let breakMinutes: Int
    let startedAt: Date
    var completedAt: Date?
    
    var isCompleted: Bool {
        completedAt != nil
    }
}

enum StudySessionPhase: Equatable {
    case firstHalfFocus
    case breakTime
    case secondHalfFocus
    case completed
}
