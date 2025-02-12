import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Speed Control
            VStack(alignment: .leading) {
                Text("Fade Speed: \(preferences.fadeSpeed, specifier: "%.1f")s")
                    .font(.headline)
                Slider(value: $preferences.fadeSpeed, in: 1...10, step: 0.1) {
                    Text("Fade Speed")
                }
            }
            
            // Color Picker
            VStack(alignment: .leading) {
                Text("Fade Color:")
                    .font(.headline)
                ColorPicker("", selection: Binding<Color>(
                    get: { Color(preferences.fadeColor) },
                    set: { preferences.fadeColor = NSColor($0) }
                ))
                .labelsHidden()
            }
            
            // Hyperlink
            HStack {
                Spacer()
                LinkButton(title: "made with love by oxremy", url: URL(string: "https://github.com/oxremy")!)
                    .onHover { inside in
                        if inside {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.arrow.push()
                        }
                    }
                Spacer()
            }
        }
        .padding(20)
        .frame(width: 300, height: 200)
    }
}

struct LinkButton: View {
    let title: String
    let url: URL
    
    var body: some View {
        Button(action: { NSWorkspace.shared.open(url) }) {
            Text(title)
                .underline()
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
