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
    
    var studyScheduleViewModel: StudyScheduleViewModel?
    
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
                Text("First Half of Study Session")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            if(viewModel.sessionPhase == .secondHalfFocus) {
                Text("~ Second Half of Study Session ~")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            if viewModel.sessionPhase == .completed {
                VStack(spacing: 16) {
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.green)
                    
                    Text("Great Work!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("You've completed your FocusUp Session")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                        
                    VStack(spacing: 4) {
                        Text("\(viewModel.completedFocusMinutes)")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                        
                        Text("minutes focused")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                    
                    VStack(spacing: 16) {
                        
                        if let task = selectedTask {
                            HStack{
                                Label("Task", systemImage: "checklist")
                                
                                Spacer()
                                
                                Text(task.taskTitle)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if let goal = selectedStudyGoal {
                            VStack(spacing: 4) {
                                HStack {
                                    Label("Goal", systemImage: "target")
                                    
                                    Spacer()
                                    
                                    Text(goal.goalTitle)
                                        .foregroundStyle(.secondary)
                                }
                                
                                HStack {
                                    Spacer()
                                    
                                    Text("+\(viewModel.completedFocusMinutes) min contributed")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Spacer()
                
                Button("Done"){
                    if let session = viewModel.activeSession {
                        
                        let completedMinutes = viewModel.completedFocusMinutes
                        
                        if completedMinutes > 0 {
                            
                            // update overall student progress
                            studentProgressViewModel.recordCompletedSession(
                                studyMinutes: completedMinutes
                            )
                            
                            // update the selected study goal
                            if let goalID = session.studyGoalID {
                                studyGoalViewModel.addStudyMinutes(
                                    completedMinutes,
                                    to: goalID
                                )
                            }
                            
                            // update study progress for the academic task
                            if let taskID = session.academicTaskID {
                                studyPlanViewModel.addStudyMinutes(completedMinutes, to: taskID)
                            }
                            
                            // update the scheduled study block of this sessions
                            // was started from study schedule
                            if let block = viewModel.selectedStudyBlock {
                                studyScheduleViewModel?.recordStudyProgress(
                                    for: block,
                                    completedMinutes: completedMinutes
                                )
                            }
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
                    .monospacedDigit()
                    .padding(.vertical, 30)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            if let session = viewModel.activeSession, viewModel.sessionPhase != .completed {
                if viewModel.sessionPhase == .breakTime {
                    Label(
                        "Stretch - Hydrate - Rest",
                        systemImage: "cup.and.head.waves"
                    )
                    .foregroundStyle(.secondary)
                } else {
                    VStack(spacing: 16) {
                        if let task = selectedTask {
                            HStack {
                                Label("Focus Task", systemImage: "checklist")
                                Spacer()
                                Text(task.taskTitle)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if let goal = selectedStudyGoal {
                            HStack {
                                Label("Focus Goal", systemImage: "target")
                                Spacer()
                                Text(goal.goalTitle)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        HStack {
                            Label("Focus Duration", systemImage: "timer")
                            Spacer()
                            Text("\(session.focusMinutes) min")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Label("Break Duration", systemImage: "cup.and.heat.waves")
                            Spacer()
                            Text("\(session.breakMinutes) min")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
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
        .toolbar(.hidden, for: .tabBar)
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
    ActiveStudySessionView(
        viewModel: FocusViewModel(),
        studentProgressViewModel: StudentProgressViewModel(),
        studyGoalViewModel: StudyGoalViewModel(),
        studyPlanViewModel: StudyPlanViewModel(
            repository: SwiftDataAcademicTaskRepository()),
        studyScheduleViewModel: nil
    )
}
