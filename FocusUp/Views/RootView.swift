//
//  RootView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct RootView: View {
    
    @State private var studentProgressViewModel = StudentProgressViewModel(
        repository: AppDependencies.studentProgressRepository
    )
    
    @State private var studyGoalViewModel = StudyGoalViewModel(
        repository: AppDependencies.studyGoalRepository
    )
    
    @State private var studyPlanViewModel = StudyPlanViewModel(
        repository: AppDependencies.academicTaskRepository
    )
    
    @State private var studyAvailabilityViewModel = StudyAvailabilityViewModel(
        repository: AppDependencies.studyAvailabilityRepository
    )
    
    @State private var studyScheduleViewModel = StudyScheduleViewModel(
        academicTaskRepository: AppDependencies.academicTaskRepository,
        studyAvailabilityRepository: AppDependencies.studyAvailabilityRepository,
        plannedStudyBlockRepository: AppDependencies.plannedStudyBlockRepository
    )
    
    var body: some View {
        TabView {
            HomeView(
                studyGoalViewModel: studyGoalViewModel,
                studyPlanViewModel: studyPlanViewModel
            )
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            StudyPlanView(viewModel: studyPlanViewModel)
                .tabItem {
                    Label("Study Plan", systemImage: "checklist")
                }
            
            StudyScheduleView(
                viewModel: studyScheduleViewModel,
                studyAvailabilityViewModel: studyAvailabilityViewModel,
                studentProgressViewModel: studentProgressViewModel,
                studyGoalViewModel: studyGoalViewModel,
                studyPlanViewModel: studyPlanViewModel
            )
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            
            FocusView(
                studentProgressViewModel: studentProgressViewModel,
                studyGoalViewModel: studyGoalViewModel,
                studyPlanViewModel: studyPlanViewModel
            )
                .tabItem {
                    Label("Focus", systemImage: "timer")
                }
            
            ProgressView(
                studentProgressViewModel: studentProgressViewModel,
                studyGoalViewModel: studyGoalViewModel
            )
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    RootView()
}
