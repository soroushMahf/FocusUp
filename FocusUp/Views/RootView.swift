//
//  RootView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct RootView: View {
    
    @State private var studentProgressViewModel = StudentProgressViewModel()
    @State private var studyGoalViewModel = StudyGoalViewModel()
    
    @State private var studyPlanViewModel = StudyPlanViewModel(repository: SwiftDataAcademicTaskRepository())
    
    @State private var studyAvailabilityViewModel = StudyAvailabilityViewModel(
        repository: SwiftDataStudyAvailabilityRepository(
            context: PersistenceController.shared.context
        )
    )
    
    @State private var studyScheduleViewModel = StudyScheduleViewModel(
        academicTaskRepository: SwiftDataAcademicTaskRepository(),
        studyAvailabilityRepository: SwiftDataStudyAvailabilityRepository(
            context: PersistenceController.shared.context
        ),
        plannedStudyBlockRepository: SwiftDataPlannedStudyBlockRepository(
            context: PersistenceController.shared.context
        )
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
                studyAvailabilityViewModel: studyAvailabilityViewModel
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
