//
//  ContentView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct ContentView: View {
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
            
            FocusView()
                .tabItem {
                    Label("Focus", systemImage: "timer")
                }
            
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    ContentView()
}
