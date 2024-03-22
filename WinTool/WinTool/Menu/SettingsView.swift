import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, keybinds
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            KeybindsSettingsView()
                .tabItem {
                    Label("Keybinds", systemImage: "keyboard.badge.ellipsis")
                }
                .tag(Tabs.keybinds)
        }
        .frame(width: 400, height: 200)
    }
}

struct GeneralSettingsView: View {
    @AppStorage(Main.shared.shortcutUserDefaultsKey) var shortcutsEnabled = true
    // @AppStorage("fontSize") private var fontSize = 12.0

    var body: some View {
        Form {
            Toggle("Shortcuts", isOn: $shortcutsEnabled)
                .onChange(of: shortcutsEnabled) {
                    Main.shared.shortcutsEnabled = shortcutsEnabled
                }
        }
        // Form {
        //     Toggle("Show Previews", isOn: $showPreview)
        //     Slider(value: $fontSize, in: 9...96) {
        //         Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
        //     }
        // }
        // .padding(20)
    }
}

struct KeybindsSettingsView: View {
    var body: some View {
        Form {
            ScrollView(.vertical) {
                Button("Reset All") {
                    for item in Main.shared.shortcuts.list {
                        KeyboardShortcuts.reset(item.name)
                    }
                }
                VStack {
                    ForEach(Main.shared.$shortcuts.list) { $shortcut in
                        HStack {
                            Text(shortcut.title)
                            KeyboardShortcuts.Recorder(for: shortcut.name)
                        }
                    }
                    .padding(2)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(5)
    }
}
