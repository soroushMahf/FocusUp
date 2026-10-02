//
//  StudyScheduleViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import Foundation

@Observable
@MainActor
final class StudyScheduleViewModel {
    
    var plannedStudyBlocks: [PlannedStudyBlock] = []
    var academicTasks: [AcademicTask] = []
    var errorMessage: String?
    
    private let academicTaskRepository: AcademicTaskRepository
    private let plannedStudyBlockRepository: PlannedStudyBlockRepository
    private let generateStudyScheduleUseCase: GenerateStudyScheduleUseCase
    
    init(
        academicTaskRepository: AcademicTaskRepository,
        studyAvailabilityRepository: StudyAvailabilityRepository,
        plannedStudyBlockRepository: PlannedStudyBlockRepository
    ) {
        self.academicTaskRepository = academicTaskRepository
        self.plannedStudyBlockRepository = plannedStudyBlockRepository
        
        self.generateStudyScheduleUseCase = GenerateStudyScheduleUseCase(
            academicTaskRepository: academicTaskRepository,
            studyAvailabilityRepository: studyAvailabilityRepository,
            plannedStudyBlockRepository: plannedStudyBlockRepository
        )
        
        loadStudySchedule()
    }
    
    // retrieve an existing persisted schedule
    func loadStudySchedule() {
        do {
            plannedStudyBlocks = try plannedStudyBlockRepository.fetchPlannedStudyBlocks()
            
            academicTasks = try academicTaskRepository.fetchTasks()
            
            errorMessage = nil
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // using the use case to create a new schedule
    func generateStudySchedule() -> Bool {
        do {
            plannedStudyBlocks = try generateStudyScheduleUseCase.execute()
            
            academicTasks = try academicTaskRepository.fetchTasks()
            
            errorMessage = nil
            return true
        
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func task(for block: PlannedStudyBlock) -> AcademicTask? {
        academicTasks.first {
            $0.id == block.academicTaskID
        }
    }
    
    func recordStudyProgress(for block: PlannedStudyBlock, completedMinutes: Int) {
        var updatedBlock = block
        
        updatedBlock.completedStudyMinutes = min(
            block.completedStudyMinutes + completedMinutes,
            block.plannedStudyMinutes
        )
        
        do {
            try plannedStudyBlockRepository.updatePlannedStudyBlock(updatedBlock)
            loadStudySchedule()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
