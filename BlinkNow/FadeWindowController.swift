import AppKit
import QuartzCore
import Combine

class FadeWindowController {
    private let window: NSWindow
    private let preferences: PreferencesManager
    private var animationLayers: [CALayer] = []
    private let animationQueue = DispatchQueue(label: "com.oxremy.BlinkNow.animation", qos: .userInteractive)
    private var currentAnimations = [CALayer: CAAnimation]()
    private var cancellables = Set<AnyCancellable>()
    
    init(preferences: PreferencesManager) {
        self.preferences = preferences
        
        window = NSWindow(contentRect: .zero,
                          styleMask: [.borderless],
                          backing: .buffered,
                          defer: false)
        window.level = .screenSaver
        window.isOpaque = false
        window.backgroundColor = .clear
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        let solidView = NSView()
        solidView.wantsLayer = true
        solidView.layer?.backgroundColor = preferences.fadeColor.cgColor
        window.contentView = solidView
        
        preferences.$fadeColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateActiveColor()
            }
            .store(in: &cancellables)
    }
    
    private func convertedColor() -> CGColor {
        let srgbColor = preferences.fadeColor.usingColorSpace(.sRGB) ?? preferences.fadeColor
        return srgbColor.withAlphaComponent(preferences.fadeColor.alphaComponent).cgColor
    }
    
    private func updateActiveColor() {
        guard !animationLayers.isEmpty else { return }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        animationLayers.forEach {
            $0.backgroundColor = convertedColor()
        }
        CATransaction.commit()
    }
    
    private func handleAnimationError(_ error: Error) {
        DispatchQueue.main.async {
            NSApplication.shared.presentCustomError(error)
            self.endFade()
            PreferencesManager.shared.resetToDefaults()
        }
    }
    
    func startFade() {
        animationQueue.async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.sync {
                // Remove existing layers
                self.animationLayers.forEach { $0.removeFromSuperlayer() }
                self.animationLayers.removeAll()
                
                // Create windows for all screens
                NSScreen.screens.forEach { screen in
                    let fadeLayer = CALayer()
                    fadeLayer.frame = screen.frame
                    fadeLayer.backgroundColor = self.convertedColor()
                    fadeLayer.opacity = 0.0
                    
                    let screenWindow = NSWindow(contentRect: screen.frame,
                                                styleMask: [.borderless],
                                                backing: .buffered,
                                                defer: false)
                    screenWindow.level = .screenSaver
                    screenWindow.isOpaque = false
                    screenWindow.backgroundColor = .clear
                    screenWindow.ignoresMouseEvents = true
                    screenWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
                    
                    let solidView = NSView()
                    solidView.wantsLayer = true
                    solidView.layer?.addSublayer(fadeLayer)
                    screenWindow.contentView = solidView
                    
                    let animation = CABasicAnimation(keyPath: "opacity")
                    animation.fromValue = 0.0
                    animation.toValue = 1.0
                    animation.duration = self.preferences.fadeSpeed
                    animation.fillMode = .forwards
                    animation.isRemovedOnCompletion = false
                    
                    fadeLayer.add(animation, forKey: "fadeIn")
                    screenWindow.orderFrontRegardless()
                    
                    self.animationLayers.append(fadeLayer)
                }
            }
        }
    }
    
    func endFade() {
        animationQueue.async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.sync {
                self.animationLayers.forEach { layer in
                    let animation = CABasicAnimation(keyPath: "opacity")
                    animation.fromValue = 1.0
                    animation.toValue = 0.0
                    animation.duration = self.preferences.fadeSpeed
                    animation.fillMode = .forwards
                    animation.isRemovedOnCompletion = false
                    
                    layer.add(animation, forKey: "fadeOut")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.preferences.fadeSpeed) {
                    self.animationLayers.forEach { $0.removeFromSuperlayer() }
                    self.animationLayers.removeAll()
                }
            }
        }
    }
    
    func updateWindowFrames() {
        DispatchQueue.main.async {
            for (index, screen) in NSScreen.screens.enumerated() {
                guard index < self.animationLayers.count else { return }
                self.animationLayers[index].frame = screen.frame
            }
        }
    }
}

private class ErrorHandlingDelegate: NSObject, CAAnimationDelegate {
    let handler: (Error) -> Void
    
    init(handler: @escaping (Error) -> Void) {
        self.handler = handler
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !flag {
            handler(NSError(domain: "AnimationError", code: 1, 
                          userInfo: [NSLocalizedDescriptionKey: "Animation interrupted unexpectedly"]))
        }
    }
} 