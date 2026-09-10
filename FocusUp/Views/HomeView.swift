//
//  HomeView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct HomeView: View {
    
    @Bindable var studyGoalViewModel: StudyGoalViewModel
    @State private var showingNewGoalView = false
    @Bindable var studyPlanViewModel: StudyPlanViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Priority Study Goal") {
                    if let goal = studyGoalViewModel.goals.first {
                        VStack (alignment: .leading, spacing: 20){
                            HStack {
                                Text(goal.goalTitle)
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(goal.goalDeadline, style: .date)
                                    .font(.caption2)
                            }
                            
                            
                            //Using SwiftUI before ProgressView as XCode confuses it with my ProgressView file
                            SwiftUI.ProgressView(value: goal.progress)
                            
                            Text("\(goal.goalCompletedMinutes) / \(goal.goalTargetMinutes) minutes")
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    } else {
                        ContentUnavailableView(
                            "You have no Study Goals",
                            systemImage: "target",
                            description: Text("Add a new goal to get started")
                        )
                    }
                }
                
                Section ("Quick Summary") {
                    HStack {
                        Text("Number of Goals")
                        Spacer()
                        Text("\(studyGoalViewModel.goals.count)")
                    }
                    HStack {
                        Text("Number of Academic Tasks")
                        Spacer()
                        Text("\(studyPlanViewModel.tasks.count)")
                    }
                    
                    
                }
            }
            .navigationTitle("FocusUp")
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
    HomeView(studyGoalViewModel: StudyGoalViewModel(), studyPlanViewModel: StudyPlanViewModel())
}
