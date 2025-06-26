//
//  ContentView.swift
//  mockjuice
//
//  Created by Noor Hassan on 24/06/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        TabView(selection: Bindable(appState).selectedTab) {
            BrowseView()
                .tabItem {
                    Image(systemName: Tab.browse.icon)
                    Text(Tab.browse.rawValue)
                }
                .tag(Tab.browse)
            
            ActivityView()
                .tabItem {
                    Image(systemName: Tab.activity.icon)
                    Text(Tab.activity.rawValue)
                }
                .badge(Tab.activity.badgeCount ?? 0)
                .tag(Tab.activity)
            
            SummaryView()
                .tabItem {
                    Image(systemName: Tab.summary.icon)
                    Text(Tab.summary.rawValue)
                }
                .badge(Tab.summary.badgeCount ?? 0)
                .tag(Tab.summary)
            
            DiscoverView()
                .tabItem {
                    Image(systemName: Tab.discover.icon)
                    Text(Tab.discover.rawValue)
                }
                .tag(Tab.discover)
            
            SettingsView()
                .tabItem {
                    Image(systemName: Tab.settings.icon)
                    Text(Tab.settings.rawValue)
                }
                .tag(Tab.settings)
        }
        .tint(.accentColor)
        .overlay(alignment: .top) {
            if appState.showToast {
                ToastView(message: appState.toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appState.showToast)
        .onAppear {
            // Configure tab bar appearance for premium look
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
