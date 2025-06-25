//
//  ProfileView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var isEditing = false
    @State private var editedName = ""
    @State private var editedEmail = ""
    @State private var showingImagePicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: UIImage?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Profile header
                    profileHeader
                    
                    // Stats section
                    statsSection
                    
                    // Achievements section
                    achievementsSection
                    
                    // Account actions
                    accountActionsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveProfile()
                        } else {
                            startEditing()
                        }
                    }
                    .fontWeight(.medium)
                }
            }
            .photosPicker(isPresented: $showingImagePicker, selection: $selectedPhoto, matching: .images)
            .onChange(of: selectedPhoto) { _, _ in
                loadSelectedPhoto()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 20) {
            // Profile image
            Button(action: {
                if isEditing {
                    HapticManager.shared.lightImpact()
                    showingImagePicker = true
                }
            }) {
                ZStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 120, height: 120)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.secondary)
                            }
                    }
                    
                    if isEditing {
                        Circle()
                            .fill(.black.opacity(0.3))
                            .frame(width: 120, height: 120)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                    }
                }
            }
            .disabled(!isEditing)
            
            // Name and email
            VStack(spacing: 8) {
                if isEditing {
                    TextField("Name", text: $editedName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                } else {
                    Text(appState.user.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if isEditing {
                    TextField("Email", text: $editedEmail)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                } else {
                    Text(appState.user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Join date and level
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Level \(appState.user.level)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                    
                    Text("Current Level")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(spacing: 4) {
                    Text(formatJoinDate(appState.user.joinDate))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Member Since")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Stats")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Total Points",
                    value: "\(appState.user.totalPoints)",
                    icon: "star.fill",
                    color: .yellow
                )
                
                StatCard(
                    title: "Achievements",
                    value: "\(appState.user.achievements.count)",
                    icon: "trophy.fill",
                    color: .orange
                )
                
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
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Opening all achievements...")
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(appState.user.achievements.prefix(3), id: \.self) { achievement in
                    AchievementBadge(title: achievement)
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
    
    private var accountActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ActionButton(
                    title: "Share Profile",
                    subtitle: "Share your progress with friends",
                    icon: "square.and.arrow.up",
                    color: .blue
                ) {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Sharing profile...")
                }
                
                ActionButton(
                    title: "Export Data",
                    subtitle: "Download your data",
                    icon: "doc.text",
                    color: .green
                ) {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Preparing data export...")
                }
                
                ActionButton(
                    title: "Privacy Settings",
                    subtitle: "Manage your privacy preferences",
                    icon: "lock.fill",
                    color: .purple
                ) {
                    HapticManager.shared.lightImpact()
                    appState.showToast(message: "Opening privacy settings...")
                }
                
                ActionButton(
                    title: "Delete Account",
                    subtitle: "Permanently delete your account",
                    icon: "trash.fill",
                    color: .red
                ) {
                    HapticManager.shared.heavyImpact()
                    appState.showToast(message: "Account deletion not available in demo")
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
    
    private func startEditing() {
        HapticManager.shared.lightImpact()
        editedName = appState.user.name
        editedEmail = appState.user.email
        isEditing = true
    }
    
    private func saveProfile() {
        HapticManager.shared.mediumImpact()
        
        // Validate inputs
        guard !editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            appState.showToast(message: "Name cannot be empty")
            return
        }
        
        guard isValidEmail(editedEmail) else {
            appState.showToast(message: "Please enter a valid email")
            return
        }
        
        // Save changes
        appState.user.name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        appState.user.email = editedEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        
        isEditing = false
        appState.showToast(message: "Profile updated successfully")
        HapticManager.shared.success()
    }
    
    private func loadSelectedPhoto() {
        guard let selectedPhoto = selectedPhoto else { return }
        
        Task {
            do {
                if let data = try await selectedPhoto.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        self.profileImage = image
                        HapticManager.shared.success()
                        appState.showToast(message: "Profile photo updated")
                    }
                }
            } catch {
                await MainActor.run {
                    appState.showToast(message: "Failed to load image")
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func formatJoinDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

struct AchievementBadge: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForAchievement(title))
                .font(.title3)
                .foregroundColor(.yellow)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(.yellow.opacity(0.1))
                )
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundColor(.green)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func iconForAchievement(_ title: String) -> String {
        switch title.lowercased() {
        case "first steps": return "foot.circle.fill"
        case "quick learner": return "bolt.fill"
        case "consistency": return "calendar"
        default: return "star.fill"
        }
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
} 