import AppKit

extension NSApplication {
    func presentCustomError(_ error: Error) {
        let alert = NSAlert()
        alert.messageText = "Animation Error"
        alert.informativeText = error.localizedDescription
        alert.addButton(withTitle: "Reset Preferences")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            PreferencesManager.shared.resetToDefaults()
        }
    }
} 
