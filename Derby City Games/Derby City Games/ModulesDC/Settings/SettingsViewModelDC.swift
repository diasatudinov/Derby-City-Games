//
//  SettingsViewModelCTD.swift
//  Derby City Games
//
//  Created by Dias Atudinov on 07.04.2025.
//


import SwiftUI

class SettingsViewModelDC: ObservableObject {
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
}
