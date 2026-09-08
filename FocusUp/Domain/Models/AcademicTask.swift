//
//  AcademicTask.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import Foundation
import SwiftUI

struct AcademicTask: Identifiable {
    let id: UUID = UUID()
    let title: String
    let subjectName: String
    let deadline: Date
    let taskPriority: TaskPriority
    var isCompleted: Bool = false
}

enum TaskPriority: String, CaseIterable {
    case low = "Low Priority"
    case medium = "Medium Priority"
    case high = "High Priority"
    
    var color: Color {
        switch self {
        case .low:
            Color.green
        case.medium:
            Color.orange
        case .high:
            Color.red
        }
    }
}
