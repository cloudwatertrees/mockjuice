//
//  SummaryView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import Charts

struct SummaryView: View {
    @Environment(AppState.self) private var appState
    @State private var isRefreshing = false
    @State private var showingDetailSheet = false
    @State private var selectedWeakArea: WeakArea?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Overall stats
                    overallStatsSection
                    
                    // Monthly progress chart
                    monthlyProgressChart
                    
                    // Weak areas
                    weakAreasSection
                    
                    // Recent achievements
                    recentAchievementsSection
                    
                    // Last updated info
                    lastUpdatedSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .refreshable {
                await refreshSummary()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Share Progress", systemImage: "square.and.arrow.up") {
                            HapticManager.shared.lightImpact()
                            appState.showToast(message: "Sharing progress...")
                        }
                        
                        Button("Export Data", systemImage: "doc.text") {
                            HapticManager.shared.lightImpact()
                            appState.showToast(message: "Exporting data...")
                        }
                        
                        Button("View Detailed Report", systemImage: "chart.bar.doc.horizontal") {
                            HapticManager.shared.lightImpact()
                            showingDetailSheet = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingDetailSheet) {
                DetailedReportView()
            }
        }
    }
    
    private var overallStatsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Study Time",
                value: formatTime(appState.summaryData.totalStudyTime),
                icon: "clock.fill",
                color: .blue
            )
            
            StatCard(
                title: "Questions",
                value: "\(appState.summaryData.questionsAnswered)",
                icon: "questionmark.circle.fill",
                color: .green
            )
            
            StatCard(
                title: "Average Score",
                value: "\(Int(appState.summaryData.averageScore))%",
                icon: "target",
                color: .orange
            )
            
            StatCard(
                title: "Current Streak",
                value: "\(appState.summaryData.currentStreak) days",
                icon: "flame.fill",
                color: .red
            )
        }
    }
    
    private var monthlyProgressChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Monthly Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View Details") {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Opening detailed view...")
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
            
            Chart(appState.summaryData.monthlyProgress) { progress in
                LineMark(
                    x: .value("Month", progress.month),
                    y: .value("Score", progress.averageScore)
                )
                .foregroundStyle(.blue.gradient)
                .symbol(Circle().strokeBorder(lineWidth: 2))
                
                AreaMark(
                    x: .value("Month", progress.month),
                    y: .value("Score", progress.averageScore)
                )
                .foregroundStyle(.blue.gradient.opacity(0.1))
            }
            .frame(height: 180)
            .chartYScale(domain: 70...90)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let score = value.as(Double.self) {
                            Text("\(Int(score))%")
                        }
                    }
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
    
    private var weakAreasSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Areas for Improvement")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Practice All") {
                    HapticManager.shared.mediumImpact()
                    appState.showToast(message: "Starting focused practice...")
                }
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.accentColor))
            }
            
            LazyVStack(spacing: 12) {
                ForEach(appState.summaryData.weakAreas) { weakArea in
                    WeakAreaCard(weakArea: weakArea) {
                        HapticManager.shared.lightImpact()
                        selectedWeakArea = weakArea
                        appState.showToast(message: "Focus on: \(weakArea.improvementTip)")
                    }
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
    
    private var recentAchievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Opening achievements...")
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(appState.summaryData.recentAchievements) { achievement in
                    AchievementCard(achievement: achievement)
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
    
    private var lastUpdatedSection: some View {
        HStack {
            Image(systemName: "clock")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Last updated \(formatLastUpdated(appState.summaryData.lastUpdated))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button("Sync Now") {
                Task {
                    await refreshSummary()
                }
            }
            .font(.caption)
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal, 20)
    }
    
    @MainActor
    private func refreshSummary() async {
        isRefreshing = true
        HapticManager.shared.lightImpact()
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Update last updated time
        appState.summaryData.lastUpdated = Date()
        
        appState.showToast(message: "Summary refreshed")
        isRefreshing = false
        HapticManager.shared.success()
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    private func formatLastUpdated(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct WeakAreaCard: View {
    let weakArea: WeakArea
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Score indicator
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: weakArea.score / 100)
                        .stroke(scoreColor, lineWidth: 3)
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(weakArea.score))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(weakArea.topic)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(weakArea.improvementTip)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text("\(weakArea.questionsAttempted) questions attempted")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var scoreColor: Color {
        if weakArea.score >= 80 {
            return .green
        } else if weakArea.score >= 60 {
            return .orange
        } else {
            return .red
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.iconName)
                .font(.title2)
                .foregroundColor(.yellow)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(.yellow.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("+\(achievement.points)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.yellow)
                
                Text(formatDate(achievement.earnedDate))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailedReportView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Detailed report content would go here")
                        .font(.title2)
                        .padding()
                }
            }
            .navigationTitle("Detailed Report")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SummaryView()
        .environment(AppState())
} 