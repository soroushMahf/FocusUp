//
//  StudyScheduleWidgetStore.swift
//  FocusUp
//
//  Created by Soroush Mahfoozi on 2/10/2026.
//

import Foundation
import WidgetKit

struct StudyScheduleWidgetStore {
    
    private let appGroupIdentifier = "group.com.SoroushMah.FocusUp"
    private let widgetDataKey = "studyScheduleWidgetData"
    
    func save(_ data: StudyScheduleWidgetData) {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier) else {
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(data) else {
            return
        }
        
        sharedDefaults.set(encoded, forKey: widgetDataKey)
        
        WidgetCenter.shared.reloadTimelines(ofKind: "FocusUpWidget")
    }
    
    func load() -> StudyScheduleWidgetData? {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier) else {
            return nil
        }
        
        guard let encodedData = sharedDefaults.data(forKey: widgetDataKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(
            StudyScheduleWidgetData.self,
            from: encodedData
        )
    }
    
    func clear() {
        UserDefaults(suiteName: appGroupIdentifier)?.removeObject(forKey: widgetDataKey)
        
        WidgetCenter.shared.reloadTimelines(ofKind: "FocusUpWidget")
    }
    
}
