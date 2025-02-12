import SwiftUI

class PreferencesWindowController: NSWindowController {
    static let shared = PreferencesWindowController()
    
    private init() {
        let hostingView = NSHostingView(rootView: PreferencesView())
        hostingView.frame = NSRect(x: 0, y: 0, width: 300, height: 200)
        
        let window = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        window.contentView = hostingView
        window.title = "Preferences"
        window.center()
        
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func show() {
        shared.window?.center()
        shared.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
} 