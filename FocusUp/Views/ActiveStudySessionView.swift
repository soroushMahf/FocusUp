//
//  ActiveStudySessionView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 9/9/2026.
//

import SwiftUI

struct ActiveStudySessionView: View {
    
    @Bindable var viewModel: FocusViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text(phaseTitle)
                .font(.title2)
                .fontWeight(.semibold)
            
            if viewModel.sessionPhase == .completed {
                VStack(spacing: 20) {
                    Text("Great Work! Your focusUp session is complete")
                        .foregroundStyle(.secondary)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size:40))
                }
            } else {
                Text(viewModel.formattedRemainingTime)
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
            }
            
            if let session = viewModel.activeSession {
                if viewModel.sessionPhase == .breakTime {
                    Text("Stretch - Hydrate - Rest")
                } else {
                    HStack {
                        Text("Total Focus Duration")
                        Spacer()
                        Text("\(session.focusMinutes) min")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Break Duration")
                        Spacer()
                        Text("\(session.breakMinutes) min")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Spacer()
            
            if viewModel.sessionPhase == .firstHalfFocus || viewModel.sessionPhase == .secondHalfFocus {
                HStack(spacing: 20){
                    Button {
                        if viewModel.isTimerRunning {
                            viewModel.pauseTimer()
                        } else {
                            viewModel.resumeTimer()
                        }
                    } label : {
                        Image(
                            systemName: viewModel.isTimerRunning
                                ? "pause.fill"
                                : "play.fill"
                        )
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .font(.system(size: 30))
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    
                    Button(role: .destructive) {
                        viewModel.endSessionEarly()
                    } label: {
                        Image(systemName: "xmark")
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .font(.system(size:30, weight: .bold))
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                }
            }
            
            if viewModel.sessionPhase == .breakTime {
                Button {
                    viewModel.skipBreak()
                } label: {
                    Image(systemName: "forward.fill")
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .font(.system(size: 30))
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("FocusUp Session")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var phaseTitle: String {
        switch viewModel.sessionPhase {
        case .firstHalfFocus, .secondHalfFocus:
            return "You got this!"
        
        case .breakTime:
            return "Take a break"
            
        case .completed:
            return "FocusUp Session Completed!"
        }
    }
}
