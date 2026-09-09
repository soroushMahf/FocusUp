//
//  FocusView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 7/9/2026.
//

import SwiftUI

struct FocusView: View {
    
    @State private var viewModel = FocusViewModel()
    @State private var showingActiveSession = false
    
    @Bindable var studentProgressViewModel: StudentProgressViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                
                Spacer()
                
                Section {
                    VStack {
                        HStack(spacing: 6) {
                            Text("Focus Duration")
                                .font(.headline)
                                .padding(.horizontal, 10)
                            
                            Spacer()
                            
                            TextField(
                                "Minutes",
                                value: $viewModel.focusMinutes,
                                format: .number
                            )
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 40)
                        }
                        
                        HStack(spacing: 6) {
                            Text("Break Duration")
                                .font(.headline)
                                .padding(.horizontal, 10)
                            
                            Spacer()
                            
                            TextField(
                                "Minutes",
                                value: $viewModel.breakMinutes,
                                format: .number
                            )
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 40)
                        }
                    }
                }
                
                Spacer()
                
                Section {
                    Button("Start Study Session") {
                        if viewModel.startStudySession() {
                            showingActiveSession = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .bold()
                    .padding(.top, 20)
                    
                }
                
                Spacer()
            }
            .navigationTitle("Focus")
            .navigationDestination(isPresented: $showingActiveSession) {
                ActiveStudySessionView(
                    viewModel: viewModel,
                    studentProgressViewModel: studentProgressViewModel
                )
            }
            .alert(
                "Unable to Start Session",
                isPresented: Binding (
                    get: { viewModel.errorMessage != nil },
                    set: {
                        if !$0 {
                            viewModel.errorMessage = nil
                        }
                    }
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
//    FocusView()
}
