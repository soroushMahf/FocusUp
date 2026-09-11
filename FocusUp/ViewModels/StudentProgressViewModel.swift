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
    var errorMessage: String?
    
    private let persistenceController = PersistenceController.shared
    
    init() {
        loadProgress()
    }
    
    func loadProgress() {
        do {
            progress = try persistenceController.fetchStudentProgress()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func recordCompletedSession(studyMinutes: Int) {
        progress.totalStudyMinutes += studyMinutes
        progress.completedSessions += 1
        
        do {
            try persistenceController.updateStudentProgress(progress)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
