//
//  FocusViewModel.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 9/9/2026.
//

import Foundation

@Observable
@MainActor
final class FocusViewModel {
    
    var selectedTask: AcademicTask?
    var selectedStudyGoal: StudyGoal?
    var selectedStudyBlock: PlannedStudyBlock?
    
    var focusMinutes: Int = 60
    var breakMinutes: Int = 5
    
    var completedFocusSeconds: Int = 0
    
    var remainingSeconds: Int = 0
    var isTimerRunning: Bool = false
    
    private var timer: Timer?
    
    var activeSession: StudySession?
    var errorMessage: String?
    
    var sessionPhase: StudySessionPhase = .firstHalfFocus
    
    var firstHalfFocusSeconds: Int {
        (focusMinutes * 60) / 2
    }
    
    var secondHalfFocusSeconds: Int {
        (focusMinutes * 60) - firstHalfFocusSeconds
    }
    
    var completedFocusMinutes: Int {
        completedFocusSeconds / 60
    }
    
    var progress = StudentProgress()
    
    private let startStudySessionUseCase = StartStudySessionUseCase()
    
    func startStudySession() -> Bool {
        do {
            activeSession = try startStudySessionUseCase.execute(
                academicTaskID: selectedTask?.id,
                studyGoalID: selectedStudyGoal?.id,
                focusMinutes: focusMinutes,
                breakMinutes: breakMinutes
            )
            
            sessionPhase = .firstHalfFocus
            
            remainingSeconds = firstHalfFocusSeconds
            
            completedFocusSeconds = 0
            
            startTimer()
            
            errorMessage = nil
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        isTimerRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self else { return }
                
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                    
                    if self.sessionPhase == .firstHalfFocus || self.sessionPhase == .secondHalfFocus {
                        self.completedFocusSeconds += 1
                    }
                    
                } else {
                    self.moveToNextPhase()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    var formattedRemainingTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        
        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    func resumeTimer() {
        guard !isTimerRunning else { return }
        
        startTimer()
    }
    
    private func moveToNextPhase(){
        switch sessionPhase {
            
        case .firstHalfFocus:
            if breakMinutes > 0 {
                sessionPhase = .breakTime
                remainingSeconds = breakMinutes * 60
            } else {
                sessionPhase = .secondHalfFocus
                remainingSeconds = secondHalfFocusSeconds
            }
            
        case .breakTime:
            sessionPhase = .secondHalfFocus
            remainingSeconds = secondHalfFocusSeconds
            
        case .secondHalfFocus:
            completeSession()
            
        case .completed:
            stopTimer()
        }
    }
    
    func skipBreak() {
        guard sessionPhase == .breakTime else { return }
        
        sessionPhase = .secondHalfFocus
        remainingSeconds = secondHalfFocusSeconds
    }
    
    private func completeSession() {
        stopTimer()
        sessionPhase = .completed
        remainingSeconds = 0
        
        activeSession?.studyCompletedAt = Date()
    }
    
    func endSessionEarly() {
        stopTimer()
        remainingSeconds = 0
        sessionPhase = .completed
        
        activeSession?.studyCompletedAt = Date()
    }
    
    func resetSession() {
        activeSession = nil
        remainingSeconds = 0
        completedFocusSeconds = 0
        sessionPhase = .firstHalfFocus
        isTimerRunning = false
    }
    
    // Study Block function
    func prepareForScheduledStudy(block: PlannedStudyBlock, task: AcademicTask) {
        selectedStudyBlock = block
        selectedTask = task
        focusMinutes = block.plannedStudyMinutes - block.completedStudyMinutes
    }
}
