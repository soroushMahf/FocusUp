//
//  StudyNotificationService.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 3/10/2026.
//

import Foundation
import UserNotifications

@MainActor
final class StudyNotificationService {
    
    private let hoursBeforeMidnight = 6 // constant that's used to notify user at a specific time
    
    // permission handling for notifications
    func requestPermission() async {
        let settings = await UNUserNotificationCenter.current()
            .notificationSettings()
        
        guard settings.authorizationStatus == .notDetermined else {
            return
        }
        
        do {
            try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification permission erorr: \(error.localizedDescription)")
        }
    }
    
    func registerStudyReminderCategory() {
        let category = UNNotificationCategory(
            identifier: "STUDY_SESSION_REMINDER",
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current()
            .setNotificationCategories([category])
    }
    
    // calculating the reminder time for the notification
    private func reminderDate(for scheduledDate: Date, studyMinutes: Int) -> Date? {
        
        let calendar = Calendar.current
        
        // calculating the date value for next day
        guard let nextDay = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: scheduledDate)
        ) else {
            return nil
        }
        
        // subtracting 6 hours from midnight for the base reminder time
        guard let baseReminderDate = calendar.date(
            byAdding: .hour,
            value: -hoursBeforeMidnight,
            to: nextDay
        ) else {
            return nil
        }
        
        // the reminder time is derived by subtracing the
        // studyMinutes from the time 6 hours before midnight
        return calendar.date(
            byAdding: .minute,
            value: -studyMinutes,
            to: baseReminderDate
        )
    }
    
    // scheduling method
    func scheduleStudyReminder(taskTitle: String, subjectName: String, studyMinutes: Int, scheduledDate: Date) async throws {
        
        guard let reminderDate = reminderDate(
            for: scheduledDate,
            studyMinutes: studyMinutes
        ) else {
            return
        }
        
        guard reminderDate > Date() else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Study"
        content.body = "\(taskTitle) - \(subjectName)"
        content.sound = .default
        content.categoryIdentifier = "STUDY_SESSION_REMINDER"
        
        content.userInfo = [
            "taskTitle": taskTitle,
            "subjectName": subjectName,
            "studyMinutes": studyMinutes
        ]
        
        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminderDate
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        try await UNUserNotificationCenter.current().add(request)
    }
    
    func removeAllStudyReminders() {
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }
}
