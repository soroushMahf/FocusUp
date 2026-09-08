//
//  NewAcademicTaskView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 8/9/2026.
//

import SwiftUI

struct NewAcademicTaskView: View {
    
    @Binding var viewModel: StudyPlanViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Task Title", text: $viewModel.title)
                    TextField("Subject Name ", text: $viewModel.subjectName)
                }
                Section {
                    DatePicker("Deadline", selection: $viewModel.deadline, displayedComponents: .date)
                    Picker("Priority", selection: $viewModel.taskPriority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority)
                        }
                    }
                }
            }
            .navigationTitle("New Academic Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.addTask() {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .alert(
                "Unable to Add Task",
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
}

#Preview {
    NewAcademicTaskView(
        viewModel: .constant(StudyPlanViewModel())
    )
}
