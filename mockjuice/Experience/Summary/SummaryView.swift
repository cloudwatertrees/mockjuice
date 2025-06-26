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
                    // Daily challenges
                    dailyChallengesSection
                    
                    // Weekly challenges
                    weeklyChallengesSection
                    
                    // Achievement progress
                    achievementProgressSection
                    
                    // Leaderboard preview
                    leaderboardSection
                    
                    // Last updated info
                    lastUpdatedSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .refreshable {
                await refreshSummary()
            }
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Share Achievements", systemImage: "square.and.arrow.up") {
                            HapticManager.shared.lightImpact()
                            appState.showToast(message: "Sharing your mockjuice victories...")
                        }
                        
                        Button("Challenge Friends", systemImage: "person.2") {
                            HapticManager.shared.lightImpact()
                            appState.showToast(message: "Inviting friends to compete...")
                        }
                        
                        Button("View All Challenges", systemImage: "target") {
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
        
        appState.showToast(message: "Challenges refreshed")
        isRefreshing = false
        HapticManager.shared.success()
    }
    
    // MARK: - Challenge Sections
    
    private var dailyChallengesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today's Challenges")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("2/3 Complete")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.green.opacity(0.1)))
            }
            
            LazyVStack(spacing: 12) {
                ChallengeCard(
                    title: "Theory Sprint",
                    description: "Answer 20 questions correctly",
                    progress: 15,
                    total: 20,
                    reward: "50 Juice Points",
                    icon: "brain.head.profile",
                    color: .blue,
                    isCompleted: false
                )
                
                ChallengeCard(
                    title: "Perfect Streak",
                    description: "Get 5 answers in a row correct",
                    progress: 5,
                    total: 5,
                    reward: "25 Juice Points",
                    icon: "flame.fill",
                    color: .orange,
                    isCompleted: true
                )
                
                ChallengeCard(
                    title: "Hazard Master",
                    description: "Complete a hazard perception test",
                    progress: 1,
                    total: 1,
                    reward: "75 Juice Points",
                    icon: "eye.fill",
                    color: .red,
                    isCompleted: true
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var weeklyChallengesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weekly Challenges")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("3 days left")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            LazyVStack(spacing: 12) {
                ChallengeCard(
                    title: "MockJuice Champion",
                    description: "Complete 3 full mock tests",
                    progress: 2,
                    total: 3,
                    reward: "200 Juice Points + Badge",
                    icon: "checkmark.seal.fill",
                    color: .purple,
                    isCompleted: false
                )
                
                ChallengeCard(
                    title: "Learning Marathon",
                    description: "Study for 10 hours this week",
                    progress: 7,
                    total: 10,
                    reward: "150 Juice Points",
                    icon: "clock.fill",
                    color: .green,
                    isCompleted: false
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var achievementProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievement Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Opening achievement gallery...")
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
            
            LazyVStack(spacing: 12) {
                AchievementProgressCard(
                    title: "Theory Titan",
                    description: "Answer 1000 theory questions",
                    progress: 750,
                    total: 1000,
                    icon: "brain.head.profile",
                    color: .blue
                )
                
                AchievementProgressCard(
                    title: "Streak Superstar",
                    description: "Maintain a 30-day learning streak",
                    progress: 12,
                    total: 30,
                    icon: "flame.fill",
                    color: .orange
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Leaderboard")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View Full") {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Opening full leaderboard...")
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
            
            VStack(spacing: 8) {
                LeaderboardRow(rank: 1, name: "Alex M.", score: 2450, isCurrentUser: false)
                LeaderboardRow(rank: 2, name: "Sarah L.", score: 2380, isCurrentUser: false)
                LeaderboardRow(rank: 3, name: "You", score: 2250, isCurrentUser: true)
                LeaderboardRow(rank: 4, name: "Mike R.", score: 2180, isCurrentUser: false)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
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

struct ChallengeCard: View {
    let title: String
    let description: String
    let progress: Int
    let total: Int
    let reward: String
    let icon: String
    let color: Color
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isCompleted ? .green : color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill((isCompleted ? .green : color).opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if isCompleted {
                    Text("✓ Completed")
                        .font(.caption2)
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                } else {
                    Text("\(progress)/\(total)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                } else {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                            .frame(width: 30, height: 30)
                        
                        Circle()
                            .trim(from: 0, to: Double(progress) / Double(total))
                            .stroke(color, lineWidth: 3)
                            .frame(width: 30, height: 30)
                            .rotationEffect(.degrees(-90))
                    }
                }
                
                Text(reward)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCompleted ? Color.green.opacity(0.05) : Color(UIColor.systemBackground))
        )
    }
}

struct AchievementProgressCard: View {
    let title: String
    let description: String
    let progress: Int
    let total: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Progress bar
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(progress)/\(total)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(Double(progress) / Double(total) * 100))%")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 4)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(color)
                                .frame(width: geometry.size.width * (Double(progress) / Double(total)), height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let name: String
    let score: Int
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(rank)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isCurrentUser ? .white : .secondary)
                .frame(width: 30)
            
            // Name
            Text(name)
                .font(.subheadline)
                .fontWeight(isCurrentUser ? .semibold : .regular)
                .foregroundColor(isCurrentUser ? .white : .primary)
            
            Spacer()
            
            // Score
            Text("\(score)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isCurrentUser ? .white : .primary)
            
            Text("pts")
                .font(.caption)
                .foregroundColor(isCurrentUser ? .white : .secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isCurrentUser ? Color.accentColor : .clear)
        )
    }
}

struct DetailedReportView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("All challenges and achievements would go here")
                        .font(.title2)
                        .padding()
                }
            }
            .navigationTitle("All Challenges")
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