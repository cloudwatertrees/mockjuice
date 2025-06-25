//
//  SummaryData.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Foundation

struct SummaryData: Codable {
    var totalStudyTime: TimeInterval
    var questionsAnswered: Int
    var averageScore: Double
    var testsCompleted: Int
    var currentStreak: Int
    var longestStreak: Int
    var weakAreas: [WeakArea]
    var recentAchievements: [Achievement]
    var monthlyProgress: [MonthlyProgress]
    var lastUpdated: Date
    
    static let sample = SummaryData(
        totalStudyTime: 45300, // 12.58 hours
        questionsAnswered: 1247,
        averageScore: 84.5,
        testsCompleted: 15,
        currentStreak: 12,
        longestStreak: 28,
        weakAreas: WeakArea.sampleData,
        recentAchievements: Achievement.recentSample,
        monthlyProgress: MonthlyProgress.sampleData,
        lastUpdated: Date()
    )
}

struct WeakArea: Identifiable, Codable {
    let id = UUID()
    var topic: String
    var score: Double
    var questionsAttempted: Int
    var improvementTip: String
    
    static let sampleData: [WeakArea] = [
        WeakArea(
            topic: "Vulnerable Road Users",
            score: 65.0,
            questionsAttempted: 23,
            improvementTip: "Focus on pedestrian crossing scenarios"
        ),
        WeakArea(
            topic: "Vehicle Safety Checks",
            score: 71.0,
            questionsAttempted: 18,
            improvementTip: "Review tire and brake inspection procedures"
        ),
        WeakArea(
            topic: "Motorway Rules",
            score: 78.0,
            questionsAttempted: 31,
            improvementTip: "Practice lane changing and merging scenarios"
        )
    ]
}

struct Achievement: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var iconName: String
    var earnedDate: Date
    var points: Int
    
    static let recentSample: [Achievement] = [
        Achievement(
            title: "Quick Learner",
            description: "Answered 50 questions in one session",
            iconName: "bolt.fill",
            earnedDate: Date().addingTimeInterval(-86400),
            points: 100
        ),
        Achievement(
            title: "Consistency",
            description: "Studied for 7 consecutive days",
            iconName: "calendar",
            earnedDate: Date().addingTimeInterval(-172800),
            points: 150
        )
    ]
}

struct MonthlyProgress: Identifiable, Codable {
    let id = UUID()
    var month: String
    var questionsAnswered: Int
    var averageScore: Double
    var studyHours: Double
    
    static let sampleData: [MonthlyProgress] = [
        MonthlyProgress(month: "Jan", questionsAnswered: 245, averageScore: 78.5, studyHours: 15.2),
        MonthlyProgress(month: "Feb", questionsAnswered: 298, averageScore: 81.2, studyHours: 18.7),
        MonthlyProgress(month: "Mar", questionsAnswered: 356, averageScore: 83.8, studyHours: 22.1),
        MonthlyProgress(month: "Apr", questionsAnswered: 289, averageScore: 85.1, studyHours: 19.8),
        MonthlyProgress(month: "May", questionsAnswered: 412, averageScore: 87.3, studyHours: 25.4),
        MonthlyProgress(month: "Jun", questionsAnswered: 347, averageScore: 84.9, studyHours: 21.6)
    ]
} 