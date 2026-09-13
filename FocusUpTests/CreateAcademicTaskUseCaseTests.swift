//
//  CreateAcademicTaskUseCaseTests.swift
//  FocusUpTests
//
//  Created by Soroush Mahfoozi on 13/9/2026.
//

import Testing
@testable import FocusUp
import Foundation

@MainActor
struct CreateAcademicTaskUseCaseTests {

    let persistenceController: PersistenceController
    let useCase: CreateAcademicTaskUseCase
    
    let currentDate = Date()
    let futureDeadline = Date().addingTimeInterval(60 * 60 * 24) // making the deadline tomorrow
    
    init() {
        persistenceController = PersistenceController(inMemory: true)
        useCase = CreateAcademicTaskUseCase(
            persistenceController: persistenceController
        )
    }
    
    @Test("Academic task is created and saved when all required details are valid")
    func validAcademicTaskIsCreated() throws {
        
        let task = try useCase.execute(
            taskTitle: "Complete iOS Assignment",
            taskSubjectName: "Advanced iOS Development",
            taskDeadline: futureDeadline,
            taskPriority: .high,
            currentDate: currentDate
        )
        
        #expect(task.taskTitle == "Complete iOS Assignment")
        #expect(task.taskSubjectName == "Advanced iOS Development")
        #expect(task.taskDeadline == futureDeadline)
        #expect(task.taskPriority == .high)
        #expect(task.isTaskCompleted == false)
        
        //testing if task is also saved
        let savedTasks = try persistenceController.fetchTasks()
        
        #expect(savedTasks.count == 1)
    }
    
    @Test("Academic task fails when the task title is empty")
    func emptyTaskTitleFails() {
        #expect(throws: AcademicTaskError.missingTitle) {
            try useCase.execute(
                taskTitle: "",
                taskSubjectName: "Advanced iOS Development",
                taskDeadline: futureDeadline,
                taskPriority: .high,
                currentDate: currentDate
            )
        }
    }
    
    @Test("Academic task fails when the task subject name is empty")
    func emptyTaskSubjectNameFails() {
        #expect(throws: AcademicTaskError.missingSubject) {
            try useCase.execute(
                taskTitle: "Complete iOS Assignment",
                taskSubjectName: "",
                taskDeadline: futureDeadline,
                taskPriority: .high,
                currentDate: currentDate
            )
        }
    }
    
    @Test("Academic Task fails when the deadline is in the past")
    func task_deadlineIsInPastFails() {
        let pastDeadline = currentDate.addingTimeInterval(-(60 * 60 * 24))
        
        #expect(throws: AcademicTaskError.deadlineInPast) {
            try useCase.execute(
                taskTitle: "Complete iOS Assignment",
                taskSubjectName: "Advanced iOS Development",
                taskDeadline: pastDeadline,
                taskPriority: .high,
                currentDate: currentDate
            )
        }
    }
    
    @Test("Academic Task fails when the deadline is equal to the current date")
    func task_deadlineEqualToCurrentDateFails() {
        #expect(throws: AcademicTaskError.deadlineInPast) {
            try useCase.execute(
                taskTitle: "Complete iOS Assignment",
                taskSubjectName: "Advanced iOS Development",
                taskDeadline: currentDate,
                taskPriority: .high,
                currentDate: currentDate
            )
        }
    }
}
