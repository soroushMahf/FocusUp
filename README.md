GitHub Link: https://github.com/soroushMahf/FocusUp.git

# FocusUp

## Project Overview
FocusUp is an iOS application that helps university students organise academic tasks, plan study time and track their progress. Students can record assessment deadlines and estimated effort, enter their weekly availability, generate a study schedule and complete focus sessions linked to tasks and study goals.


## Domain Context
University students often balance several assessment deadlines alongside classes, employment and other commitments. Knowing when an assignment is due does not necessarily help them decide when to study or how much work remains.
FocusUp addresses this problem by connecting academic tasks with available study time. It generates planned study blocks and records completed study minutes, helping students identify their next action and retain progress when regenerating their schedule.


## Architecture Summary
FocusUp uses SwiftUI with MVVM, semantic domain models and a Use Case layer.
- **Views** present academic tasks, schedules, focus sessions, goals and progress.
- **ViewModels** coordinate user input and presentation state.
- **Use Cases** validate business rules for creating tasks and goals, managing availability, generating schedules and starting study sessions.
- **Repository protocols** abstract persistence for academic tasks, study goals, student progress, study availability and planned study blocks, allowing mock implementations in tests.
- **SwiftData repositories** perform database queries, convert between stored models and domain structs, and save changes.
- **SwiftData persistence models** store application data separately from domain structs.

The scheduling workflow follows:
**View → ViewModel → Use Case → Repository → SwiftData**

Core domain models include `AcademicTask`, `StudyAvailability`, `PlannedStudyBlock`, `StudySession`, `StudyGoal` and `StudentProgress`.

`PersistenceController` initialises the shared SwiftData container and exposes its main context. `AppDependencies` supplies that context to the repository implementations. Goal-creation tests use a mock repository instead of an in-memory SwiftData container.


## Chosen Extensions and Justification
### WidgetKit Extension
The Study Schedule widget displays the next planned task, subject, scheduled date and remaining study minutes. It supports small and medium Home Screen widget families.

This allows students to identify their next study activity without opening the app. The widget reads a shared snapshot from the App Group, and the main app requests a timeline reload when that snapshot is saved or cleared.

### Notification Content Extension
The notification extension displays the task title, subject and planned study duration when a study reminder is expanded.

This gives students meaningful context about the work they have scheduled. The main app schedules local notifications using the `STUDY_SESSION_REMINDER` category. Reminder times are calculated as 18:00 on the scheduled day minus the planned study duration.


## Database Choice
FocusUp uses SwiftData for local persistence. This supports offline access to study plans and progress without requiring a cloud account. SwiftData was approved by the tutor for this assessment.
The persistent models are:
- StoredAcademicTask
- StoredStudyGoal
- StoredStudentProgress
- StoredStudyAvailability
- StoredPlannedStudyBlock

Stored models remain separate from domain structs. Planned blocks reference academic tasks through academicTaskID; this association is managed through application logic.

The academic-task repository uses a SwiftData predicate to fetch incomplete tasks for scheduling. Other queries retrieve records by identifier and sort tasks or blocks by date.

Data persists between app launches. Cloud synchronisation and recovery after app deletion are not configured.


## App Group Identifier
`group.com.SoroushMah.FocusUp`

The main app and WidgetKit extension share this identifier. `StudyScheduleWidgetStore` saves a JSON-encoded snapshot in App Group `UserDefaults` under the key `studyScheduleWidgetData`.

The Notification Content Extension receives its data through the notification payload.


## Setup Instructions
1. Clone the [FocusUp repository](https://github.com/soroushMahf/FocusUp) or extract the submitted project ZIP.
2. Open `FocusUp.xcodeproj` in Xcode.
3. Use an Xcode installation and simulator/device compatible with the configured deployment targets. The supplied project targets iOS 26.5, with extension targets set to iOS 27.0.
4. Select your development team for the main app and both extension targets. Adjust bundle identifiers if required for signing.
5. Ensure the main app and widget extension have the same App Group enabled. If changing its identifier, update both entitlements and `StudyScheduleWidgetStore`.
6. Select the **FocusUp** scheme and a compatible iPhone simulator or device, then build and run.
7. Allow notifications when prompted.
8. Create an academic task with a future deadline and estimated study time. Open **Schedule**, set sufficient weekly availability and confirm to generate study blocks.
9. Add the **Study Schedule** widget to the Home Screen in either supported size.
10. Expand a delivered study reminder to view its custom content. Reminders are scheduled only when their calculated delivery time is still in the future.
