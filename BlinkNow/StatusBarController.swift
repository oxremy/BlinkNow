import AppKit

class StatusBarController {
    private var statusItem: NSStatusItem
    private var fadeWindow: FadeWindowController
    private var preferences: PreferencesManager
    private var observers = [NSObjectProtocol]()
    private var activeAnimationID: UUID?
    
    init(preferences: PreferencesManager) {
        self.preferences = preferences
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        fadeWindow = FadeWindowController(preferences: preferences)
        
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "eye.fill",
                accessibilityDescription: "Fade Screen"
            )
        }
        
        buildMenu()
        setupObservers()
    }
    
    private func buildMenu() {
        let menu = NSMenu()
        
        let fadeItem = NSMenuItem(
            title: "Fade Screen",
            action: nil,
            keyEquivalent: ""
        )
        
        let buttonView = FadeButtonView(
            title: "Fade Screen",
            preferences: preferences
        ) { [weak self] state in
            switch state {
            case .leftMouseDown:
                self?.activeAnimationID = self?.fadeWindow.startFade()
            case .leftMouseUp, .leftMouseDragged:
                if let id = self?.activeAnimationID {
                    self?.fadeWindow.endFade(animationID: id)
                }
            default: break
            }
        }
        buttonView.frame = NSRect(x: 0, y: 0, width: 200, height: 22)
        fadeItem.view = buttonView
        menu.addItem(fadeItem)
        
        // Preferences
        let prefsItem = NSMenuItem(title: "Preferences...", action: #selector(showPreferences(_:)), keyEquivalent: ",")
        prefsItem.target = self
        menu.addItem(prefsItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
        // Remove explicit frame sizing - let system handle layout
    }
    
    @objc private func showPreferences(_ sender: Any?) {
        PreferencesWindowController.show()
    }
    
    private func setupObservers() {
        let center = NotificationCenter.default
        observers.append(
            center.addObserver(forName: NSApplication.didResignActiveNotification,
                               object: nil,
                               queue: .main) { [weak self] _ in
                if let id = self?.activeAnimationID {
                    self?.fadeWindow.endFade(animationID: id)
                }
            }
        )
        
        observers.append(
            center.addObserver(forName: NSWindow.didResizeNotification,
                               object: nil,
                               queue: .main) { [weak self] _ in
                self?.fadeWindow.updateWindowFrames()
            }
        )
    }
    
    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
    
    func endActiveFade() {
        if let id = activeAnimationID {
            fadeWindow.endFade(animationID: id)
        }
    }
    
    @objc private func handleFadePress(_ sender: NSButton) {
        if sender.state == .on || sender.isHighlighted {
            activeAnimationID = fadeWindow.startFade()
        } else {
            if let id = activeAnimationID {
                fadeWindow.endFade(animationID: id)
            }
        }
    }
    
    private func createFadeScreenMenuItem() -> NSMenuItem {
        let item = NSMenuItem()
        let button = NSButton(title: "Fade Screen", target: self, action: #selector(handleFadePress))
        button.setButtonType(.momentaryPushIn)
        button.isBordered = false
        let trackingArea = NSTrackingArea(
            rect: button.bounds,
            options: [.activeInActiveApp, .mouseEnteredAndExited, .enabledDuringMouseDrag],
            owner: self,
            userInfo: nil
        )
        button.addTrackingArea(trackingArea)
        item.view = button
        return item
    }
    
    @objc private func toggleFade(sender: NSMenuItem) {}
    
    @objc private func handleHold(sender: NSMenuItem) {}
} 
