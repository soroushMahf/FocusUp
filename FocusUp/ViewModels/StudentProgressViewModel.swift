//
//  StudentProgressViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 10/9/2026.
//

import Foundation

@Observable
final class StudentProgressViewModel {
    
    var progress = StudentProgress()
    
    func recordCompletedSession(studyMinutes: Int) {
        progress.totalStudyMinutes += studyMinutes
        progress.completedSessions += 1
    }
}
