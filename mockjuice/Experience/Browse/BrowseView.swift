//
//  BrowseView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI

struct BrowseView: View {
    @Environment(AppState.self) private var appState
    @State private var searchText = ""
    @State private var isRefreshing = false
    
    private var filteredCategories: [Category] {
        if searchText.isEmpty {
            return appState.categories
        } else {
            return appState.categories.filter { category in
                category.title.localizedCaseInsensitiveContains(searchText) ||
                category.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredCategories) { category in
                        NavigationLink(destination: CategoryDetailView(category: category)) {
                            CategoryCard(category: category)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onTapGesture {
                            HapticManager.shared.lightImpact()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .refreshable {
                await refreshCategories()
            }
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search categories...")
            .onChange(of: searchText) { oldValue, newValue in
                if !newValue.isEmpty {
                    HapticManager.shared.selection()
                }
            }
        }
    }
    
    @MainActor
    private func refreshCategories() async {
        isRefreshing = true
        HapticManager.shared.lightImpact()
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        appState.showToast(message: "Categories updated")
        isRefreshing = false
        HapticManager.shared.success()
    }
}

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorForString(category.color).gradient)
                    .frame(width: 60, height: 60)
                
                Image(systemName: category.iconName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(category.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if category.isNew {
                        Text("NEW")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(.orange)
                            )
                    }
                }
                
                Text(category.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("\(category.itemCount) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: false)
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

#Preview {
    BrowseView()
        .environment(AppState())
} 