//
//  ProgressView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct ProgressView: View {
    
    @Bindable var studentProgressViewModel: StudentProgressViewModel
    @Bindable var studyGoalViewModel: StudyGoalViewModel
    
    @State private var showingNewGoalView = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Overall Progress") {
                    LabeledContent(
                        "Total Study Time",
                        value: "\(studentProgressViewModel.progress.totalStudyMinutes) min"
                    )
                    
                    LabeledContent(
                        "Completed FocusUp Sessions",
                        value: "\(studentProgressViewModel.progress.completedSessions)"
                    )
                }
                
                Section("Study Goals") {
                    if studyGoalViewModel.goals.isEmpty {
                        Text("You don't have any study goals yet.")
                    } else {
                        ForEach(studyGoalViewModel.goals) { goal in
                            VStack (alignment: .leading, spacing: 20){
                                HStack {
                                    Text(goal.goalTitle)
                                        .font(.headline)
        
                                    Spacer()
        
                                    Text(goal.goalDeadline, style: .date)
                                        .font(.caption2)
                                }
        
                                //Using SwiftUI before ProgressView as XCode confuses it with the ProgressView file
                                SwiftUI.ProgressView(value: goal.progress)
        
                                Text("\(goal.goalCompletedMinutes) / \(goal.goalTargetMinutes) minutes")
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    studyGoalViewModel.deleteGoal(goal)
                                } label: {
                                    Label("Remove Goal", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Progress")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewGoalView = true
                    } label : {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewGoalView) {
                NavigationStack {
                    NewStudyGoalView(viewModel: studyGoalViewModel)
                }
            }
        }
    }
}

#Preview {
    ProgressView(studentProgressViewModel: StudentProgressViewModel(), studyGoalViewModel: StudyGoalViewModel())
}
