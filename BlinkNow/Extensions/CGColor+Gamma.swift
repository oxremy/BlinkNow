import CoreGraphics

extension CGColor {
    func adjustedForGamma(_ gamma: CGFloat) -> CGColor {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let components = components else { return self }
        
        var adjusted = components.map { pow($0, 1/gamma) }
        // Preserve alpha channel
        if components.count >= 4 {
            adjusted[3] = components[3] // Keep original alpha
        }
        return CGColor(colorSpace: colorSpace, components: adjusted) ?? self
    }
} 