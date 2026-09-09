//
//  ProgressView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct ProgressView: View {
    
    @Bindable var viewModel: StudentProgressViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Study Progress") {
                    LabeledContent(
                        "Total Study Time",
                        value: "\(viewModel.progress.totalStudyMinutes) min"
                    )
                    
                    LabeledContent(
                        "Completed FocusUp Sessions",
                        value: "\(viewModel.progress.completedSessions)"
                    )
                }
            }
            .navigationTitle("Progress")
        }
    }
}

#Preview {
    ProgressView(viewModel: StudentProgressViewModel())
}
