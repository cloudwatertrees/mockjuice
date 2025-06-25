//
//  CategoryDetailView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: Category
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @State private var searchText = ""
    
    private var filteredItems: [CategoryItem] {
        if searchText.isEmpty {
            return category.items
        } else {
            return category.items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredItems) { item in
                    CategoryItemCard(item: item) {
                        // Handle item tap
                        HapticManager.shared.mediumImpact()
                        appState.showToast(message: "Opening \(item.title)")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search items...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Filter") {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Filter options coming soon")
                }
                .foregroundColor(.accentColor)
            }
        }
    }
}

struct CategoryItemCard: View {
    let item: CategoryItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Status indicator
                ZStack {
                    Circle()
                        .fill(item.isCompleted ? .green : .gray.opacity(0.3))
                        .frame(width: 12, height: 12)
                    
                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        DifficultyBadge(difficulty: item.difficulty)
                    }
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Label(item.duration, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if item.isCompleted {
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.medium)
                        } else {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: false)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button("Mark as Completed", systemImage: "checkmark.circle") {
                HapticManager.shared.success()
            }
            
            Button("Add to Favorites", systemImage: "heart") {
                HapticManager.shared.lightImpact()
            }
            
            Button("Share", systemImage: "square.and.arrow.up") {
                HapticManager.shared.lightImpact()
            }
        }
    }
}

struct DifficultyBadge: View {
    let difficulty: String
    
    private var badgeColor: Color {
        switch difficulty.lowercased() {
        case "beginner": return .green
        case "intermediate": return .orange
        case "advanced": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        Text(difficulty)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(badgeColor)
            )
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: Category.sampleData[0])
            .environment(AppState())
    }
} 