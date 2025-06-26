//
//  Activity.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Foundation

struct Activity: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var iconName: String
    var color: String
    var value: String
    var change: String
    var isPositive: Bool
    var date: Date
    
    static let sampleData: [Activity] = [
        Activity(
            title: "Theory Mastery",
            description: "Questions conquered today",
            iconName: "brain.head.profile",
            color: "blue",
            value: "47",
            change: "+12",
            isPositive: true,
            date: Date()
        ),
        Activity(
            title: "Learning Time",
            description: "Minutes in the mockjuice zone",
            iconName: "clock.fill",
            color: "green",
            value: "2h 15m",
            change: "+45m",
            isPositive: true,
            date: Date()
        ),
        Activity(
            title: "Success Rate",
            description: "Your mockjuice accuracy",
            iconName: "target",
            color: "orange",
            value: "84%",
            change: "-3%",
            isPositive: false,
            date: Date()
        ),
        Activity(
            title: "Learning Streak",
            description: "Days of consistent progress",
            iconName: "flame.fill",
            color: "red",
            value: "12",
            change: "+1",
            isPositive: true,
            date: Date()
        ),
        Activity(
            title: "MockJuice Tests",
            description: "Premium tests completed",
            iconName: "checkmark.seal.fill",
            color: "purple",
            value: "3",
            change: "+2",
            isPositive: true,
            date: Date()
        ),
        Activity(
            title: "Juice Points",
            description: "Your mockjuice rewards",
            iconName: "star.fill",
            color: "yellow",
            value: "1,250",
            change: "+85",
            isPositive: true,
            date: Date()
        )
    ]
}

struct WeeklyProgress: Identifiable {
    let id = UUID()
    var day: String
    var value: Double
    
    static let sampleData: [WeeklyProgress] = [
        WeeklyProgress(day: "Mon", value: 45),
        WeeklyProgress(day: "Tue", value: 67),
        WeeklyProgress(day: "Wed", value: 32),
        WeeklyProgress(day: "Thu", value: 89),
        WeeklyProgress(day: "Fri", value: 76),
        WeeklyProgress(day: "Sat", value: 54),
        WeeklyProgress(day: "Sun", value: 43)
    ]
} 