//
//  StudentProgressRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 5/10/2026.
//

import Foundation

@MainActor
protocol StudentProgressRepository {
    func fetchStudentProgress() throws -> StudentProgress
    func updateStudentProgress(_ progress: StudentProgress) throws
}
