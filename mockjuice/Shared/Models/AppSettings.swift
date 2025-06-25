//
//  AppSettings.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Foundation

@Observable
class AppSettings: Codable {
    var notifications: NotificationSettings
    var appearance: AppearanceSettings
    var study: StudySettings
    var privacy: PrivacySettings
    var accessibility: AccessibilitySettings
    
    init() {
        self.notifications = NotificationSettings()
        self.appearance = AppearanceSettings()
        self.study = StudySettings()
        self.privacy = PrivacySettings()
        self.accessibility = AccessibilitySettings()
    }
    
    enum CodingKeys: CodingKey {
        case notifications, appearance, study, privacy, accessibility
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        notifications = try container.decode(NotificationSettings.self, forKey: .notifications)
        appearance = try container.decode(AppearanceSettings.self, forKey: .appearance)
        study = try container.decode(StudySettings.self, forKey: .study)
        privacy = try container.decode(PrivacySettings.self, forKey: .privacy)
        accessibility = try container.decode(AccessibilitySettings.self, forKey: .accessibility)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(notifications, forKey: .notifications)
        try container.encode(appearance, forKey: .appearance)
        try container.encode(study, forKey: .study)
        try container.encode(privacy, forKey: .privacy)
        try container.encode(accessibility, forKey: .accessibility)
    }
}

struct NotificationSettings: Codable {
    var enablePushNotifications = true
    var dailyReminders = true
    var studyStreakAlerts = true
    var achievementNotifications = true
    var reminderTime = Date()
    var reminderFrequency = "Daily"
}

struct AppearanceSettings: Codable {
    var colorScheme = "System"
    var accentColor = "Blue"
    var reduceMotion = false
    var highContrast = false
    var fontSize: Double = 16.0
}

struct StudySettings: Codable {
    var autoPlay = true
    var hapticFeedback = true
    var soundEffects = true
    var sessionDuration: Double = 30.0 // minutes
    var difficultyLevel = "Adaptive"
    var showExplanations = true
    var trackProgress = true
}

struct PrivacySettings: Codable {
    var dataCollection = true
    var analytics = true
    var crashReporting = true
    var personalizedAds = false
    var shareProgress = true
}

struct AccessibilitySettings: Codable {
    var voiceOverEnabled = false
    var largeText = false
    var boldText = false
    var buttonShapes = false
    var reduceTransparency = false
    var smartInvert = false
} 