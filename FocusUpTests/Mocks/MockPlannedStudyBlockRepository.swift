//
//  MockPlannedStudyBlockRepository.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import Foundation
@testable import FocusUp

@MainActor
final class MockPlannedStudyBlockRepository: PlannedStudyBlockRepository {
    
    var blocks: [PlannedStudyBlock] = []
    
    func savePlannedStudyBlock(_ block: PlannedStudyBlock) throws {
        blocks.append(block)
    }
    
    func fetchPlannedStudyBlocks() throws -> [PlannedStudyBlock] {
        blocks
    }
    
    func updatePlannedStudyBlock(_ block: PlannedStudyBlock) throws {
        guard let index = blocks.firstIndex(
            where: { $0.id == block.id }
        ) else {
            return
        }
        
        blocks[index] = block
    }
    
    func deletePlannedStudyBlock(_ block: PlannedStudyBlock) throws {
        blocks.removeAll { $0.id == block.id }
    }
}
