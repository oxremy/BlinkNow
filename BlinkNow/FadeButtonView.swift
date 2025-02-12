import AppKit

class FadeButtonView: NSView {
    private var trackingArea: NSTrackingArea?
    private var isPressed = false
    private var preferences: PreferencesManager
    private var stateChangeHandler: (NSEvent.EventType) -> Void
    private let title: String
    private var isHovered = false
    private let hoverColor = NSColor.controlAccentColor.withAlphaComponent(0.3)
    private let pressedColor = NSColor.controlAccentColor.withAlphaComponent(0.5)
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 200, height: 22) // Standard menu item size
    }
    
    init(title: String, preferences: PreferencesManager, stateChange: @escaping (NSEvent.EventType) -> Void) {
        self.title = title
        self.preferences = preferences
        self.stateChangeHandler = stateChange
        super.init(frame: .zero)
        
        self.setAccessibilityElement(true)
        self.setAccessibilityRole(.button)
        self.setAccessibilityLabel(title)
        
        let icon = NSImage(systemSymbolName: "rectangle.inset.filled", accessibilityDescription: "Fade Screen")?
            .withSymbolConfiguration(.init(pointSize: 14, weight: .regular))
        let imageView = NSImageView(image: icon ?? NSImage())
        imageView.frame = NSRect(x: 160, y: 2, width: 18, height: 18)
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = self.trackingArea {
            removeTrackingArea(trackingArea)
        }
        
        let newTrackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeAlways, .mouseEnteredAndExited, .enabledDuringMouseDrag],
            owner: self,
            userInfo: nil
        )
        
        addTrackingArea(newTrackingArea)
        trackingArea = newTrackingArea
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if isPressed {
            pressedColor.setFill()
        } else if isHovered {
            hoverColor.setFill()
        } else {
            NSColor.clear.setFill()
        }
        dirtyRect.fill()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.controlTextColor,
            .paragraphStyle: paragraphStyle,
            .font: NSFont.menuBarFont(ofSize: 14)
        ]
        
        let titleRect = NSRect(x: 20, y: 3, width: bounds.width - 40, height: bounds.height)
        title.draw(with: titleRect, attributes: attributes)
    }
    
    override func mouseDown(with event: NSEvent) {
        isPressed = true
        stateChangeHandler(.leftMouseDown)
        needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        isPressed = false
        stateChangeHandler(.leftMouseUp)
        needsDisplay = true
    }
    
    override func mouseEntered(with event: NSEvent) {
        isHovered = true
        needsDisplay = true
    }
    
    override func mouseExited(with event: NSEvent) {
        isHovered = false
        needsDisplay = true
    }
} 