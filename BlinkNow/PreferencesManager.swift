import Combine
import AppKit

class PreferencesManager: ObservableObject {
    static let shared = PreferencesManager()
    
    @Published var fadeSpeed: Double {
        didSet { UserDefaults.standard.set(fadeSpeed, forKey: "fadeSpeed") }
    }
    
    @Published var fadeColor: NSColor {
        didSet {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: fadeColor, requiringSecureCoding: true)
                UserDefaults.standard.set(data, forKey: "fadeColor")
            } catch {
                print("Error archiving color: \(error)")
            }
        }
    }
    
    init() {
        // Speed defaults (0.01-0.2 seconds)
        fadeSpeed = UserDefaults.standard.double(forKey: "fadeSpeed").clamped(to: 0.01...0.2)
        
        // Set default color to solid black
        fadeColor = NSColor.black
        
        // Then attempt to load saved color
        if let colorData = UserDefaults.standard.data(forKey: "fadeColor") {
            do {
                if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData) {
                    fadeColor = color
                }
            } catch {
                print("Error unarchiving color: \(error)")
            }
        }
    }
    
    func resetToDefaults() {
        fadeSpeed = 0.1
        fadeColor = NSColor.black
    }
}

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        return min(max(self, range.lowerBound), range.upperBound)
    }
} 