//
//  BlinkNowApp.swift
//  BlinkNow
//
//  Created by oxremy on 2/12/25.
//

import SwiftUI

@main
struct BlinkNowApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusBarController = StatusBarController(preferences: PreferencesManager.shared)
        checkAccessibilityPermissions()
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        statusBarController?.endActiveFade()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        PreferencesManager.shared.resetToDefaults()
    }
    
    private func checkAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        guard AXIsProcessTrustedWithOptions(options as CFDictionary) else {
            showAccessibilityAlert()
            return
        }
    }
    
    private func showAccessibilityAlert() {
        let alert = NSAlert()
        alert.messageText = "Accessibility Permissions Required"
        alert.informativeText = "Please enable BlinkNow in System Preferences > Security & Privacy > Privacy > Accessibility"
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Quit")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            NSWorkspace.shared.open(URL(
                string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
            )!)
        } else {
            NSApp.terminate(nil)
        }
    }
}
