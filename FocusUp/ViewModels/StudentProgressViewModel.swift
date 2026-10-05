//
//  StudentProgressViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 10/9/2026.
//

import Foundation

@Observable
@MainActor
final class StudentProgressViewModel {
    
    var progress = StudentProgress()
    var errorMessage: String?
    
    private let repository: StudentProgressRepository
    
    init(repository: StudentProgressRepository) {
        self.repository = repository
        
        loadProgress()
    }
    
    convenience init() {
        self.init(
            repository: AppDependencies.studentProgressRepository
        )
    }
    
    func loadProgress() {
        do {
            progress = try repository.fetchStudentProgress()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func recordCompletedSession(studyMinutes: Int) {
        progress.totalStudyMinutes += studyMinutes
        progress.completedSessions += 1
        
        do {
            try repository.updateStudentProgress(progress)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
