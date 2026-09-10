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
                Section("Upcoming Tasks") {
                    if viewModel.tasks.filter({ !$0.isTaskCompleted }).isEmpty {
                        ContentUnavailableView(
                            "You have no upcoming tasks!",
                            systemImage: "checklist.checked",
                            description: Text("Add an upcoming assignment or study tasks to FocusUp!")
                        )
                    } else {
                        ForEach(viewModel.tasks.filter { !$0.isTaskCompleted }) { task in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(task.taskTitle)
                                    .font(.headline)
                                
                                Text(task.taskSubjectName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                HStack {
                                    Text(task.taskDeadline, style: .date)
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Text(task.taskPriority.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(task.taskPriority.color)
                                        .bold()
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    viewModel.completeTask(task)
                                } label: {
                                    Label("Complete", systemImage: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.deleteTask(task)
                                } label : {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                
                Section("Completed Tasks") {
                    ForEach(viewModel.tasks.filter { $0.isTaskCompleted }) { task in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(task.taskTitle)
                                .font(.headline)
                            
                            Text(task.taskSubjectName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Text(task.taskDeadline, style: .date)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(task.taskPriority.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(task.taskPriority.color)
                                    .bold()
                            }
                        }
                        .strikethrough()
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.completeTask(task)
                            } label: {
                                Label("Incomplete", systemImage: "circle.dashed")
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.deleteTask(task)
                            } label : {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)
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
                    viewModel: viewModel
                )
            }
        }
    }
}

#Preview {
    StudyPlanView()
}
