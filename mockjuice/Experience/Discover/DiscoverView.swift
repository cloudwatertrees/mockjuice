//
//  DiscoverView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI

struct DiscoverView: View {
    @Environment(AppState.self) private var appState
    @State private var searchText = ""
    @State private var isRefreshing = false
    @State private var selectedFilter: DiscoverFilter = .all
    
    private var discoveryItems: [DiscoveryItem] {
        let items = DiscoveryItem.sampleData
        let filtered = selectedFilter == .all ? items : items.filter { $0.category == selectedFilter }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(DiscoverFilter.allCases, id: \.self) { filter in
                            FilterPill(
                                title: filter.rawValue,
                                isSelected: selectedFilter == filter
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    selectedFilter = filter
                                }
                                HapticManager.shared.selection()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
                
                // Discovery Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(discoveryItems) { item in
                            DiscoveryCard(item: item)
                                .onTapGesture {
                                    HapticManager.shared.lightImpact()
                                    appState.showToast(message: "Exploring \(item.title)")
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .refreshable {
                    await refreshDiscoveryContent()
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search tips, guides, and more...")
            .onChange(of: searchText) { oldValue, newValue in
                if !newValue.isEmpty {
                    HapticManager.shared.selection()
                }
            }
        }
    }
    
    @MainActor
    private func refreshDiscoveryContent() async {
        isRefreshing = true
        HapticManager.shared.lightImpact()
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        appState.showToast(message: "Fresh content loaded")
        isRefreshing = false
        HapticManager.shared.success()
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color(.systemGray6))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DiscoveryCard: View {
    let item: DiscoveryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Icon
                ZStack {
                    Circle()
                        .fill(item.color.gradient)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: item.iconName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(item.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if item.isNew {
                    Text("NEW")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(.orange)
                        )
                }
            }
            
            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Text("\(item.readTime) min read")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Supporting Models
enum DiscoverFilter: String, CaseIterable {
    case all = "All"
    case tips = "Tips"
    case guides = "Guides"
    case news = "News"
    case community = "Community"
}

struct DiscoveryItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: DiscoverFilter
    let iconName: String
    let color: Color
    let readTime: Int
    let isNew: Bool
    
    static let sampleData: [DiscoveryItem] = [
        DiscoveryItem(
            title: "Master the 2-Second Rule",
            description: "Learn the essential following distance technique that could save your life on the road. Understand when and how to apply this critical safety principle.",
            category: .tips,
            iconName: "stopwatch",
            color: .blue,
            readTime: 3,
            isNew: true
        ),
        DiscoveryItem(
            title: "Complete Theory Test Guide 2024",
            description: "Everything you need to know about the UK theory test, from booking to passing. Updated with the latest DVSA requirements and question formats.",
            category: .guides,
            iconName: "book.fill",
            color: .green,
            readTime: 8,
            isNew: false
        ),
        DiscoveryItem(
            title: "New Hazard Perception Clips Added",
            description: "The DVSA has released 12 new hazard perception video clips. Practice with the latest scenarios to stay ahead of the curve.",
            category: .news,
            iconName: "eye.fill",
            color: .red,
            readTime: 2,
            isNew: true
        ),
        DiscoveryItem(
            title: "Top 5 Theory Test Mistakes",
            description: "Avoid these common pitfalls that trip up thousands of learners every year. Learn from others' mistakes and boost your chances of success.",
            category: .tips,
            iconName: "exclamationmark.triangle.fill",
            color: .orange,
            readTime: 5,
            isNew: false
        ),
        DiscoveryItem(
            title: "Highway Code Updates 2024",
            description: "Stay current with the latest changes to the Highway Code. New rules for cyclists, pedestrians, and electric vehicle charging.",
            category: .news,
            iconName: "road.lanes",
            color: .purple,
            readTime: 6,
            isNew: true
        ),
        DiscoveryItem(
            title: "Study Group Success Stories",
            description: "Real learners share how they passed their theory test on the first try. Get inspired by their strategies and tips.",
            category: .community,
            iconName: "person.3.fill",
            color: .indigo,
            readTime: 4,
            isNew: false
        )
    ]
}

#Preview {
    DiscoverView()
        .environment(AppState())
} 