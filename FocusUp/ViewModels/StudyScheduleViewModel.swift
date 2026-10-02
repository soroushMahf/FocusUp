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
    
    // for widget extension
    private let widgetStore = StudyScheduleWidgetStore()
    
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
            
            updateWidgetData()
            
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
            
            loadStudySchedule()
            
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
    
    // function for widget
    private func updateWidgetData() {
        let currentDate = Date()
        
        let nextBlock = plannedStudyBlocks
            .filter { !$0.isCompleted }
            .filter {
                Calendar.current.startOfDay(for: $0.scheduledDate) >=
                Calendar.current.startOfDay(for: currentDate)
            }
            .sorted {
                $0.scheduledDate < $1.scheduledDate
            }
            .first
        
        guard let nextBlock,
              let task = academicTasks.first(where: {
                  $0.id == nextBlock.academicTaskID
              }) else {
            widgetStore.clear()
            return
        }
        
        let widgetData = StudyScheduleWidgetData(
            taskTitle: task.taskTitle,
            subjectName: task.taskSubjectName,
            scheduledDate: nextBlock.scheduledDate,
            remainingStudyMinutes: nextBlock.plannedStudyMinutes - nextBlock.completedStudyMinutes
        )
        
        widgetStore.save(widgetData)
    }
}
