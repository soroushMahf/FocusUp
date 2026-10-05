//
//  AcademicTaskRepository.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 30/9/2026.
//

import Foundation

@MainActor
protocol AcademicTaskRepository {
    func saveTask(_ task: AcademicTask) throws
    func fetchTasks() throws -> [AcademicTask]
    func fetchIncompleteTasks() throws -> [AcademicTask]
    func updateTask(_ task: AcademicTask) throws
    func deleteTask(_ task: AcademicTask) throws
}
