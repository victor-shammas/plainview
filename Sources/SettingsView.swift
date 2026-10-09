import SwiftUI

/// Plainview › Settings: the reading preferences also found in the View menu.
struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            Picker("Font:", selection: $appState.selectedFont) {
                ForEach(ViewFont.allCases, id: \.self) { font in
                    Text(font.rawValue).tag(font)
                }
            }

            LabeledContent("Text size:") {
                HStack {
                    Slider(value: $appState.fontSize, in: 10...32, step: 2)
                    Text("\(Int(appState.fontSize)) pt")
                        .monospacedDigit()
                        .frame(width: 64, alignment: .trailing)
                }
            }

            LabeledContent("Line width:") {
                HStack {
                    Slider(value: $appState.maxWidth, in: 480...1400, step: 80)
                    Text("\(Int(appState.maxWidth)) px")
                        .monospacedDigit()
                        .frame(width: 64, alignment: .trailing)
                }
            }

            Toggle("Justify text", isOn: Binding(
                get: { appState.textAlignment == .justify },
                set: { appState.textAlignment = $0 ? .justify : .left }
            ))

            Picker("Appearance:", selection: $appState.appearance) {
                Text("Match System").tag(Appearance.auto)
                Text("Light").tag(Appearance.light)
                Text("Dark").tag(Appearance.dark)
            }
            .pickerStyle(.radioGroup)

            Button("Restore Defaults") {
                appState.restoreDefaults()
            }
        }
        .padding(20)
        .frame(width: 420)
    }
}
