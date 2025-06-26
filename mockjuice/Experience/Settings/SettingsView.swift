//
//  SettingsView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var showingResetAlert = false
    @State private var showingAboutSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                // Notifications Section
                Section("Notifications") {
                    SettingsToggle(
                        title: "Push Notifications",
                        subtitle: "Receive notifications from the app",
                        isOn: Binding(
                            get: { appState.settings.notifications.enablePushNotifications },
                            set: { appState.settings.notifications.enablePushNotifications = $0 }
                        ),
                        icon: "bell.fill",
                        color: .blue
                    )
                    
                    SettingsToggle(
                        title: "Daily Reminders",
                        subtitle: "Get reminded to study daily",
                        isOn: Binding(
                            get: { appState.settings.notifications.dailyReminders },
                            set: { appState.settings.notifications.dailyReminders = $0 }
                        ),
                        icon: "calendar",
                        color: .orange
                    )
                }
                
                // Appearance Section
                Section("Appearance") {
                    SettingsPicker(
                        title: "Color Scheme",
                        subtitle: "Choose your preferred theme",
                        selection: Binding(
                            get: { appState.settings.appearance.colorScheme },
                            set: { appState.settings.appearance.colorScheme = $0 }
                        ),
                        options: ["System", "Light", "Dark"],
                        icon: "paintbrush.fill",
                        color: .indigo
                    ) { newValue in
                        updateColorScheme(newValue)
                    }
                    
                    SettingsSlider(
                        title: "Font Size",
                        subtitle: "Adjust text size throughout the app",
                        value: Binding(
                            get: { appState.settings.appearance.fontSize },
                            set: { appState.settings.appearance.fontSize = $0 }
                        ),
                        range: 12...24,
                        step: 1,
                        icon: "textformat.size",
                        color: .brown
                    )
                }
                
                // Study Section
                Section("Study Settings") {
                    SettingsToggle(
                        title: "Haptic Feedback",
                        subtitle: "Feel vibrations for interactions",
                        isOn: Binding(
                            get: { appState.settings.study.hapticFeedback },
                            set: { appState.settings.study.hapticFeedback = $0 }
                        ),
                        icon: "iphone.radiowaves.left.and.right",
                        color: .blue
                    )
                    
                    SettingsSlider(
                        title: "Session Duration",
                        subtitle: "Default study session length",
                        value: Binding(
                            get: { appState.settings.study.sessionDuration },
                            set: { appState.settings.study.sessionDuration = $0 }
                        ),
                        range: 10...60,
                        step: 5,
                        unit: "min",
                        icon: "timer",
                        color: .orange
                    )
                }
                
                // MockJuice Section
                Section("MockJuice Experience") {
                    SettingsToggle(
                        title: "Challenge Notifications",
                        subtitle: "Get notified about new daily challenges",
                        isOn: Binding(
                            get: { appState.settings.notifications.enablePushNotifications },
                            set: { appState.settings.notifications.enablePushNotifications = $0 }
                        ),
                        icon: "target",
                        color: .purple
                    )
                    
                    SettingsToggle(
                        title: "Streak Reminders",
                        subtitle: "Daily reminders to maintain your learning streak",
                        isOn: Binding(
                            get: { appState.settings.notifications.dailyReminders },
                            set: { appState.settings.notifications.dailyReminders = $0 }
                        ),
                        icon: "flame.fill",
                        color: .orange
                    )
                    
                    SettingsToggle(
                        title: "Juice Points Celebrations",
                        subtitle: "Celebrate when you earn points and achievements",
                        isOn: Binding(
                            get: { appState.settings.study.hapticFeedback },
                            set: { appState.settings.study.hapticFeedback = $0 }
                        ),
                        icon: "star.fill",
                        color: .yellow
                    )
                    
                    SettingsPicker(
                        title: "Difficulty Level",
                        subtitle: "Adjust the challenge level for questions",
                        selection: Binding(
                            get: { appState.settings.appearance.colorScheme },
                            set: { appState.settings.appearance.colorScheme = $0 }
                        ),
                        options: ["Beginner", "Intermediate", "Advanced"],
                        icon: "dial.high.fill",
                        color: .red
                    ) { newValue in
                        HapticManager.shared.selection()
                        appState.showToast(message: "Difficulty set to \(newValue)")
                    }
                    
                    Button(action: {
                        HapticManager.shared.mediumImpact()
                        appState.showToast(message: "Opening mockjuice community...")
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.3.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(RoundedRectangle(cornerRadius: 6).fill(.blue))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Join Community")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Text("Connect with other learners")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Account Section
                Section("Account") {
                    Button("Reset All Settings") {
                        HapticManager.shared.mediumImpact()
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Reset All Settings", isPresented: $showingResetAlert) {
                Button("Reset", role: .destructive) {
                    resetAllSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will reset all settings to their default values.")
            }
        }
    }
    
    private func updateColorScheme(_ scheme: String) {
        HapticManager.shared.selection()
        switch scheme {
        case "Light":
            appState.updateColorScheme(.light)
        case "Dark":
            appState.updateColorScheme(.dark)
        default:
            appState.updateColorScheme(nil)
        }
    }
    
    private func resetAllSettings() {
        HapticManager.shared.heavyImpact()
        appState.settings = AppSettings()
        appState.showToast(message: "Settings reset to defaults")
    }
}

struct SettingsToggle: View {
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(RoundedRectangle(cornerRadius: 6).fill(color))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { _, _ in
                    HapticManager.shared.selection()
                }
        }
        .padding(.vertical, 2)
    }
}

struct SettingsPicker<T: Hashable>: View {
    let title: String
    let subtitle: String?
    @Binding var selection: T
    let options: [T]
    let icon: String
    let color: Color
    let onChange: ((T) -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(RoundedRectangle(cornerRadius: 6).fill(color))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text("\(option)")
                        .tag(option)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selection) { _, newValue in
                HapticManager.shared.selection()
                onChange?(newValue)
            }
        }
        .padding(.vertical, 2)
    }
}

struct SettingsSlider: View {
    let title: String
    let subtitle: String?
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String?
    let icon: String
    let color: Color
    
    init(
        title: String,
        subtitle: String? = nil,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 1,
        unit: String? = nil,
        icon: String,
        color: Color
    ) {
        self.title = title
        self.subtitle = subtitle
        self._value = value
        self.range = range
        self.step = step
        self.unit = unit
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(RoundedRectangle(cornerRadius: 6).fill(color))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Text("\(Int(value))\(unit ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .monospacedDigit()
            }
            
            Slider(value: $value, in: range, step: step)
                .tint(color)
                .onChange(of: value) { _, _ in
                    HapticManager.shared.selection()
                }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
} 