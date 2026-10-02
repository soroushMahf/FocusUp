//
//  GenerateStudyScheduleUseCaseTests.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import Testing
import Foundation
@testable import FocusUp

@MainActor
struct GenerateStudyScheduleUseCaseTests {
    
    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        Calendar.current.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day
            )
        )!
    }
    
    @Test("Academic task is scheduled within available study time before its deadline")
    func academicTaskIsScheduledSuccessfully() throws {
        let taskRepository = MockAcademicTaskRepository()
        let availabilityRepository = MockStudyAvailabilityRepository()
        let blockRepository = MockPlannedStudyBlockRepository()

        let currentDate = makeDate(year: 2026, month: 10, day: 5)

        let deadline = makeDate(year: 2026, month: 10, day: 6)

        let task = AcademicTask(
            taskTitle: "Complete AT3",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: deadline,
            taskPriority: .high,
            estimatedStudyMinutes: 180
        )

        taskRepository.tasks = [task]

        availabilityRepository.availability = [
            StudyAvailability(
                weekday: .monday,
                availableStudyMinutes: 120
            ),

            StudyAvailability(
                weekday: .tuesday,
                availableStudyMinutes: 120
            )
        ]

        let useCase = GenerateStudyScheduleUseCase(
            academicTaskRepository: taskRepository,
            studyAvailabilityRepository: availabilityRepository,
            plannedStudyBlockRepository: blockRepository
        )

        let blocks = try useCase.execute(
            currentDate: currentDate
        )

        #expect(blocks.count == 2)
        #expect(blocks[0].academicTaskID == task.id)
        #expect(blocks[0].plannedStudyMinutes == 120)
        #expect(blocks[1].plannedStudyMinutes == 60)

        #expect(blockRepository.blocks.count == 2)
    }
    
    @Test("Study schedule fails when there are no incomplete academic tasks")
    func noIncompleteTasksFails() {
        
        let taskRepository = MockAcademicTaskRepository()
        let availabilityRepository = MockStudyAvailabilityRepository()
        let blockRepository = MockPlannedStudyBlockRepository()
        
        let currentDate = makeDate(year: 2026, month: 10, day: 5)
        
        let completedTask = AcademicTask(
            taskTitle: "Completed AT3",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: makeDate(year: 2026, month: 10, day: 6),
            taskPriority: .high,
            estimatedStudyMinutes: 120,
            isTaskCompleted: true
        )
        
        taskRepository.tasks = [completedTask]
        
        availabilityRepository.availability = [
            StudyAvailability(
                weekday: .monday,
                availableStudyMinutes: 120
            )
        ]
        
        let useCase = GenerateStudyScheduleUseCase(
            academicTaskRepository: taskRepository,
            studyAvailabilityRepository: availabilityRepository,
            plannedStudyBlockRepository: blockRepository
        )
        
        #expect(throws: StudyScheduleError.noIncompleteTasks) {
            try useCase.execute(currentDate: currentDate)
        }
    }
    
    @Test("Study schedule fails when the student has no study availability")
    func noStudyAvailabilityFails() {
        
        let taskRepository = MockAcademicTaskRepository()
        let availabilityRepository = MockStudyAvailabilityRepository()
        let blockRepository = MockPlannedStudyBlockRepository()
        
        let currentDate = makeDate(year: 2026, month: 10, day: 5)
        
        let task = AcademicTask(
            taskTitle: "Complete AT3",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: makeDate(year: 2026, month: 10, day: 6),
            taskPriority: .high,
            estimatedStudyMinutes: 120
        )
        
        taskRepository.tasks = [task]
        
        // No availability has been configured.
        availabilityRepository.availability = []
        
        let useCase = GenerateStudyScheduleUseCase(
            academicTaskRepository: taskRepository,
            studyAvailabilityRepository: availabilityRepository,
            plannedStudyBlockRepository: blockRepository
        )
        
        #expect(throws: StudyScheduleError.noStudyAvailability) {
            try useCase.execute(currentDate: currentDate)
        }
    }
    
    @Test("Study schedule fails when there is not enough availability before the deadline")
    func insufficientStudyAvailabilityFails() {
        
        let taskRepository = MockAcademicTaskRepository()
        let availabilityRepository = MockStudyAvailabilityRepository()
        let blockRepository = MockPlannedStudyBlockRepository()
        
        let currentDate = makeDate(year: 2026, month: 10, day: 5)
        
        let task = AcademicTask(
            taskTitle: "Complete AT3",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: makeDate(year: 2026, month: 10, day: 6),
            taskPriority: .high,
            estimatedStudyMinutes: 300
        )
        
        taskRepository.tasks = [task]
        
        availabilityRepository.availability = [
            StudyAvailability(
                weekday: .monday,
                availableStudyMinutes: 120
            ),
            StudyAvailability(
                weekday: .tuesday,
                availableStudyMinutes: 120
            )
        ]
        
        let useCase = GenerateStudyScheduleUseCase(
            academicTaskRepository: taskRepository,
            studyAvailabilityRepository: availabilityRepository,
            plannedStudyBlockRepository: blockRepository
        )
        
        #expect(throws: StudyScheduleError.insufficientStudyAvailability) {
            try useCase.execute(currentDate: currentDate)
        }
        
        // A failed schedule should not be partially persisted.
        #expect(blockRepository.blocks.isEmpty)
    }
    
    @Test("Academic task with the earlier deadline is scheduled first")
    func earlierDeadlineIsScheduledFirst() throws {
        
        let taskRepository = MockAcademicTaskRepository()
        let availabilityRepository = MockStudyAvailabilityRepository()
        let blockRepository = MockPlannedStudyBlockRepository()
        
        let currentDate = makeDate(year: 2026, month: 10, day: 5)
        
        let laterTask = AcademicTask(
            taskTitle: "Later Assignment",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: makeDate(year: 2026, month: 10, day: 7),
            taskPriority: .high,
            estimatedStudyMinutes: 120
        )
        
        let earlierTask = AcademicTask(
            taskTitle: "Earlier Assignment",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: makeDate(year: 2026, month: 10, day: 6),
            taskPriority: .medium,
            estimatedStudyMinutes: 120
        )
        
        // Deliberately put the later task first.
        taskRepository.tasks = [laterTask, earlierTask]
        
        availabilityRepository.availability = [
            StudyAvailability(
                weekday: .monday,
                availableStudyMinutes: 120
            ),
            StudyAvailability(
                weekday: .tuesday,
                availableStudyMinutes: 120
            )
        ]
        
        let useCase = GenerateStudyScheduleUseCase(
            academicTaskRepository: taskRepository,
            studyAvailabilityRepository: availabilityRepository,
            plannedStudyBlockRepository: blockRepository
        )
        
        let blocks = try useCase.execute(currentDate: currentDate)
        
        #expect(blocks.count == 2)
        
        #expect(blocks[0].academicTaskID == earlierTask.id)
        
        #expect(blocks[1].academicTaskID == laterTask.id)
    }
    
    @Test("Generating a new study schedule replaces the existing schedule")
    func existingScheduleIsReplaced() throws {
        
        let taskRepository = MockAcademicTaskRepository()
        let availabilityRepository = MockStudyAvailabilityRepository()
        let blockRepository = MockPlannedStudyBlockRepository()
        
        let currentDate = makeDate(year: 2026, month: 10, day: 5)
        
        let task = AcademicTask(
            taskTitle: "Complete AT3",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: makeDate(year: 2026, month: 10, day: 6),
            taskPriority: .high,
            estimatedStudyMinutes: 120
        )
        
        taskRepository.tasks = [task]
        
        availabilityRepository.availability = [
            StudyAvailability(
                weekday: .monday,
                availableStudyMinutes: 120
            )
        ]
        
        let oldBlock = PlannedStudyBlock(
            academicTaskID: task.id,
            scheduledDate: currentDate,
            plannedStudyMinutes: 60,
            completedStudyMinutes: 30
        )
        
        blockRepository.blocks = [oldBlock]
        
        let useCase = GenerateStudyScheduleUseCase(
            academicTaskRepository: taskRepository,
            studyAvailabilityRepository: availabilityRepository,
            plannedStudyBlockRepository: blockRepository
        )
        
        let generatedBlocks = try useCase.execute(
            currentDate: currentDate
        )
        
        #expect(generatedBlocks.count == 1)
        
        // Old schedule has been replaced,
        // rather than appended to.
        #expect(blockRepository.blocks.count == 1)
        
        #expect(blockRepository.blocks.first?.id != oldBlock.id)
        
        #expect(
            blockRepository.blocks.first?
                .plannedStudyMinutes == 120
        )
    }
}
