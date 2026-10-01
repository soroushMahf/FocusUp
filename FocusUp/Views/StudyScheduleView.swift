//
//  StudyScheduleView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import SwiftUI

struct StudyScheduleView: View {
    
    @Bindable var studyAvailabilityViewModel: StudyAvailabilityViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ContentUnavailableView (
                    "No Study Schedule",
                    systemImage: "calendar",
                    description: Text("Set your study availability to start building a personalised study schedule.")
                )
            }
            .navigationTitle("Study Schedule")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        StudyAvailabilityView(viewModel: studyAvailabilityViewModel)
                    } label: {
                        Image(systemName: "calendar.badge.clock")
                    }
                }
            }
        }
    }
}

//#Preview {
//    StudyScheduleView()
//}
