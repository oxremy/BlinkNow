# Task List

### 1. Core Infrastructure Setup (SwiftUI/AppKit Hybrid)

1.1 Menu Bar Implementation
- Create NSStatusItem with custom icon
  - Configure NSStatusBarButton with 22x22pt template image
  - Set autohighlight mode for visual feedback
- Build NSMenu with two NSMenuItems:
  - "Fade Screen" (keyEquivalent: "")
    - Add NSButton tracking with NSTrackingArea
    - Implement mouseDown/mouseUp handlers
  - "Preferences" (keyEquivalent: ",")
    - Connect to preferencesWindowController

1.2 Fade Window System
- Create NSWindow:
  - styleMask: [.borderless]
  - level: .screenSaver
  - backgroundColor: NSColor.clear
  - contentView: NSVisualEffectView (vibrancy)
- Animation Stack:
  - Core Animation (CAKeyframeAnimation)
  - Opacity path: 0.0 → 1.0 (user color)
  - TimingFunction: .easeInOut
  - Speed control via duration property


### 2. Preferences System (SwiftUI Implementation)

2.1 Preferences Window
- NSPanel configuration:
  - styleMask: [.titled, .closable]
  - contentSize: NSSize(width: 300, height: 200)
- UI Components:
  - Speed Slider:
    - NSSlider (0.01...0.2, continuous)
    - NumberFormatter for label
  - Color Well:
    - NSColorWell with alpha: false
    - Observer for color changes
  - Hyperlink Button:
    - NSAttributedString (underline + link)
    - NSTextField with NSCursor.pointingHand

2.2 Data Persistence
- PreferencesManager:
  - @Published properties:
    - animationSpeed: Double
    - fadeColor: NSColor
  - UserDefaults storage:
    - NSColor → Data (NSKeyedArchiver)
    - Double → Float conversion
  - Validation:
    - Clamp values on load
    - Fallback defaults

### 3. Fade Logic Implementation
3.1 Animation Control
- Event Handling:
  - NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown)
  - Track menu bar button frame during press
  - System-wide mouseUp detection
- Animation Stack:
  - CAAnimationGroup with:
    - opacity animation
    - color transition
  - CAMediaTiming protocol adoption
  - Transaction completion handlers

3.2 Color Mathematics
- Color Space Handling:
  - Convert NSColor → CGColor in sRGB
  - Gamma correction (1.8 → 2.2)
- Opacity Calculation:
  - Time-based interpolation
  - Easing function application
  - Screen brightness compensation

### 4. System Integration
4.1 State Management
- Combine Pipeline:
  - PreferencesManager → FadeWindowController
  - PassthroughSubject for real-time updates
- Notification Center:
  - NSApplication.didResignActiveNotification
  - NSWindow.didResizeNotification

4.2 Error Recovery
- Fallback States:
  - Default color: NSColor.black.withAlpha(0.8)
  - Default speed: 0.1s
- Animation Safeguards:
  - NSAnimationContext.runAnimationGroup
  - CATransaction.flush()

### 5. Deployment Preparation
5.1 Sandbox Configuration
- Entitlements:
  - com.apple.security.app-sandbox: true
  - com.apple.security.automation.apple-events
  - com.apple.security.files.user-selected.read-write
- Hardened Runtime:
  - Disable library validation
  - Allow unsigned executables

5.2 Packaging
- Asset Optimization:
  - 16x16@1x, 32x32@2x menu bar icons
  - PDF vector for NSStatusItem
- Code Signing:
  - Deep signing with --deep flag
  - Timestamp authority: Apple

### Implementation Order
1. Phase 1.1 → 1.2 (Core UI)
2. Phase 2.1 → 2.2 (Preferences)
3. Phase 3.1 → 3.2 (Animation)
4. Phase 4.1 → 4.2 (Integration)
5. Phase 5.1 → 5.2 (Deployment)


