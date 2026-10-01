//
//  StudyAvailabilityView.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 1/10/2026.
//

import SwiftUI

struct StudyAvailabilityView: View {
    
    @Bindable var viewModel: StudyAvailabilityViewModel
    
    var body: some View {
        Form {
            Section {
                Text("Set how much time you usually have available to study each day. FocusUp will use this when creating your study plan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Section("Weekly Availability") {
                ForEach(Weekday.allCases, id: \.self) { weekday in
                    Picker(
                        weekday.rawValue,
                        selection: Binding(
                            get: { viewModel.availability(for: weekday)},
                            set: { newValue in viewModel.setAvailability(for: weekday, minutes: newValue) }
                        )
                    ) {
                        Text("Unavailable")
                            .tag(0)
                        
                        ForEach(
                            stride(from: 30, through: 720, by: 30).map{ $0 },
                            id: \.self
                        ) { minutes in
                            Text(formatStudyTime(minutes))
                                .tag(minutes)
                        }
                    }
                }
            }
        }
        .navigationTitle("Study Availability")
        .alert(
            "Unable to Update Availability",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private func formatStudyTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours == 0 {
            return "\(remainingMinutes) min"
        } else {
            return "\(hours) hr \(remainingMinutes) min"
        }
    }
}

#Preview {
    NavigationStack{
        StudyAvailabilityView(
            viewModel: StudyAvailabilityViewModel(
                repository: PreviewStudyAvailabilityRepository()
            )
        )
    }
}

//remove later, just for preview
@MainActor
final class PreviewStudyAvailabilityRepository: StudyAvailabilityRepository {
    
    private var availability: [StudyAvailability] = [
        StudyAvailability(
            weekday: .monday,
            availableStudyMinutes: 120
        ),
        StudyAvailability(
            weekday: .tuesday,
            availableStudyMinutes: 60
        ),
        StudyAvailability(
            weekday: .wednesday,
            availableStudyMinutes: 0
        ),
        StudyAvailability(
            weekday: .thursday,
            availableStudyMinutes: 90
        ),
        StudyAvailability(
            weekday: .friday,
            availableStudyMinutes: 120
        ),
        StudyAvailability(
            weekday: .saturday,
            availableStudyMinutes: 240
        ),
        StudyAvailability(
            weekday: .sunday,
            availableStudyMinutes: 180
        )
    ]
    
    func saveAvailability(_ studyAvailability: StudyAvailability) throws {
        availability.append(studyAvailability)
    }
    
    func fetchWeeklyAvailability() throws -> [StudyAvailability] {
        availability
    }
    
    func updateAvailability(_ studyAvailability: StudyAvailability) throws {
        guard let index = availability.firstIndex(
            where: { $0.id == studyAvailability.id }
        ) else {
            return
        }
        
        availability[index] = studyAvailability
    }
    
    func deleteAvailability(_ studyAvailability: StudyAvailability) throws {
        availability.removeAll {
            $0.id == studyAvailability.id
        }
    }
}
