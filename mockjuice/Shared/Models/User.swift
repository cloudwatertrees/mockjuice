//
//  User.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Foundation

struct User: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var profileImageName: String?
    var joinDate: Date
    var totalPoints: Int
    var level: Int
    var achievements: [String]
    var preferences: UserPreferences
    
    static let sample = User(
        name: "John Doe",
        email: "john.doe@example.com",
        profileImageName: nil,
        joinDate: Date().addingTimeInterval(-86400 * 30), // 30 days ago
        totalPoints: 1250,
        level: 5,
        achievements: ["First Steps", "Quick Learner", "Consistency"],
        preferences: UserPreferences.default
    )
}

struct UserPreferences: Codable {
    var enableNotifications: Bool
    var hapticFeedback: Bool
    var autoSync: Bool
    var theme: String
    
    static let `default` = UserPreferences(
        enableNotifications: true,
        hapticFeedback: true,
        autoSync: true,
        theme: "System"
    )
} 