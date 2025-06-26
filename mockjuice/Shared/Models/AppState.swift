//
//  AppState.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Foundation

@Observable
class AppState {
    var selectedTab: Tab = .browse
    var colorScheme: ColorScheme? = nil
    var isLoading = false
    var showToast = false
    var toastMessage = ""
    var searchText = ""
    
    // User data
    var user = User.sample
    var categories: [Category] = Category.sampleData
    var activities: [Activity] = Activity.sampleData
    var summaryData = SummaryData.sample
    var settings = AppSettings()
    
    init() {
        setupInitialData()
    }
    
    private func setupInitialData() {
        // Initialize any required data
    }
    
    func showToast(message: String) {
        toastMessage = message
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.showToast = false
            }
        }
    }
    
    func updateColorScheme(_ scheme: ColorScheme?) {
        withAnimation(.easeInOut(duration: 0.3)) {
            colorScheme = scheme
        }
    }
}

enum Tab: String, CaseIterable {
    case browse = "Practice"
    case activity = "Progress"
    case summary = "Challenges"
    case discover = "Discover"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .browse: return "play.fill"
        case .activity: return "chart.line.uptrend.xyaxis"
        case .summary: return "target"
        case .discover: return "safari.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var badgeCount: Int? {
        switch self {
        case .activity: return 3
        case .summary: return 2
        default: return nil
        }
    }
} 