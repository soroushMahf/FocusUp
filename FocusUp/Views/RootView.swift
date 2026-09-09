//
//  RootView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct RootView: View {
    
    @State private var studentProgressViewModel = StudentProgressViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            StudyPlanView()
                .tabItem {
                    Label("Study Plan", systemImage: "calendar")
                }
            
            FocusView(studentProgressViewModel: studentProgressViewModel)
                .tabItem {
                    Label("Focus", systemImage: "timer")
                }
            
            ProgressView(viewModel: studentProgressViewModel)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    RootView()
}
