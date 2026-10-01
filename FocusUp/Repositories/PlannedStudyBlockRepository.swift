//
//  PlannedStudyBlockRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

@MainActor
protocol PlannedStudyBlockRepository {
    func fetchPlannedStudyBlocks() throws -> [PlannedStudyBlock]
    func savePlannedStudyBlock(_ block: PlannedStudyBlock) throws
    func updatePlannedStudyBlock(_ block: PlannedStudyBlock) throws
    func deletePlannedStudyBlock(_ block: PlannedStudyBlock) throws
    func deleteAllPlannedStudyBlocks() throws
}
