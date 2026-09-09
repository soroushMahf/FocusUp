//
//  StartStudySessionUseCase.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import Foundation

struct StartStudySessionUseCase {
    
    func execute(
        focusMinutes: Int,
        breakMinutes: Int,
        currentDate: Date = Date()
    ) throws -> StudySession {
        
        guard (10...240).contains(focusMinutes) else {
            throw StudySessionError.invalidFocusDuration
        }
        
        if focusMinutes >= 60 && breakMinutes == 0 {
            throw StudySessionError.breakRequired
        }
        
        guard (0...30).contains(breakMinutes) else {
            throw StudySessionError.invalidBreakDuration
        }
        
        return StudySession (
            focusMinutes: focusMinutes,
            breakMinutes: breakMinutes,
            startedAt: currentDate
        )
    }
}
