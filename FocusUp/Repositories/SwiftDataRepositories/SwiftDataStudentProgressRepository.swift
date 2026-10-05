//
//  SwiftDataStudentProgressRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 5/10/2026.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataStudentProgressRepository:
    StudentProgressRepository {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchStudentProgress() throws -> StudentProgress {

        let descriptor = FetchDescriptor<StoredStudentProgress>()

        let storedProgress = try context.fetch(descriptor)

        if let progress = storedProgress.first {
            return StudentProgress(
                totalStudyMinutes: progress.totalStudyMinutes,
                completedSessions: progress.completedSessions
            )
        }

        let newProgress = StoredStudentProgress()

        context.insert(newProgress)

        try context.save()

        return StudentProgress()
    }
    
    // if the student already has progress, fetch it, else create new progress
    func updateStudentProgress(_ progress: StudentProgress) throws {
        let descriptor = FetchDescriptor<StoredStudentProgress>()
        
        let storedProgress = try context.fetch(descriptor)
        
        if let existingProgress = storedProgress.first {
            existingProgress.totalStudyMinutes = progress.totalStudyMinutes
            existingProgress.completedSessions = progress.completedSessions
        } else {
            let newProgress = StoredStudentProgress(
                totalStudyMinutes: progress.totalStudyMinutes,
                completedSessions: progress.completedSessions
            )
            context.insert(newProgress)
        }
        
        try context.save()
    }
}
