//
//  AppDependencies.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 5/10/2026.
//

// Main role of this file is to create and connect the app dependencies in one place rather than in root view.
import Foundation

@MainActor
enum AppDependencies {
    static let academicTaskRepository = SwiftDataAcademicTaskRepository(
        context: PersistenceController.shared.context
    )

    static let studyGoalRepository = SwiftDataStudyGoalRepository(
        context: PersistenceController.shared.context
    )

    static let studentProgressRepository = SwiftDataStudentProgressRepository(
        context: PersistenceController.shared.context
    )

    static let studyAvailabilityRepository = SwiftDataStudyAvailabilityRepository(
        context: PersistenceController.shared.context
    )

    static let plannedStudyBlockRepository = SwiftDataPlannedStudyBlockRepository(
        context: PersistenceController.shared.context
    )
}
