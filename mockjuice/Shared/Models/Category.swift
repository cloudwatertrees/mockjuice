//
//  Category.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Foundation

struct Category: Identifiable, Codable {
    let id = UUID()
    var title: String
    var subtitle: String
    var iconName: String
    var color: String
    var itemCount: Int
    var isNew: Bool
    var items: [CategoryItem]
    
    static let sampleData: [Category] = [
        Category(
            title: "Theory Test Fundamentals",
            subtitle: "Master the essential knowledge for your theory test",
            iconName: "book.fill",
            color: "green",
            itemCount: 850,
            isNew: false,
            items: CategoryItem.theoryItems
        ),
        Category(
            title: "Hazard Perception Training",
            subtitle: "Develop your hazard spotting skills with interactive videos",
            iconName: "eye.fill",
            color: "red",
            itemCount: 45,
            isNew: true,
            items: CategoryItem.hazardItems
        ),
        Category(
            title: "Highway Code Mastery",
            subtitle: "Complete guide to UK traffic rules and regulations",
            iconName: "road.lanes",
            color: "blue",
            itemCount: 320,
            isNew: false,
            items: CategoryItem.highwayItems
        ),
        Category(
            title: "Road Signs Expert",
            subtitle: "Learn and recognize all UK road signs",
            iconName: "triangle.fill",
            color: "orange",
            itemCount: 180,
            isNew: false,
            items: CategoryItem.signItems
        ),
        Category(
            title: "The MockJuice Experience",
            subtitle: "Premium practice tests with detailed explanations",
            iconName: "checkmark.seal.fill",
            color: "red",
            itemCount: 25,
            isNew: true,
            items: CategoryItem.mockItems
        )
    ]
}

struct CategoryItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var difficulty: String
    var duration: String
    var isCompleted: Bool
    
    static let theoryItems: [CategoryItem] = [
        CategoryItem(title: "Rules of the Road", description: "Basic traffic rules and regulations", difficulty: "Beginner", duration: "15 min", isCompleted: true),
        CategoryItem(title: "Vehicle Safety", description: "Safety checks and maintenance", difficulty: "Intermediate", duration: "20 min", isCompleted: false),
        CategoryItem(title: "Vulnerable Road Users", description: "Pedestrians, cyclists, and motorcyclists", difficulty: "Advanced", duration: "25 min", isCompleted: false)
    ]
    
    static let hazardItems: [CategoryItem] = [
        CategoryItem(title: "Urban Scenarios", description: "City driving hazards", difficulty: "Intermediate", duration: "10 min", isCompleted: true),
        CategoryItem(title: "Rural Roads", description: "Country road challenges", difficulty: "Advanced", duration: "12 min", isCompleted: false)
    ]
    
    static let highwayItems: [CategoryItem] = [
        CategoryItem(title: "Traffic Signs", description: "Understanding road signage", difficulty: "Beginner", duration: "18 min", isCompleted: true),
        CategoryItem(title: "Lane Discipline", description: "Proper lane usage", difficulty: "Intermediate", duration: "22 min", isCompleted: false)
    ]
    
    static let signItems: [CategoryItem] = [
        CategoryItem(title: "Warning Signs", description: "Yellow triangular signs", difficulty: "Beginner", duration: "12 min", isCompleted: true),
        CategoryItem(title: "Mandatory Signs", description: "Blue circular signs", difficulty: "Intermediate", duration: "15 min", isCompleted: false)
    ]
    
    static let mockItems: [CategoryItem] = [
        CategoryItem(title: "Full Mock Test 1", description: "50 questions, 57 minutes", difficulty: "Advanced", duration: "57 min", isCompleted: false),
        CategoryItem(title: "Quick Practice", description: "10 questions, 12 minutes", difficulty: "Beginner", duration: "12 min", isCompleted: true)
    ]
} 