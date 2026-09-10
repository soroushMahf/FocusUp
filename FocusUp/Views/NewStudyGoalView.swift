//
//  NewStudyGoalView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 10/9/2026.
//

import SwiftUI

struct NewStudyGoalView: View {
    
    @Bindable var viewModel: StudyGoalViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Title") {
                    TextField("Enter Goal Title", text: $viewModel.goalTitle)
                }
                
                Section("Study Target") {
                    TextField("Minutes", value: $viewModel.goalTargetMinutes, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    DatePicker("Deadline", selection: $viewModel.goalDeadline, displayedComponents: .date)
                }
            }
        }
        .navigationTitle("Add Study Goal")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if viewModel.addGoal() {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert(
            "Unable to Add Goal",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    NewStudyGoalView(viewModel: StudyGoalViewModel())
}
