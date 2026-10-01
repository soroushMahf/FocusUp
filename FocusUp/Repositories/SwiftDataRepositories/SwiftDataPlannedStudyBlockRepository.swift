//
//  SwiftDataPlannedStudyBlockRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataPlannedStudyBlockRepository: PlannedStudyBlockRepository {
    
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func savePlannedStudyBlock(_ block: PlannedStudyBlock) throws {
        let storedBlock = StoredPlannedStudyBlock(
            id: block.id,
            academicTaskID: block.academicTaskID,
            scheduledDate: block.scheduledDate,
            plannedStudyMinutes: block.plannedStudyMinutes,
            isCompleted: block.isCompleted
        )

        context.insert(storedBlock)

        try context.save()
    }

    func fetchPlannedStudyBlocks() throws -> [PlannedStudyBlock] {
        let descriptor = FetchDescriptor<StoredPlannedStudyBlock>(
            sortBy: [
                SortDescriptor(\.scheduledDate) // so the study blocks are sorted by date, ensuring those due first show up first
            ]
        )

        let storedBlocks = try context.fetch(descriptor)

        return storedBlocks.map { stored in
            PlannedStudyBlock(
                id: stored.id,
                academicTaskID: stored.academicTaskID,
                scheduledDate: stored.scheduledDate,
                plannedStudyMinutes: stored.plannedStudyMinutes,
                isCompleted: stored.isCompleted
            )
        }
    }

    func updatePlannedStudyBlock(_ block: PlannedStudyBlock) throws {
        let blockID = block.id
        
        let descriptor = FetchDescriptor<StoredPlannedStudyBlock>(
            predicate: #Predicate {
                $0.id == blockID
            }
        )
        
        guard let storedBlock = try context.fetch(descriptor).first else {
            return
        }

        storedBlock.academicTaskID = block.academicTaskID
        storedBlock.scheduledDate = block.scheduledDate
        storedBlock.plannedStudyMinutes = block.plannedStudyMinutes
        storedBlock.isCompleted = block.isCompleted

        try context.save()
    }

    func deletePlannedStudyBlock(_ block: PlannedStudyBlock) throws {
        let blockID = block.id

        let descriptor = FetchDescriptor<StoredPlannedStudyBlock>(
            predicate: #Predicate {
                $0.id == blockID
            }
        )

        guard let storedBlock = try context.fetch(descriptor).first else {
            return
        }

        context.delete(storedBlock)
        
        try context.save()
    }
    
    func deleteAllPlannedStudyBlocks() throws {
        let blocks = try fetchPlannedStudyBlocks()
        
        for block in blocks {
            try deletePlannedStudyBlock(block)
        }
    }
    
    
}
