//
//  ActivityView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Charts

struct ActivityView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTimeframe = "Week"
    @State private var isRefreshing = false
    
    private let timeframes = ["Day", "Week", "Month", "Year"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Time frame selector
                    timeFrameSelector
                    
                    // Activity metrics grid
                    activityMetricsGrid
                    
                    // Progress chart
                    progressChart
                    
                    // Quick actions
                    quickActions
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .refreshable {
                await refreshActivity()
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export", systemImage: "square.and.arrow.up") {
                        HapticManager.shared.lightImpact()
                        appState.showToast(message: "Exporting activity data...")
                    }
                }
            }
        }
    }
    
    private var timeFrameSelector: some View {
        HStack(spacing: 0) {
            ForEach(timeframes, id: \.self) { timeframe in
                Button(action: {
                    HapticManager.shared.selection()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedTimeframe = timeframe
                    }
                }) {
                    Text(timeframe)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedTimeframe == timeframe ? Color.accentColor : .clear)
                        )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var activityMetricsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(appState.activities) { activity in
                ActivityMetricCard(activity: activity) {
                    HapticManager.shared.mediumImpact()
                    appState.showToast(message: "Viewing \(activity.title) details")
                }
            }
        }
    }
    
    private var progressChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.headline)
                .fontWeight(.semibold)
            
            Chart(WeeklyProgress.sampleData) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Progress", item.value)
                )
                .foregroundStyle(.blue.gradient)
                .cornerRadius(4)
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickActionButton(
                    title: "Start Practice",
                    icon: "play.circle.fill",
                    color: .green
                ) {
                    HapticManager.shared.mediumImpact()
                    appState.showToast(message: "Starting practice session...")
                }
                
                QuickActionButton(
                    title: "Take Mock Test",
                    icon: "doc.text.fill",
                    color: .blue
                ) {
                    HapticManager.shared.mediumImpact()
                    appState.showToast(message: "Loading mock test...")
                }
                
                QuickActionButton(
                    title: "Review Mistakes",
                    icon: "exclamationmark.triangle.fill",
                    color: .orange
                ) {
                    HapticManager.shared.mediumImpact()
                    appState.showToast(message: "Opening mistake review...")
                }
                
                QuickActionButton(
                    title: "Study Plan",
                    icon: "calendar.circle.fill",
                    color: .purple
                ) {
                    HapticManager.shared.mediumImpact()
                    appState.showToast(message: "Opening study plan...")
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    @MainActor
    private func refreshActivity() async {
        isRefreshing = true
        HapticManager.shared.lightImpact()
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        appState.showToast(message: "Activity data refreshed")
        isRefreshing = false
        HapticManager.shared.success()
    }
}

struct ActivityMetricCard: View {
    let activity: Activity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: activity.iconName)
                        .font(.title2)
                        .foregroundColor(colorForString(activity.color))
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: activity.isPositive ? "arrow.up" : "arrow.down")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text(activity.change)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(activity.isPositive ? .green : .red)
                }
                
                Text(activity.value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func colorForString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "blue": return .blue
        case "orange": return .orange
        case "green": return .green
        case "red": return .red
        case "purple": return .purple
        case "yellow": return .yellow
        default: return .blue
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ActivityView()
        .environment(AppState())
} 