//
//  ActiveStudySessionView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 9/9/2026.
//

import SwiftUI

struct ActiveStudySessionView: View {
    
    @Bindable var viewModel: FocusViewModel
    @Bindable var studentProgressViewModel: StudentProgressViewModel
    @Bindable var studyGoalViewModel: StudyGoalViewModel
    @Bindable var studyPlanViewModel: StudyPlanViewModel
    @Environment(\.dismiss) private var dismiss
    
    var selectedTask: AcademicTask? {
        guard let taskID = viewModel.activeSession?.academicTaskID else { return nil }
        
        return studyPlanViewModel.tasks.first {
            $0.id == taskID
        }
    }
    
    var selectedStudyGoal: StudyGoal? {
        guard let goalID = viewModel.activeSession?.studyGoalID else { return nil }
        
        return studyGoalViewModel.goals.first {
            $0.id == goalID
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text(phaseTitle)
                .font(.title2)
                .fontWeight(.semibold)
            
            if(viewModel.sessionPhase == .firstHalfFocus) {
                Text("~ First Half of Study Session ~")
                    .font(.title3)
            }
            
            if(viewModel.sessionPhase == .secondHalfFocus) {
                Text("~ Second Half of Study Session ~")
                    .font(.title3)
            }
            
            if viewModel.sessionPhase == .completed {
                VStack(spacing: 20) {
                    Text("Great Work! Your focusUp session is complete")
                        .foregroundStyle(.secondary)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size:40))
                }
                
                Spacer()
                
                Button("Done"){
                    if let session = viewModel.activeSession {
                        studentProgressViewModel.recordCompletedSession(
                            studyMinutes: session.focusMinutes
                        )
                    
                        if let goalID = session.studyGoalID {
                            studyGoalViewModel.addStudyMinutes(
                                session.focusMinutes,
                                to: goalID
                            )
                        }
                    }
                    viewModel.resetSession()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
                .font(.system(size: 20, weight: .bold))
                
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
                        if let task = selectedTask {
                            Text("Focus Task")
                            Spacer()
                            Text(task.taskTitle)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    HStack {
                        if let goal = selectedStudyGoal {
                            Text("Focus Goal")
                            Spacer()
                            Text(goal.goalTitle)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
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
        .navigationBarBackButtonHidden()
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

#Preview {
    ActiveStudySessionView(viewModel: FocusViewModel(), studentProgressViewModel: StudentProgressViewModel(), studyGoalViewModel: StudyGoalViewModel(), studyPlanViewModel: StudyPlanViewModel())
}
