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
    @State private var studyPlanViewModel = StudyPlanViewModel()
    
    var body: some View {
        TabView {
            HomeView(studyGoalViewModel: studyGoalViewModel, studyPlanViewModel: studyPlanViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            StudyPlanView(viewModel: studyPlanViewModel)
                .tabItem {
                    Label("Study Plan", systemImage: "calendar")
                }
            
            FocusView(studentProgressViewModel: studentProgressViewModel, studyGoalViewModel: studyGoalViewModel)
                .tabItem {
                    Label("Focus", systemImage: "timer")
                }
            
            ProgressView(studentProgressViewModel: studentProgressViewModel, studyGoalViewModel: studyGoalViewModel)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    RootView()
}
