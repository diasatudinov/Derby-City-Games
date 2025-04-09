import SwiftUI

class SettingsViewModelDC: ObservableObject {
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
}
