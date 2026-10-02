//
//  GenerateStudyScheduleUseCase.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import Foundation

@MainActor
struct GenerateStudyScheduleUseCase {
    
    private let academicTaskRepository: AcademicTaskRepository
    private let studyAvailabilityRepository: StudyAvailabilityRepository
    private let plannedStudyBlockRepository: PlannedStudyBlockRepository
    
    init(
        academicTaskRepository: AcademicTaskRepository,
        studyAvailabilityRepository: StudyAvailabilityRepository,
        plannedStudyBlockRepository: PlannedStudyBlockRepository
    ) {
        self.academicTaskRepository = academicTaskRepository
        self.studyAvailabilityRepository = studyAvailabilityRepository
        self.plannedStudyBlockRepository = plannedStudyBlockRepository
    }
    
    func execute(currentDate: Date = Date()) throws -> [PlannedStudyBlock] {
        
        let calendar = Calendar.current
        
        //fetching incomplete academic tasks
        let tasks = try academicTaskRepository.fetchTasks()
            .filter { !$0.isTaskCompleted }
        
        guard !tasks.isEmpty else {
            throw StudyScheduleError.noIncompleteTasks
        }
        
        //fetching the student's weekly availability
        let weeklyAvailability = try studyAvailabilityRepository.fetchWeeklyAvailability()
        
        guard weeklyAvailability.contains(
            where: { $0.availableStudyMinutes > 0 }
        ) else {
            throw StudyScheduleError.noStudyAvailability
        }
        
        // Sort tasks by deadline first, then priority
        let sortedTasks = tasks.sorted { firstTask, secondTask in

            if firstTask.taskDeadline != secondTask.taskDeadline {
                return firstTask.taskDeadline < secondTask.taskDeadline
            }
            
            return firstTask.taskPriority.schedulingValue > secondTask.taskPriority.schedulingValue //scheduling value is based on priority
        }

        // Tracks remaining availability for each actual calendar date
        var remainingMinutesByDate: [Date: Int] = [:]

        // Generate everything in memory before saving
        var generatedBlocks: [PlannedStudyBlock] = []

        for task in sortedTasks {
            var remainingTaskMinutes = task.estimatedStudyMinutes
            var schedulingDate = calendar.startOfDay(for: currentDate)
            let deadlineDate = calendar.startOfDay(for: task.taskDeadline)

            while remainingTaskMinutes > 0 && schedulingDate <= deadlineDate {
                let schedulingWeekday = weekday(
                    for: schedulingDate,
                    calendar: calendar
                )

                let dailyAvailability = weeklyAvailability.first {
                    $0.weekday == schedulingWeekday
                }?.availableStudyMinutes ?? 0

                var availableMinutes = remainingMinutesByDate[schedulingDate] ?? dailyAvailability

                // A day may contain multiple blocks
                if availableMinutes > 0 {
                    
                    // A planned study block cannot exceed the maximum focus session duration
                    let maximumFocusMinutes = 240

                    let blockMinutes = min(
                        remainingTaskMinutes,
                        availableMinutes,
                        maximumFocusMinutes
                    )

                    let block = PlannedStudyBlock(
                        academicTaskID: task.id,
                        scheduledDate: schedulingDate,
                        plannedStudyMinutes: blockMinutes,
                        completedStudyMinutes: 0
                    )

                    generatedBlocks.append(block)

                    remainingTaskMinutes -= blockMinutes
                    availableMinutes -= blockMinutes
                }

                remainingMinutesByDate[schedulingDate] = availableMinutes

                //stay on the same day if there is still availability
                if remainingTaskMinutes > 0 && availableMinutes > 0 {
                    continue
                }
                
                guard let nextDate = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: schedulingDate
                ) else {
                    break
                }

                schedulingDate = nextDate
            }

            // Entire task must fit before its deadline
            guard remainingTaskMinutes == 0 else {
                throw StudyScheduleError.insufficientStudyAvailability
            }
        }
        
        try plannedStudyBlockRepository.deleteAllPlannedStudyBlocks()

        // Only persist after the entire schedule has been successfully generated
        for block in generatedBlocks {
            try plannedStudyBlockRepository.savePlannedStudyBlock(block)
        }

        return generatedBlocks
    }
    
    private func weekday(for date: Date, calendar: Calendar) -> Weekday {
        switch calendar.component(.weekday, from: date) {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        default:
            return .saturday
        }
    }
}
