//
//  FocusUpWidget.swift
//  FocusUpWidget
//
//  Created by Soroush Mahfoozi on 2/10/2026.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    private let widgetStore = StudyScheduleWidgetStore()
    
    func placeholder(in context: Context) -> StudyScheduleEntry {
        StudyScheduleEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            studySchedule: StudyScheduleWidgetData(
                taskTitle: "Complete Assessment",
                subjectName: "Advanced iOS Dev",
                scheduledDate: Date(),
                remainingStudyMinutes: 67
            )
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> StudyScheduleEntry {
        let previewData = StudyScheduleWidgetData(
            taskTitle: "Complete Assessment",
            subjectName: "Advanced iOS Dev",
            scheduledDate: Date(),
            remainingStudyMinutes: 67
        )
        
        return StudyScheduleEntry(
            date: Date(),
            configuration: configuration,
            studySchedule: context.isPreview ? previewData : widgetStore.load()
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<StudyScheduleEntry> {
        
        let entry = StudyScheduleEntry(
            date: Date(),
            configuration: configuration,
            studySchedule: widgetStore.load()
        )
        
        return Timeline(entries: [entry], policy: .never)
    }
}

struct StudyScheduleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let studySchedule: StudyScheduleWidgetData?
}

struct FocusUpWidgetEntryView : View {
    var entry: StudyScheduleEntry
    
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if let studySchedule = entry.studySchedule {
            switch widgetFamily {
            case .systemMedium:
                mediumWidget(studySchedule)
            
            default:
                smallWidget(studySchedule)
            }
            
        } else {
            emptyWidget
        }
    }
    
    private func smallWidget(_ studySchedule: StudyScheduleWidgetData) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Next Study Session")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(studySchedule.taskTitle)
                .font(.headline)
                .lineLimit(2)
            
            Text(studySchedule.subjectName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text("\(studySchedule.remainingStudyMinutes) min remaining")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(
                studySchedule.scheduledDate,
                format: .dateTime.weekday().day().month().year()
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
    private func mediumWidget(_ studySchedule: StudyScheduleWidgetData) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Next Study Session")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(studySchedule.taskTitle)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(studySchedule.subjectName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Label(
                    "\(studySchedule.scheduledDate, format: .dateTime.weekday().day().month().year())",
                    systemImage: "calendar"
                )
                .font(.headline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Image(systemName: "timer")
                    .font(.title2)
                
                Spacer()
                
                Text("\(studySchedule.remainingStudyMinutes)")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("min remaining")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var emptyWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.title2)
            
            Text("No Upcoming Study")
                .font(.headline)
            
            Text("Generate a study schedule in FocusUp.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct FocusUpWidget: Widget {
    let kind: String = "FocusUpWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            FocusUpWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Study Schedule")
        .description("See your next planned FocusUp study session.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

// previews of all supported widget sizes alongside the empty widgets
#Preview("Small", as: .systemSmall) {
    FocusUpWidget()
} timeline: {
    StudyScheduleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        studySchedule: StudyScheduleWidgetData(
            taskTitle: "Complete Assignment",
            subjectName: "Advanced iOS",
            scheduledDate: .now,
            remainingStudyMinutes: 60
        )
    )
}

#Preview("Medium", as: .systemMedium) {
    FocusUpWidget()
} timeline: {
    StudyScheduleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        studySchedule: StudyScheduleWidgetData(
            taskTitle: "Complete Assignment",
            subjectName: "Advanced iOS",
            scheduledDate: .now,
            remainingStudyMinutes: 60
        )
    )
}

#Preview("Small (Empty)", as: .systemSmall) {
    FocusUpWidget()
} timeline: {
    StudyScheduleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        studySchedule: nil
    )
}

#Preview("Medium (Empty)", as: .systemMedium) {
    FocusUpWidget()
} timeline: {
    StudyScheduleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        studySchedule: nil
    )
}
