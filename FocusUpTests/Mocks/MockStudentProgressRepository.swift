//
//  MockStudentProgressRepository.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 5/10/2026.
//

import Foundation
@testable import FocusUp

@MainActor
final class MockStudentProgressRepository:
    StudentProgressRepository {

    var progress = StudentProgress()

    func fetchStudentProgress() throws -> StudentProgress {
        progress
    }

    func updateStudentProgress(_ progress: StudentProgress) throws {
        self.progress = progress
    }
}
