//
//  NotificationViewController.swift
//  FocusUpNotification
//
//  Created by Soroush Mahfoozi on 3/10/2026.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var studyMinutesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        
        if let taskTitle = userInfo["taskTitle"] as? String {
            taskTitleLabel.text = taskTitle
        }
        
        if let subjectName = userInfo["subjectName"] as? String {
            subjectNameLabel.text = subjectName
        }
        
        if let studyMinutes = userInfo["studyMinutes"] as? Int {
            studyMinutesLabel.text = "\(studyMinutes) min planned"
        }
    }

}
