//
//  PersistenceController.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 11/9/2026.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: ModelContainer
    
    var context: ModelContext {
        container.mainContext
    }
    
    init() {
        do {
            container = try ModelContainer(
                for:
                    StoredAcademicTask.self,
                    StoredStudyGoal.self,
                    StoredStudentProgress.self,
                    StoredStudyAvailability.self,
                    StoredPlannedStudyBlock.self,
            )
        } catch {
            fatalError(
                "Unable to initialise FocusUp data storage: \(error)"
            )
        }
    }
}
