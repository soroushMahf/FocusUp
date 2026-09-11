//
//  FocusView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct FocusView: View {
    
    @State private var viewModel = FocusViewModel()
    @State private var showingActiveSession = false
    
    @Bindable var studentProgressViewModel: StudentProgressViewModel
    @Bindable var studyGoalViewModel: StudyGoalViewModel
    @Bindable var studyPlanViewModel: StudyPlanViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Task/Goal Specific Focus") {
                    Picker("Academic Task", selection: $viewModel.selectedTask) {
                        Text("None")
                            .tag(nil as AcademicTask?)
                        
                        ForEach(
                            studyPlanViewModel.tasks.filter { !$0.isTaskCompleted }
                        ) { task in
                            Text("\(task.taskTitle) \n - \(task.taskSubjectName)")
                                .tag(task as AcademicTask?)
                        }
                    }
                    
                    Picker("Study Goal", selection: $viewModel.selectedStudyGoal) {
                        Text("None")
                            .tag(nil as StudyGoal?)
                        
                        ForEach(
                            studyGoalViewModel.goals) { goal in
                                Text("\(goal.goalTitle) \n\(goal.progress.formatted(.percent.precision(.fractionLength(0...2)))) progression")
                                    .tag(goal as StudyGoal?)
                        }
                    }
                }
                
                Section("Task Duration") {
                    HStack(spacing: 6) {
                        Text("Focus Duration")
                            .font(.headline)
                            .padding(.horizontal, 10)
                        
                        Spacer()
                        
                        TextField(
                            "Minutes",
                            value: $viewModel.focusMinutes,
                            format: .number
                        )
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack(spacing: 6) {
                        Text("Break Duration")
                            .font(.headline)
                            .padding(.horizontal, 10)
                        
                        Spacer()
                        
                        TextField(
                            "Minutes",
                            value: $viewModel.breakMinutes,
                            format: .number
                        )
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    }
                }
                
                Section {
                    Button("Start Study Session") {
                        if viewModel.startStudySession() {
                            showingActiveSession = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                
                

            }
            .navigationTitle("Focus")
            .navigationDestination(isPresented: $showingActiveSession) {
                ActiveStudySessionView(
                    viewModel: viewModel,
                    studentProgressViewModel: studentProgressViewModel,
                    studyGoalViewModel: studyGoalViewModel,
                    studyPlanViewModel: studyPlanViewModel
                )
            }
            .alert(
                "Unable to Start Session",
                isPresented: Binding (
                    get: { viewModel.errorMessage != nil },
                    set: {
                        if !$0 {
                            viewModel.errorMessage = nil
                        }
                    }
                )
            ) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    FocusView(
        studentProgressViewModel: StudentProgressViewModel(),
        studyGoalViewModel: StudyGoalViewModel(),
        studyPlanViewModel: StudyPlanViewModel()
    )
}
