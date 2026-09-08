//
//  StudyPlanView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct StudyPlanView: View {
    
    @State private var viewModel = StudyPlanViewModel()
    @State private var showingNewTaskView = false
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.tasks.isEmpty {
                    ContentUnavailableView(
                        "You have no upcoming tasks!",
                        systemImage: "checklist.checked",
                        description: Text("Add an upcoming assignment or study tasks to FocusUp!")
                    )
                } else {
                    ForEach(viewModel.tasks) { task in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(task.title)
                                .font(.headline)
                            Text(task.subjectName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Text(task.deadline, style: .date)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(task.taskPriority.rawValue.capitalized)
                                    .font(.caption)
                                    .foregroundStyle(task.taskPriority.color)
                                    .bold()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Study Plan")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewTaskView = true
                    } label : {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewTaskView) {
                NewAcademicTaskView (
                    viewModel: $viewModel
                )
            }
        }
    }
}

#Preview {
    StudyPlanView()
}
