//
//  StudyScheduleView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import SwiftUI

struct StudyScheduleView: View {
    
    @Bindable var viewModel: StudyScheduleViewModel
    @Bindable var studyAvailabilityViewModel: StudyAvailabilityViewModel
    
    //Adding these viewModels so the user can navigate to FocusView
    @Bindable var studentProgressViewModel: StudentProgressViewModel
    @Bindable var studyGoalViewModel: StudyGoalViewModel
    @Bindable var studyPlanViewModel: StudyPlanViewModel
    
    @State private var showingStudyAvailability = false
    
    var body: some View {
        NavigationStack {
            
            Group {
                if viewModel.validPlannedStudyBlocks.isEmpty {
            
                    ContentUnavailableView {
                        Label("No Study Schedule", systemImage: "calendar")
                    } description: {
                        Text("Generate a personalised study schedule based on your academic tasks, deadlines, and weekly availability.")
                    } actions: {
                        Button("Generate Schedule") {
                            showingStudyAvailability = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                } else {
                    
                    List {
                        ForEach(viewModel.validPlannedStudyBlocks) { block in
                            
                            if let task = viewModel.task(for: block) {
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    
                                    Text(task.taskTitle)
                                        .font(.headline)
                                    
                                    Text(task.taskSubjectName)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    HStack{
                                        Text(
                                            block.scheduledDate,
                                            format: .dateTime
                                                .weekday(.wide)
                                                .day()
                                                .month()
                                        )
                                        .font(.headline)
                                        
                                        Spacer()
                                        
                                        Text("\(formatStudyTime(block.completedStudyMinutes)) / \(formatStudyTime(block.plannedStudyMinutes))")
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                    if block.isCompleted {
                                        Label("Completed", systemImage: "checkmark.circle.fill")
                                    } else {
                                        NavigationLink {
                                            FocusView(
                                                studentProgressViewModel: studentProgressViewModel,
                                                studyGoalViewModel: studyGoalViewModel,
                                                studyPlanViewModel: studyPlanViewModel,
                                                scheduledBlock: block,
                                                scheduledTask: task,
                                                studyScheduleViewModel: viewModel
                                            )
                                        } label: {
                                            Label(
                                                block.completedStudyMinutes > 0
                                                    ? "Continue Studying"
                                                    : "Start Studying",
                                                systemImage: "play.fill"
                                            )
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Study Schedule")
            .onAppear {
                viewModel.loadStudySchedule()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingStudyAvailability = true
                    } label: {
                        Image(systemName: "calendar.badge.clock")
                    }
                }
            }
            .sheet(isPresented: $showingStudyAvailability) {
                StudyAvailabilityView(
                    viewModel: studyAvailabilityViewModel,
                    onConfirm: {
                        let wasGenerated = viewModel.generateStudySchedule()
                        
                        if wasGenerated {
                            showingStudyAvailability = false
                        }
                    }
                )
            }
            .alert(
                "Unable to Generate Study Schedule",
                isPresented: Binding(
                    get: {
                        viewModel.errorMessage != nil
                    },
                    set: {_ in
                        viewModel.errorMessage = nil
                    }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
    
    private func formatStudyTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours == 0 {
            return "\(remainingMinutes) min"
        } else {
            return "\(hours) hr \(remainingMinutes) min"
        }
    }
}

//#Preview {
//    StudyScheduleView()
//}
